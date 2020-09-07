library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity equality_comparator is
	generic (
		N: integer := 32 -- number of bits
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		o: out std_logic
	);
end entity equality_comparator;

architecture behavioral of equality_comparator is
	signal tmp: std_logic_vector(N-1 downto 0);
	
begin
	tmp <= a xnor b;
	o <= and_reduce(tmp);
end architecture behavioral;