library ieee;
use ieee.std_logic_1164.all; 

entity iv is
	port (
		a: in std_logic;
		y: out std_logic
	);
end iv;


architecture behavioral of iv is

begin
	y <= not(a);
end behavioral;
