library ieee;
use ieee.std_logic_1164.all;

entity pg_net_block is
	port (
		a: in std_logic;
		b: in std_logic;
		g: out std_logic;
		p: out std_logic
	);
end entity pg_net_block;

architecture behavioral of pg_net_block is

begin
	g <= a and b; -- generate gi
	p <= a xor b; -- propagate pi
end architecture behavioral;
