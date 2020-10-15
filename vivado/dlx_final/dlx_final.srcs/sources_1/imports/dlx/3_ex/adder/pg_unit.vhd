library ieee;
use ieee.std_logic_1164.all;

entity pg_unit is
	port (
		a: in std_logic; -- Gi:k
		b: in std_logic; -- Pi:k
		c: in std_logic; -- Gk-1:j
		d: in std_logic; -- Pk-1:j
		p: out std_logic; -- Pi:j 
		g: out std_logic -- Gi:j
	);
end entity pg_unit;

architecture behavioral of pg_unit is

begin
	g <= a or (b and c);
	p <= b and d;
end architecture behavioral;