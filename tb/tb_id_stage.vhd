library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_id_stage is
end tb_id_stage;

architecture test of tb_id_stage is
	component id_stage is
		port (
			clk: in std_logic;
			rst: in std_logic;

			pc: in std_logic_vector(31 downto 0);

			-- RF interface
			instr: in std_logic_vector(25 downto 0); -- instruction bits, without opcode
			i_instr: in std_logic; -- 1 if the istruction is of type I, 0 otherwise

			wp_addr: in std_logic_vector(4 downto 0); -- write port address, coming from the WB stage
			wp_en: in std_logic; -- write port enable
			wp: in std_logic_vector(31 downto 0); -- data to be written in the RF
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
			lo_in: in std_logic_vector(31 downto 0); -- input data for the LO register
			hi_in: in std_logic_vector(31 downto 0); -- input data for the HI register

			-- sign extender interface
			is_signed: in std_logic; -- 1 if extension is signed, 0 if unsigned
			sign_ext_sel: in std_logic; -- 1 if the 16 bits input must be used, 0 if the 26 bits input must be used

			-- output interface
			a_selector: in std_logic; -- 0 to select the PC as output, 1 to select the read port 1
			b_selector: in std_logic; -- 0 to select the immediate as output, 1 to select the read port 2
			a: out std_logic_vector(31 downto 0); -- first operand output
			b: out std_logic_vector(31 downto 0); -- second operand output
			dest_reg: out std_logic_vector(4 downto 0) -- propagate the destination register to the subsequent stages
		);
	end component id_stage;

	type arr is array (0 to 4) of std_logic_vector(31 downto 0);

	constant period: time := 1 ns;
	constant instructions: arr := (	X"20010005",  -- addi r1, r0, #5
									X"20020006",  -- addi r2, r0, #6
									X"00221820",  -- add r3, r1, r2
									X"1060000B",  -- beqz r3, #11
									X"8000000C"); -- j 32

	constant pcs : arr := (			X"00000000",
									X"00000004",
									X"00000008",
									X"0000000C",
									X"00000010");	 

	signal clk, rst, i_instr, wp_en, hilo_wr_en, is_signed, sign_ext_sel, a_selector, b_selector: std_logic;
	signal rp1_out_sel, rp2_out_sel: std_logic_vector(1 downto 0);
	signal wp_addr, dest_reg: std_logic_vector(4 downto 0);
	signal instr: std_logic_vector(25 downto 0);
	signal pc, wp, lo_in, hi_in, a, b: std_logic_vector(31 downto 0);

begin
	dut: id_stage
		port map (
			clk  => clk,
			rst => rst,
			pc => pc,
			instr => instr,
			i_instr => i_instr,
			wp_addr => wp_addr,
			wp_en => wp_en,
			wp => wp,
			rp1_out_sel => rp1_out_sel,
			rp2_out_sel => rp2_out_sel,
			hilo_wr_en => hilo_wr_en,
			lo_in => lo_in,
			hi_in => hi_in,
			is_signed => is_signed,
			sign_ext_sel => sign_ext_sel,
			a_selector => a_selector,
			b_selector => b_selector,
			a => a,
			b => b,
			dest_reg => dest_reg
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
	begin
		rst <= '0';
		wait for period/2;
		rst <= '1';

		-- cycle 0
		pc <= pcs(0);
		instr <= instructions(0)(25 downto 0);
		i_instr <= '1';
		wp_addr <= (others  => '0');
		wp_en <= '0';
		wp <= (others => '0');
		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		hilo_wr_en <= '0';
		lo_in <= (others => '0');
		hi_in <= (others => '0');
		is_signed <= '1';
		sign_ext_sel <= '1';
		a_selector <= '1';
		b_selector <= '0';
		wait for period;

		-- cycle 1, assume r1 has been written back
		pc <= pcs(1);
		instr <= instructions(1)(25 downto 0);
		i_instr <= '1';
		wp_addr <= "00001";
		wp_en <= '1';
		wp <= std_logic_vector(to_unsigned(5, 32));
		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		hilo_wr_en <= '0';
		lo_in <= (others => '0');
		hi_in <= (others => '0');
		is_signed <= '1';
		sign_ext_sel <= '1';
		a_selector <= '1';
		b_selector <= '0';
		wait for period;

		-- cycle 2, assume r2 has been written back
		pc <= pcs(2);
		instr <= instructions(2)(25 downto 0);
		i_instr <= '0';
		wp_addr <= "00010";
		wp_en <= '1';
		wp <= std_logic_vector(to_unsigned(6, 32));
		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		hilo_wr_en <= '0';
		lo_in <= (others => '0');
		hi_in <= (others => '0');
		is_signed <= '1';
		sign_ext_sel <= '1';
		a_selector <= '1';
		b_selector <= '1';
		wait for period;

		-- cycle 3, assume r3 has been written back
		pc <= pcs(3);
		instr <= instructions(3)(25 downto 0);
		i_instr <= '1';
		wp_addr <= "00011";
		wp_en <= '1';
		wp <= std_logic_vector(to_unsigned(11, 32));
		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		hilo_wr_en <= '0';
		lo_in <= (others => '0');
		hi_in <= (others => '0');
		is_signed <= '1';
		sign_ext_sel <= '1';
		a_selector <= '1';
		b_selector <= '0';
		wait for period;

		-- cycle 3, assume r3 has been written back
		pc <= pcs(4);
		instr <= instructions(4)(25 downto 0);
		i_instr <= '0';
		wp_addr <= "00000";
		wp_en <= '0';
		wp <= std_logic_vector(to_unsigned(11, 32));
		rp1_out_sel <= "00";
		rp2_out_sel <= "00";
		hilo_wr_en <= '0';
		lo_in <= (others => '0');
		hi_in <= (others => '0');
		is_signed <= '1';
		sign_ext_sel <= '0';
		a_selector <= '0';
		b_selector <= '0';
		wait;
	end process test_proc;

end test;
