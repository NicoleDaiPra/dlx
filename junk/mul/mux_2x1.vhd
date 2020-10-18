library ieee;
use ieee.std_logic_1164.all;

entity mux_2x1 is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sel: in std_logic;
		o: out std_logic_vector(N-1 downto 0)
	);
end entity mux_2x1;

architecture behavioral of mux_2x1 is

begin
	with sel select o <=
		a when '1',
		b when others;
end architecture behavioral;