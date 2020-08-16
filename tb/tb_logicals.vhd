library ieee;
use ieee.std_logic_1164.all;

entity tb_logicals is
end tb_logicals;

architecture behavioral of tb_logicals is
	component logicals is
		generic (
			N: integer := 32
		);

		port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sel: in std_logic_vector(3 downto 0);
		
		nd0: out std_logic_vector(N-1 downto 0);
		nd1: out std_logic_vector(N-1 downto 0);
		nd2: out std_logic_vector(N-1 downto 0);
		nd3: out std_logic_vector(N-1 downto 0);
		
		res: out std_logic_vector(N-1 downto 0)
	);
	end component logicals;

	signal a, b, res: std_logic_vector(31 downto 0);
	signal sel: std_logic_vector(3 downto 0);

	constant to_wait: time := 1 ns;

begin
	dut: entity work.logicals(structural)
		generic map (
			N => 32
		)
		port map (
			a => a,
			b => b,
			sel => sel,
			res => res		
		);

    test: process
    begin
        a <= X"3F4C983A";
        b <= X"3F000810";
        sel <= "1000"; -- AND
        wait for to_wait;
    
        sel <= "1110"; -- OR
        wait for to_wait;
    
        sel <= "0110"; -- XOR
        wait for to_wait;
    
        sel <= "0111"; -- NAND
        wait for to_wait;
    
        sel <= "0001"; -- NOR
        wait for to_wait;
    
        sel <= "1001"; -- NXOR
        wait;
	end process test;
end behavioral;
