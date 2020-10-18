library ieee;
use ieee.std_logic_1164.all;

entity tb_carry_save is
end tb_carry_save;

architecture tb of tb_carry_save is

	component carry_save_adder is
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
	end component carry_save_adder;

	constant N: integer := 64;
	constant period: time := 5 ns;

	signal a, b, c, sum: std_logic_vector(N-1 downto 0);
	signal cout: std_logic;


begin

	dut: carry_save_adder 
		generic map (
			N => N
		)
		port map (
			a => a,
			b => b,
			c => c,
			sum => sum,
			cout => cout
		);


	process
	begin
		a <= X"aaaaaaaaaaaaaaaa";
		b <= X"5555555555555555";
		c <= X"1111111111111111";
		wait for period;
		
		a <= X"2222222222222222";
		b <= X"5555555555555555";
		c <= X"aaaaaaaaaaaaaaaa";
		wait for period;
		
		a <= X"0000000000000000";
		b <= X"1111111111111111";
		c <= X"3333333333333333";
		wait for period;
		wait;
	end process;

end tb;
