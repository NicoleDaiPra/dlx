library ieee;
use ieee.std_logic_1164.all;

entity tb_sign_extender is

end tb_sign_extender;

architecture test of tb_sign_extender is
	component sign_extender is
		port (
			i0_15: in std_logic_vector(15 downto 0);
			i16_25: in std_logic_vector(9 downto 0);
			is_signed: in std_logic; -- 1 if signed, 0 if unsigned
			sel: in std_logic; -- 1 if 16 bits input must be used, 0 if 26 bit input must be used
			o: out std_logic_vector(31 downto 0)
		);
	end component sign_extender;

	signal i: std_logic_vector(25 downto 0);
	signal is_signed, sel: std_logic;
	signal o: std_logic_vector(31 downto 0);

begin
	dut: sign_extender
		port map (
			i0_15 => i(15 downto 0),
			i16_25 => i(25 downto 16),
			is_signed => is_signed,
			sel => sel,
			o => o
		);

	test_proc: process
	begin
		i <= "01101010100011001100110011";
		sel <= '0';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '0';
		is_signed <= '1';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '1';
		wait for 1 ns;

		i <= "01011001101111100001111000";
		sel <= '0';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '0';
		is_signed <= '1';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '1';
		wait for 1 ns;

		i <= "11100001110000000011111111";
		sel <= '0';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '0';
		is_signed <= '1';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '1';
		wait for 1 ns;

		i <= "11110000011111000011111100";
		sel <= '0';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '0';
		is_signed <= '1';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '0';
		wait for 1 ns;

		sel <= '1';
		is_signed <= '1';
		wait;
	end process test_proc;

end test;
