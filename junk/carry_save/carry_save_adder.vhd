library ieee;
use ieee.std_logic_1164.all;

entity carry_save_adder is
	generic (
		N: integer := 32
		);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		c: in std_logic_vector(N-1 downto 0);
		sum: out std_logic_vector(N-1 downto 0);
		cout: out std_logic
		);
end carry_save_adder;

architecture Behavioral of carry_save_adder is

	component fa is
		port (
			a: in	std_logic;
			b: in	std_logic;
			cin: in	std_logic;
			s:	out	std_logic;
			cout: out std_logic
		);
	end component fa;

	component rca_generic_struct is
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
	end component rca_generic_struct;

	signal partial_sum: std_logic_vector(N-1 downto 0);
	signal carries: std_logic_vector(N-1 downto 0);
	signal final_sum: std_logic_vector(N downto 0);
	signal ext_ps, ext_c: std_logic_vector(N downto 0);

begin

	fa_loop: for i in 0 to N-1 generate
			fa_i: fa
				port map(
					a => a(i),
					b => b(i),
					cin => c(i),
					s => partial_sum(i),
					cout => carries(i)
				);
		end generate fa_loop;

    ext_ps <= '0'&partial_sum;
    ext_c <= carries&'0';
    
	rca: rca_generic_struct
		generic map (
			N => N+1
		)
		port map (
				a => ext_ps,
				b => ext_c,
				cin => '0',
				s => final_sum,
				cout => open
			);	

	sum <= final_sum(N-1 downto 0);
	cout <= final_sum(N);
	
end Behavioral;
