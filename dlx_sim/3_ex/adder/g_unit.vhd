library ieee;
use ieee.std_logic_1164.all;

entity g_unit is
	port (
		a: in std_logic; -- Gi:k
		b: in std_logic; -- Pi:k
		c: in std_logic; -- Gk-1:j
		g: out std_logic -- Gi:j
	);
end entity g_unit;

architecture behavioral of g_unit is

begin
	g <= a or (b and c);
end architecture behavioral;