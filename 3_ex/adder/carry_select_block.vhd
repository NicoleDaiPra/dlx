library ieee;
use ieee.std_logic_1164.all;

entity carry_select_block is
	generic (
		N: integer := 4
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(N-1 downto 0)
	);
end entity carry_select_block;

architecture structural of carry_select_block is
	component rca_generic is
		generic (
        	N: integer := 8
    	);
	    port (
	        a: in std_logic_vector(N-1 downto 0);
	        b: in std_logic_vector(N-1 downto 0);
	        cin: in std_logic;
	        s: out std_logic_vector(N-1 downto 0);
	        cout: out std_logic
	    );
	end component rca_generic;

	component mux_2x1 is
		generic (
			N: integer:= 4
		);
		port (a: in	std_logic_vector(N-1 downto 0);
			  b: in	std_logic_vector(N-1 downto 0);
			  sel: in std_logic;
			  o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_2x1;

	signal s0, s1: std_logic_vector(N-1 downto 0);
begin
	rca_0: rca_generic
		generic map (
			N => N
		)
		port map (
			a => a,
			b => b,
			cin => '0',
			s => s0,
			cout => open
		);

	rca_1: rca_generic
		generic map (
			N => N
		)
		port map (
			a => a,
			b => b,
			cin => '1',
			s => s1,
			cout => open
		);
	-- multiplexer that takes as input the results of the  rcas
	mux: mux_2x1
		generic map (
			N => N
			)
		port map (
			a => s1,
			b => s0,
			sel => cin,
			o => s
		);
end architecture structural;