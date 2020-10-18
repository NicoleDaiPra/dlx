library ieee;
use ieee.std_logic_1164.all;

-- calculate one bitwise operation between the following:
-- AND: sel <= "1000"
-- OR: sel <= "1110"
-- XOR: sel <= "0110"
-- NAND: sel <= "0111"
-- NOR: sel <= "0001"
-- NXOR: sel <= "1001"

entity logicals is
	generic (
		N: integer := 32
	);

	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sel: in std_logic_vector(3 downto 0);
		res: out std_logic_vector(N-1 downto 0)
	);
end logicals;

architecture structural of logicals is
	component nand3 is
		port (
			a: in std_logic;
			b: in std_logic;
			c: in std_logic;
			z: out std_logic
		);
	end component nand3;

	component nand4 is
		port (
			a: in std_logic;
			b: in std_logic;
			c: in std_logic;
			d: in std_logic;
			z: out std_logic
		);
	end component nand4;

	signal a_neg, b_neg: std_logic_vector(N-1 downto 0);
	signal n0, n1, n2, n3: std_logic_vector(N-1 downto 0);

begin
	a_neg <= not a;
	b_neg <= not b;

	l: for i in 0 to N-1 generate
		l0: entity work.nand3(behavioral)
			port map (
				a => sel(0),
				b => a_neg(i),
				c => b_neg(i),
				z => n0(i)
			);

		l1: entity work.nand3(behavioral)
			port map (
				a => sel(1),
				b => a_neg(i),
				c => b(i),
				z => n1(i)
			);
			
		l2: entity work.nand3(behavioral)
			port map (
				a => sel(2),
				b => a(i),
				c => b_neg(i),
				z => n2(i)
			);
			
		l3: entity work.nand3(behavioral)
			port map (
				a => sel(3),
				b => a(i),
				c => b(i),
				z => n3(i)
			);
	end generate l;

	logical_out: for i in 0 to N-1 generate
		lo: entity work.nand4(behavioral)
			port map (
				a => n0(i),
				b => n1(i),
				c => n2(i),
				d => n3(i),
				z => res(i)
			);
	end generate logical_out;
end structural;
