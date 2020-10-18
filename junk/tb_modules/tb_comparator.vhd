library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_comparator is

end entity tb_comparator;

architecture test of tb_comparator is
	component comparator is
		generic (
			N: integer := 32
		);
		port (
			res: in std_logic_vector(N-1 downto 0); -- adder/subtractor result
			cout: in std_logic; -- adder/subtractor cout
			a_msb: in std_logic; -- MSB of the first operand
			b_msb: in std_logic; -- MSB of the second operand
			op_sign: in std_logic; -- 1 if the operands are signed, 0 otherwise
			le: out std_logic; -- less than or equal
			lt: out std_logic; -- less than
			ge: out std_logic; -- greater than or equal
			gt: out std_logic; -- greater than
			eq: out std_logic; -- equal
			ne: out std_logic -- not equal
		);
	end component comparator;

	component p4_adder is
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
	end component p4_adder;

	constant N : integer := 8;
	constant period : time := 1 ns; 

	signal a, b, res: std_logic_vector(N-1 downto 0);
	signal op_sign, cout, le, lt, ge, gt, eq, ne: std_logic;

	-- signed -> op_sign = 1
	-- unsigned -> op_sign = 0
begin
	dut: comparator
		generic map (
			N => N
		)
		port map (
			res => res,
			cout => cout,
			a_msb => a(N-1),
			b_msb => b(N-1),
			op_sign => op_sign,
			le => le,
			lt => lt,
			ge => ge,
			gt => gt,
			eq => eq,
			ne => ne
		);

	p4: p4_adder
		generic map (
			N => N
		)
		port map (
			a => a,
			b => b,
			cin => '1',
			s => res,
			cout => cout,
			carries => open
		);

	test_proc: process
	begin
		a <= (others => '0');
		b <= (others => '0');
		op_sign <= '0';
		wait for period;

		assert (le = '1') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '0') report "gt is wrong" severity FAILURE;
		assert (eq = '1') report "eq is wrong" severity FAILURE;
		assert (ne = '0') report "ne is wrong" severity FAILURE;

		a <= X"06";
		wait for period;

		assert (le = '0') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '1') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		b <= X"06";
		wait for period;

		assert (le = '1') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '0') report "gt is wrong" severity FAILURE;
		assert (eq = '1') report "eq is wrong" severity FAILURE;
		assert (ne = '0') report "ne is wrong" severity FAILURE;

		a <= X"03";
		wait for period;

		assert (le = '1') report "le is wrong" severity FAILURE;
		assert (lt = '1') report "lt is wrong" severity FAILURE;
		assert (ge = '0') report "ge is wrong" severity FAILURE;
		assert (gt = '0') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		a <= X"06";
		b <= X"03";
		wait for period;

		assert (le = '0') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '1') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		a <= X"90";
		wait for period;

		assert (le = '0') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '1') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		op_sign <= '1';
		wait for period;

		assert (le = '1') report "le is wrong" severity FAILURE;
		assert (lt = '1') report "lt is wrong" severity FAILURE;
		assert (ge = '0') report "ge is wrong" severity FAILURE;
		assert (gt = '0') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		b <= X"90";
		wait for period;

		assert (le = '1') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '0') report "gt is wrong" severity FAILURE;
		assert (eq = '1') report "eq is wrong" severity FAILURE;
		assert (ne = '0') report "ne is wrong" severity FAILURE;

		op_sign <= '1';
		a <= X"03";
		wait for period;

		assert (le = '0') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '1') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		op_sign <= '0';
		wait for period;

		assert (le = '1') report "le is wrong" severity FAILURE;
		assert (lt = '1') report "lt is wrong" severity FAILURE;
		assert (ge = '0') report "ge is wrong" severity FAILURE;
		assert (gt = '0') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		a <= X"A0";
		b <= X"02";
		wait for period;

		assert (le = '0') report "le is wrong" severity FAILURE;
		assert (lt = '0') report "lt is wrong" severity FAILURE;
		assert (ge = '1') report "ge is wrong" severity FAILURE;
		assert (gt = '1') report "gt is wrong" severity FAILURE;
		assert (eq = '0') report "eq is wrong" severity FAILURE;
		assert (ne = '1') report "ne is wrong" severity FAILURE;

		wait;
	end process test_proc;
end architecture test;