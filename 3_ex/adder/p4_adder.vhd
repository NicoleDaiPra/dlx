library ieee;
use ieee.std_logic_1164.all;

entity p4_adder is
	generic (
		N: integer := 32 
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(N-1 downto 0);
		cout: out std_logic;
		carries: out std_logic_vector(N/4 downto 0)
	);
end entity p4_adder;

architecture struct of p4_adder is
	component carry_generator is
    generic (
        N: integer := 32
    );
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		cout: out std_logic_vector(N/4-1 downto 0)
	);
	end component carry_generator;

	component sum_generator is
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
	end component sum_generator;

	signal carry: std_logic_vector(N/4-1 downto 0); -- stores the result of the carry generator
	signal carry_sum: std_logic_vector(N/4-1 downto 0); -- stores the input of the sum_generator

begin
	cg: carry_generator
		generic map (
			N => N	
		)
		port map (
			a => a,
			b => b,
			cin => cin,
			cout => carry
		);

	carry_sum <= carry(N/4 -2 downto 0)&cin;	
	cout <= carry(N/4-1);
	carries <= carry&cin;

	sg: sum_generator
		generic map (
			NBIT_PER_BLOCK => 4,
			NBLOCKS => N/4	
		)
		port map (
			a => a,
			b => b,
			cin => carry_sum,
			s => s
		);		
end architecture struct;