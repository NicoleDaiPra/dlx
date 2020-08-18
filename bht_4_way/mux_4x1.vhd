library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1 is
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
end entity mux_4x1;

architecture behavioral of mux_4x1 is
begin
	with sel select o <=
		a when "00",
		b when "01",
		c when "10",
		d when others;
end architecture behavioral;