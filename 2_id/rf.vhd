library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- MIPS32 ABI compliant register file.
-- It is composed by 32 general purpose registers and has two read ports and a single write port.
-- It also have two indirectly accessible registers, LO and HI, used to store the results of operations
-- like multiplications and divisions that need to operate/store results on 64 bits.
entity rf is
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
		-- 		11 output all 0s
		rp1_out_sel: in std_logic_vector(1 downto 0);
		-- rp2_out_sel values:
		-- 		00 for an arch register
		-- 		01 for the LO register
		-- 		10 for the HI register
		-- 		11 output all 0s
		rp2_out_sel: in std_logic_vector(1 downto 0);
		hilo_wr_en: in std_logic; -- 1 if the HI and LO register must be written
		lo_in: in std_logic_vector(N-1 downto 0); -- input data for the LO register
		hi_in: in std_logic_vector(N-1 downto 0) -- input data for the HI register
	);
end rf;

architecture behavioral of rf is
	component reg_en is
		generic (
			N: integer := 32
		);
		port (
			d: in std_logic_vector(N-1 downto 0);
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			q: out std_logic_vector(N-1 downto 0)	
		);
	end component reg_en;

	type data_array is array (0 to 31) of std_logic_vector(N-1 downto 0);

	signal enable: std_logic_vector(31 downto 1);
	signal regout_array: data_array;
	signal lo_out, hi_out: std_logic_vector(N-1 downto 0);

begin
	regout_array(0) <= (others => '0'); -- "zero" or "r0" register

	-- General purpose register instantiation
	GPR_gen: for i in 1 to 31 generate
		reg: reg_en
			generic map (
				N => N
			)
			port map (
				d => wp,
				en => enable(i),
				clk => clk,
				rst => rst,
				q => regout_array(i)
			);
	end generate GPR_gen;

	-- LO register
	lo: reg_en
		generic map (
			N => N
		)
		port map (
			d => lo_in,
			en => hilo_wr_en,
			clk => clk,
			rst => rst,
			q => lo_out
		);

	-- HI register
	hi: reg_en
		generic map (
			N => N
		)
		port map (
			d => hi_in,
			en => hilo_wr_en,
			clk => clk,
			rst => rst,
			q => hi_out
		);


	comblogic: process(regout_array, rp1_addr, rp2_addr, wp_addr, wp_en, wp, lo_out, hi_out, rp1_out_sel, rp2_out_sel)
		variable gpr_rp1, gpr_rp2: std_logic_vector(N-1 downto 0);
	begin
		enable <= (others => '0');

		-- select among the architectural registers the ones that have to go out
		gpr_rp1 := regout_array(to_integer(unsigned(rp1_addr)));
		gpr_rp2 := regout_array(to_integer(unsigned(rp2_addr)));

		-- read port 1 output selection
		case (rp1_out_sel) is
			when "00" =>
				rp1 <= gpr_rp1;

			when "01" =>
				rp1 <= lo_out;

			when "10" => 
				rp1 <= hi_out;

			when others =>
				rp1 <= (others => '0');
		end case;

		-- read port 2 output selection
		case (rp2_out_sel) is
			when "00" =>
				rp2 <= gpr_rp2;

			when "01" =>
				rp2 <= lo_out;

			when "10" => 
				rp2 <= hi_out;

			when others =>
				rp2 <= (others => '0');
		end case;

		if (unsigned(wp_addr) /= 0 and wp_en = '1') then
			enable(to_integer(unsigned(wp_addr))) <= '1';
		end if;
	end process comblogic;

end behavioral;
