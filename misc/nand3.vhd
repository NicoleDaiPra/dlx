library ieee;
use ieee.std_logic_1164.all;

entity nand3 is
	port (
		a: in std_logic;
		b: in std_logic;
		c: in std_logic;
		z: out std_logic
	);
end nand3;

architecture behavioral of nand3 is
begin
	z <= not (a and b and c);
end behavioral;
