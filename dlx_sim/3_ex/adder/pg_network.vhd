library ieee;
use ieee.std_logic_1164.all;

entity pg_network is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		g: out std_logic_vector(N-1 downto 0);
		p: out std_logic_vector(N-1 downto 0)
	);
end entity pg_network;

architecture struct of pg_network is
	component pg_net_block is
		port (
			a: in std_logic;
			b: in std_logic;
			g: out std_logic;
			p: out std_logic
		);
	end component pg_net_block;

begin

	
	g(0) <= (a(0) and b(0)) or ((a(0) xor b(0)) and cin); -- generate of the first bit (support subtraction)

	gen : for i in 1 to N-1 generate
		pnb_i: pg_net_block
			port map (
				a => a(i),
				b => b(i),
				g => g(i),
				p => p(i)
			);
	end generate gen;
end architecture struct;