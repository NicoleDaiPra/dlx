library ieee;
use ieee.std_logic_1164.all;

entity and2 is
	port (
		a: in std_logic;
		b: in std_logic;
		o: out std_logic
	);
end entity and2;

architecture behavioral of and2 is
begin
	o <= a and b;
end architecture behavioral;