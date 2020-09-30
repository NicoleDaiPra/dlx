library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

-- Determine from the add/sub outputs the relationship between the operands
entity comparator is
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
end entity comparator;

architecture behavioral of comparator is
	signal res_nor: std_logic;
	signal cout_not: std_logic;
	signal lt_signed, gt_signed: std_logic;
begin
	res_nor <= not or_reduce(res);
	cout_not <= not cout;
	lt_signed <= (a_msb and (not b_msb)) and op_sign;
	gt_signed <= ((not a_msb) and b_msb) and op_sign;

	eq <= res_nor;
	ne <= not res_nor; -- hopefully the synthesizer notices that here there's a double negation
	le <= (lt_signed or res_nor or ((not res_nor) and cout_not)) and (not gt_signed);
	lt <= (lt_signed or ((not lt_signed) and (cout_not))) and (not gt_signed);
	ge <= (cout or gt_signed) and (not lt_signed); 
	gt <= (gt_signed or (cout and (not res_nor))) and (not lt_signed);
end architecture behavioral;