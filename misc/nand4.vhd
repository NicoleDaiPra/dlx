library ieee;
use ieee.std_logic_1164.all;

entity nand4 is
	port (
		a: in std_logic;
		b: in std_logic;
		c: in std_logic;
		d: in std_logic;
		z: out std_logic
	);
end nand4;

architecture behavioral of nand4 is
begin
	z <= not (a and b and c and d);
end behavioral;
