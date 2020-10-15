library ieee;
use ieee.std_logic_1164.all;

-- This entity encapsulate the ID stage datapath components
entity id_stage is
	port (
		clk: in std_logic;
		rst: in std_logic;

		pc: in std_logic_vector(31 downto 0);

		-- RF interface
		instr: in std_logic_vector(25 downto 0); -- instruction bits, without opcode
		i_instr: in std_logic; -- 1 if the istruction is of type I, 0 otherwise
		j_instr: in std_logic; -- 1 if the instruction is of type J, o otherwise
		wp_addr: in std_logic_vector(4 downto 0); -- write port address, coming from the WB stage
		wp_en: in std_logic; -- write port enable
		wp: in std_logic_vector(31 downto 0); -- data to be written in the RF
		-- rp1_out_sel values:
		-- 		00 for an arch register
		-- 		01 for the LO register
		-- 		10 for the HI register
		-- 		11 output all 0s
		rp1_out_sel: in std_logic_vector(1 downto 0);
		-- rp2_out_sel values:
		-- 		00 for an arch register
		-- 		01 for the LO register
		-- 		10 for the HI register
		-- 		11 output all 0s
		rp2_out_sel: in std_logic_vector(1 downto 0);
		hilo_wr_en: in std_logic; -- 1 if the HI and LO register must be written
		lo_in: in std_logic_vector(31 downto 0); -- input data for the LO register
		hi_in: in std_logic_vector(31 downto 0); -- input data for the HI register

		-- sign extender interface
		is_signed: in std_logic; -- 1 if extension is signed, 0 if unsigned
		sign_ext_sel: in std_logic; -- 1 if the 16 bits input must be used, 0 if the 26 bits input must be used

		-- output interface
		a_selector: in std_logic; -- 0 to select the PC as output, 1 to select the read port 1
		b_selector: in std_logic; -- 0 to select the immediate as output, 1 to select the read port 2
		rs_out: out std_logic_vector(4 downto 0); -- index value of the rd register
		rt_out: out std_logic_vector(4 downto 0); -- index value of the rt register
		data_tbs_selector: in std_logic; -- 0 to select the output of rp2, 1 to select the npc
		a: out std_logic_vector(31 downto 0); -- first operand output
		b: out std_logic_vector(31 downto 0); -- second operand output
		dest_reg: out std_logic_vector(4 downto 0); -- propagate the destination register to the subsequent stages
		npc: out std_logic_vector(31 downto 0); -- propagate the PC to the EXE stage
		imm: out std_logic_vector(31 downto 0); -- propagate the immediate (needed for PC + offset calculation)
		data_tbs: out std_logic_vector(31 downto 0) -- data to be stored (used for str ops and to pass the return address to be stored in r31 in case of a jalr)
	);
end id_stage;

architecture behavioral of id_stage is
	component rf is
		generic (
			N: integer := 32 -- size of a single register
		);
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- ISA accessible registers interface
			rp1_addr: in std_logic_vector(4 downto 0); -- register address for rp1
			rp2_addr: in std_logic_vector(4 downto 0); -- register address for rp2
			wp_addr: in std_logic_vector(4 downto 0); -- register address for wp
			wp_en: in std_logic; -- write enable
			wp: in std_logic_vector(N-1 downto 0); -- write port
			rp1: out std_logic_vector(N-1 downto 0); -- read port 1
			rp2: out std_logic_vector(N-1 downto 0); -- read port 2

			-- special registers interface
			-- rp1_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 reserved
			rp1_out_sel: in std_logic_vector(1 downto 0);
			-- rp2_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 reserved
			rp2_out_sel: in std_logic_vector(1 downto 0);
			hilo_wr_en: in std_logic; -- 1 if the HI and LO register must be written
			lo_in: in std_logic_vector(N-1 downto 0); -- input data for the LO register
			hi_in: in std_logic_vector(N-1 downto 0) -- input data for the HI register
		);
	end component rf;

	component sign_extender is
		port (
			i0_15: in std_logic_vector(15 downto 0);
			i16_25: in std_logic_vector(9 downto 0);
			is_signed: in std_logic; -- 1 if signed, 0 if unsigned
			sel: in std_logic; -- 1 if 16 bits input must be used, 0 if 26 bit input must be used
			o: out std_logic_vector(31 downto 0)
		);
	end component sign_extender;

	component mux_2x1 is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_2x1;

	component mux_4x1 is
		generic (
			N: integer := 22
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			c: in std_logic_vector(N-1 downto 0);
			d: in std_logic_vector(N-1 downto 0);
			sel: in std_logic_vector(1 downto 0);
			o: out std_logic_vector(N-1 downto 0)
		);	
	end component mux_4x1;

	constant reg_31 : std_logic_vector(4 downto 0) := "11111"; 

	signal dest_reg_mux_enc: std_logic_vector(1 downto 0);
	signal d_reg: std_logic_vector(4 downto 0);
	signal immediate: std_logic_vector(31 downto 0);
	signal rp1, rp2: std_logic_vector(31 downto 0);

begin
	npc <= pc; -- propagate the PC

	-- I type and R type have the destination register in 2 different positions, output the correct value
	-- moreover in case of a JAL a value of 31 must be forced in the dest_reg
	dest_reg_mux_enc <= j_instr&i_instr;
	dest_selector: mux_4x1
		generic map (
			N => 5
		)
		port map (
			a => instr(20 downto 16), -- rt register in I type instructions
			b => instr(15 downto 11), -- rd register in R type instructions
			c => reg_31, -- rd register for JAL
			d => reg_31, -- rd register for JAL
			sel => dest_reg_mux_enc,
			o => dest_reg
		);

	rs_out <= instr(25 downto 21);
	rt_out <= instr(20 downto 16);

	-- register file instantiation
	reg_file: rf
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,
			rp1_addr => instr(25 downto 21), -- rs register
			rp2_addr => instr(20 downto 16), -- rt register for an R-type instruction
			wp_addr => wp_addr, -- write address coming from the WB stage
			wp_en => wp_en,
			wp => wp,
			rp1 => rp1,
			rp2 => rp2,
			rp1_out_sel => rp1_out_sel,
			rp2_out_sel => rp2_out_sel,
			hilo_wr_en => hilo_wr_en,
			lo_in => lo_in,
			hi_in => hi_in
		);

	-- sign extender instantiation
	sign_ext: sign_extender
		port map (
			i0_15 => instr(15 downto 0),
			i16_25 => instr(25 downto 16),
			is_signed => is_signed,
			sel => sign_ext_sel,
			o => immediate
		);

	imm <= immediate; -- propagate the immediate

	-- select the output of the a port (choose between rp1 and the pc)
	a_sel: mux_2x1
		generic map (
			N => 32
		)
		port map (
			a => rp1,
			b => pc,
			sel => a_selector,
			o => a
		);

	-- select the output of the b port (choose between rp2 and the immediate)
	b_sel: mux_2x1
		generic map (
			N => 32
		)
		port map (
			a => rp2,
			b => immediate,
			sel => b_selector,
			o => b
		);

	-- select the output of data_tbs (choose between rp2 and the immediate)
	opb_sel: mux_2x1
		generic map (
			N => 32
		)
		port map (
			a => pc,
			b => rp2,
			sel => data_tbs_selector,
			o => data_tbs
		);
end behavioral;
