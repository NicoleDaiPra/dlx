library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_generator is
	generic (
		NBIT_PER_BLOCK: integer := 4;
		NBLOCKS: integer := 8
	);
	port (
		a: in std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		b: in std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		cin: in std_logic_vector(NBLOCKS-1 downto 0);
		s: out std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0)
	);
end entity sum_generator;

architecture structural of sum_generator is
	component carry_select_block is
		generic (
			N: integer := 4
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			cin: in std_logic;
			s: out std_logic_vector(N-1 downto 0)
		);
	end component carry_select_block;
begin
	g0: for i in 0 to NBLOCKS-1 generate
		csb_i: carry_select_block
			generic map (
				N => NBIT_PER_BLOCK	
			)
			port map (
				a => a(((i + 1) * NBIT_PER_BLOCK) - 1 downto i * (NBIT_PER_BLOCK)),
				b => b(((i + 1) * NBIT_PER_BLOCK) - 1 downto i * (NBIT_PER_BLOCK)),
				cin => cin(i),
				s => s(((i + 1) * NBIT_PER_BLOCK) - 1 downto i * (NBIT_PER_BLOCK))
			);
	end generate g0;
end architecture structural;