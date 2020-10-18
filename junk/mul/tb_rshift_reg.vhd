library ieee;
use ieee.std_logic_1164.all;

entity tb_rshift_reg is

end tb_rshift_reg;

architecture test of tb_rshift_reg is
	component rshift_reg is
			generic (
			N: integer := 32;
			S: integer := 2
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			shift: in std_logic; -- tell whether the register have to sample the input data or the shifted one
			en: in std_logic;
			d: in std_logic_vector(N-1 downto 0);
			q: out std_logic_vector(N-1 downto 0)
		);
	end component rshift_reg;

	constant period: time := 1 ns; 

	signal clk, rst, shift, en: std_logic;
	signal d, q1, q2, q3, q4: std_logic_vector(63 downto 0);

begin
	dut1: rshift_reg
		generic map (
			N => 64,
			S => 1
		)
		port map (
			clk => clk,
			rst => rst,
			shift => shift,
			en => en,
			d => d,
			q => q1
		);

		dut2: rshift_reg
		generic map (
			N => 64,
			S => 2
		)
		port map (
			clk => clk,
			rst => rst,
			shift => shift,
			en => en,
			d => d,
			q => q2
		);

		dut3: rshift_reg
		generic map (
			N => 64,
			S => 3
		)
		port map (
			clk => clk,
			rst => rst,
			shift => shift,
			en => en,
			d => d,
			q => q3
		);

		dut4: rshift_reg
		generic map (
			N => 64,
			S => 4
		)
		port map (
			clk => clk,
			rst => rst,
			shift => shift,
			en => en,
			d => d,
			q => q4
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
			en <= '0';
			shift <= '0';
			d <= (others => '1');
			wait for 5*period;

			en <= '1';
			wait for 5*period;

			shift <= '1';
			wait;
		end process;

end test;
