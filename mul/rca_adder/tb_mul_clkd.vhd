----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mul_clkd is
end tb_mul_clkd;

architecture test of tb_mul_clkd is
	component mul_clkd is
		port (
			clk: in std_logic;
			rst: in std_logic;
			en: in std_logic;
			en_a_neg: in std_logic;
			en_shift: in std_logic;
			shift: in std_logic;
			neg: in std_logic; -- used to negate "a" before actually multiply
			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(31 downto 0);
			it: in std_logic_vector(3 downto 0);
			res: out std_logic_vector(63 downto 0)
		);
	end component mul_clkd;

	constant period : time := 10 ns;
	constant it_limit : std_logic_vector(3 downto 0) := "1110"; 

	signal clk, rst, en, en_a_neg, en_shift, shift, neg: std_logic;
	signal a, b: std_logic_vector(31 downto 0);
	signal res: std_logic_vector(63 downto 0);
	signal it: std_logic_vector(3 downto 0);

begin
	dut: mul_clkd
		port map (
			clk => clk,
			rst => rst,
			en => en,
			en_a_neg => en_a_neg,
			en_shift => en_shift,
			shift => shift,
			neg => neg,
			a => a,
			b => b,
			it => it,
			res => res
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
	begin
		rst <= '0';
		wait for period/2;

		rst <= '1';

		a <= X"00000051";
		b <= X"00000006";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;



		a <= X"FFFFFFAE";
		b <= X"FFFFFFF3";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;



		a <= X"FFFFFFAE";
		b <= X"20000721";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;



		a <= X"00000002";
		b <= X"20000721";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		wait for period;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;



		a <= X"FFFFFFFF";
		b <= X"FFFFFFFF";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		wait for period;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;



		a <= X"7FFFFFFF";
		b <= X"7FFFFFFF";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		wait for period;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;



		a <= X"00000000";
		b <= X"FFFFFFFF";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		wait for period;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;



		a <= X"12345678";
		b <= X"00000000";

		-- sample a and b
		en <= '1';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		-- sample a_neg
		en <= '0';
		en_a_neg <= '1';
		en_shift <= '0';
		shift <= '0';
		neg <= '1';
		it <= (others => '0');
		wait for period;

		-- perform multiplication
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '1';
		shift <= '1';
		neg <= '0';
		it <= (others => '0');
		wait for period;

		for i in 1 to to_integer(unsigned(it_limit)) loop
			it <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		wait for period;

		-- stop every operation
		en <= '0';
		en_a_neg <= '0';
		en_shift <= '0';
		shift <= '0';
		neg <= '0';
		it <= (others => '0');
		wait for period;
		wait;
	end process test_proc;
end test;
