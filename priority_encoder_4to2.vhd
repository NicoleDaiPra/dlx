library ieee;
use ieee.std_logic_1164.all;

entity priority_encoder_4to2 is
	port (
		a: in std_logic;
		b: in std_logic;
		c: in std_logic;
		d: in std_logic;
		enc: out std_logic_vector(1 downto 0)
	);
end entity priority_encoder_4to2;

architecture behavioral of priority_encoder_4to2 is
	signal sel: std_logic_vector(3 downto 0);
begin
	sel <= a&b&c&d;
	
	with sel select enc <=
		"00" when "1000" | "1001" | "1010" | "1011" | "1100" | "1101" | "1110" | "1111",
		"01" when "0100" | "0101" | "0110" | "0111",
		"10" when "0010" | "0011",
		"11" when others;
end architecture behavioral;