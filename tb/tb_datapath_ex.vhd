library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_datapath is
end tb_datapath;

architecture tb of tb_datapath is

	component datapath is
		port(
			clk: std_logic;
			rst: std_logic;

	    	-- operands
	    	a: in std_logic_vector(31 downto 0);
	    	b: in std_logic_vector(31 downto 0);
	    	Rd_in: in std_logic_vector(4 downto 0);

	    	-- forwarded ex/mem operands
	    	hi_fw_ex: in std_logic_vector(31 downto 0);
	    	a_adder_fw_ex: in std_logic_vector(31 downto 0);
	    	b_adder_fw_ex: in std_logic_vector(31 downto 0);
	    	a_shift_fw_ex: in std_logic_vector(31 downto 0);
	    	b_shift_fw_ex: in std_logic_vector(4 downto 0);

	    	-- forwarded mem/wb operands
	    	hi_fw_mem: in std_logic_vector(31 downto 0);
	    	a_adder_fw_mem: in std_logic_vector(31 downto 0);
	    	b_adder_fw_mem: in std_logic_vector(31 downto 0);
	    	a_shift_fw_mem: in std_logic_vector(31 downto 0);
	    	b_shift_fw_mem: in std_logic_vector(4 downto 0);
	    	
	    	-- control signals
	    	sub_add: in std_logic;						-- 1 if it is a subtraction, 0 otherwise
	    	shift_type: in std_logic_vector(3 downto 0);
	    	log_type: in std_logic_vector(3 downto 0);
	    	op_type: in std_logic_vector(1 downto 0);	--00: add/sub, 01: mul, 10: shift/rot, 11: log
	    	op_sign: in std_logic; 						-- 1 if the operands are signed, 0 otherwise
	    	it: in std_logic_vector(3 downto 0);		-- iteration
	    	neg: in std_logic;							-- used to negate a before actually multiplying
	    	en_add: in std_logic;
	    	en_mul: in std_logic;
	    	en_shift: in std_logic;
	    	en_a_neg: in std_logic;
	    	shift_reg: in std_logic;
	    	en_shift_reg: in std_logic;
	    	en_output: in std_logic;
	    	fw_op_a: in std_logic_vector(2 downto 0);
	    	fw_op_b: in std_logic_vector(1 downto 0);
	    	en_rd: in std_logic;

	    	-- outputs
	    	Rd_out: out std_logic_vector(4 downto 0);
	    	alu_out_high_ex: out std_logic_vector(31 downto 0);
	    	alu_out_low_ex: out std_logic_vector(31 downto 0);
	    	alu_flags_ex: out std_logic_vector(2 downto 0); 	
			le: out std_logic; -- less than or equal
			lt: out std_logic; -- less than
			ge: out std_logic; -- greater than or equal
			gt: out std_logic; -- greater than
			eq: out std_logic; -- equal
			ne: out std_logic -- not equal
		);
	end component datapath;

	constant period: time := 10 ns;
	constant it_limit : std_logic_vector(3 downto 0) := "1110";

	signal clk, rst: std_logic;
	signal a, b: std_logic_vector(31 downto 0);
	signal Rd_in: std_logic_vector(4 downto 0);
	signal a_adder_fw_ex, a_adder_fw_mem, b_adder_fw_ex, b_adder_fw_mem: std_logic_vector(31 downto 0);
	signal a_shift_fw_ex, a_shift_fw_mem, hi_fw_ex, hi_fw_mem: std_logic_vector(31 downto 0);
	signal b_shift_fw_ex, b_shift_fw_mem: std_logic_vector(4 downto 0);

	signal sub_add, op_sign, neg: std_logic;
	signal shift_type, log_type, it: std_logic_vector(3 downto 0);
	signal op_type: std_logic_vector(1 downto 0);
	signal en_add, en_mul, en_shift, en_a_neg, en_shift_reg, en_output, en_rd: std_logic;
	signal shift_reg: std_logic;
	signal fw_a: std_logic_vector(2 downto 0);
	signal fw_b: std_logic_vector(1 downto 0);

	signal Rd_out: std_logic_vector(4 downto 0);
	signal alu_out_high_ex, alu_out_low_ex: std_logic_vector(31 downto 0);
	signal alu_flags_ex: std_logic_vector(2 downto 0);
	signal le, lt, ge, gt, eq, ne: std_logic;

begin

	dut: datapath
		port map (
			clk => clk,
			rst => rst,

	    	-- operands
	    	a => a,
	    	b => b,
	    	Rd_in => Rd_in,

	    	-- forwarded ex/mem operands
	    	hi_fw_ex => hi_fw_ex,
	    	a_adder_fw_ex => a_adder_fw_ex,
	    	b_adder_fw_ex => b_adder_fw_ex,
	    	a_shift_fw_ex => a_shift_fw_ex,
	    	b_shift_fw_ex => b_shift_fw_ex,

	    	-- forwarded mem/wb operands
	    	hi_fw_mem => hi_fw_mem,
	    	a_adder_fw_mem => a_adder_fw_mem,
	    	b_adder_fw_mem => b_adder_fw_mem,
	    	a_shift_fw_mem => a_shift_fw_mem,
	    	b_shift_fw_mem => b_shift_fw_mem,
	    	
	    	-- control signals
	    	sub_add => sub_add,
	    	shift_type => shift_type,
	    	log_type => log_type,
	    	op_type => op_type,
	    	op_sign => op_sign,
	    	it => it,
	    	neg => neg,
	    	en_add => en_add,
	    	en_mul => en_mul,
	    	en_shift => en_shift,
	    	en_a_neg => en_a_neg,
	    	shift_reg => shift_reg,
	    	en_shift_reg => en_shift_reg,
	    	en_output => en_output,
	    	fw_op_a => fw_a,
	    	fw_op_b => fw_b,
	    	en_rd => en_rd,

	    	-- outputs
	    	Rd_out => Rd_out,
	    	alu_out_high_ex => alu_out_high_ex,
	    	alu_out_low_ex => alu_out_low_ex,
	    	alu_flags_ex => alu_flags_ex,	
			le => le,
			lt => lt,
			ge => ge,
			gt => gt,
			eq => eq,
			ne => ne
		);

	clk_p: process
		begin
			clk <= '1';
			wait for period/2;
			clk <= '0';
			wait for period/2;	
		end process;

	test_p: process
		begin

			wait for period/2;

			a <= X"00000000";
	    	b <= X"00000000";
	    	Rd_in <= "10011";

	    	hi_fw_ex <= X"44444444";
	    	hi_fw_mem <= X"33333333";
	    	a_adder_fw_ex  <= X"11111111";
	    	b_adder_fw_ex <= X"11111111";
	    	a_shift_fw_ex <= X"11111111";
	    	b_shift_fw_ex <= "11111";

	    	a_adder_fw_mem <= X"22222222";
	    	b_adder_fw_mem <= X"22222222";
	    	a_shift_fw_mem <= X"22222222";
	    	b_shift_fw_mem <= "10001";

	    	rst <= '0';
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "00";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '1';
	    	en_shift <= '1';
	    	en_a_neg <= '1';
	    	shift_reg <= '0';
	    	en_shift_reg <= '1';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period;

	    	-- addition between unsigned numbers
	    	rst <= '1';
			a <= X"00000020";
	    	b <= X"00000500";
	    	Rd_in <= "10011";
	    	wait for period/2;
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "00";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- addition between unsigned numbers with overflow
	    	rst <= '1';
			a <= X"ffffffff";
	    	b <= X"00000001";
	    	Rd_in <= "10011";

	    	wait for period/2;

	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "00";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- addition between signed numbers
	    	rst <= '1';
			a <= X"99998888";
	    	b <= X"11112222";
	    	Rd_in <= "10011";

	    	wait for period/2;
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "00";
	    	op_sign <= '1';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- addition between signed numbers with overflow
	    	rst <= '1';
			a <= X"88888888";
	    	b <= X"88888888";
	    	Rd_in <= "10011";

	    	wait for period/2;

	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "00";
	    	op_sign <= '1';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- subtraction of signed operands that cause overflow
	    	rst <= '1';
			a <= X"7fffffff";
	    	b <= X"80000000";
	    	Rd_in <= "10011";

	    	wait for period/2;
	    	
	    	sub_add <= '1';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "00";
	    	op_sign <= '1';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- logical operations
	    	-- AND
	    	rst <= '1';
			a <= X"99999999";
	    	b <= X"11111111";
	    	Rd_in <= "10011";

	    	wait for period/2;
	    	
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "1000";
	    	op_type <= "11";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- OR
	    	rst <= '1';
			a <= X"99999999";
	    	b <= X"11111111";
	    	Rd_in <= "10011";

	    	wait for period/2;
	    	
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "1110";
	    	op_type <= "11";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '1';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- shift operations
	    	-- logical shift left
	    	
	    	rst <= '1';
			a <= X"99999999";
	    	b <= X"0000000a";
	    	Rd_in <= "10011";

	    	wait for period/2;
	    	
	    	sub_add <= '0';
	    	shift_type <= "0011";
	    	log_type <= "0000";
	    	op_type <= "10";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '1';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

			-- arithmetic shift right
	    	
	    	rst <= '1';
			a <= X"99999999";
	    	b <= X"00000005";
	    	Rd_in <= "10011";

	    	wait for period/2;
	    	
	    	sub_add <= '0';
	    	shift_type <= "0100";
	    	log_type <= "0000";
	    	op_type <= "10";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '1';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period/2;

	    	-- multiply positive numbers
	    	-- sample the operands
	    	rst <= '1';
			a <= X"33333333";
	    	b <= X"22222222";
	    	Rd_in <= "10011";
	    	
	    	wait for period/2;

	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "01";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '1';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '1';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period;

	    	-- negate a
	    	
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "01";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '1';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period;
	    	
	    	en_a_neg <= '1';

            wait for period;
            
	    	-- other iterations: compute the result
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "01";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '1';
	    	en_shift_reg <= '1';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period;

	    	for i in 1 to to_integer(unsigned(it_limit)) loop
	    		
	    		it <= std_logic_vector(to_unsigned(i,4));
	    		wait for period;
	    	end loop;

	    	-- stop every operation and sample the result
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	wait for period/2; 
	    	en_output <= '0';
	    	
	    	-- multiply positive numbers
	    	-- sample the operands
	    	rst <= '1';
			a <= X"FFFFFFAE";
	    	b <= X"20000721";
	    	Rd_in <= "10011";
	    	
	    	wait for period/2;

	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "01";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '1';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '1';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period;

	    	-- negate a
	    	
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "01";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '1';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';

	    	wait for period;
	    	
	    	en_a_neg <= '1';

            wait for period;
            
	    	-- other iterations: compute the result
	    	sub_add <= '0';
	    	shift_type <= "0000";
	    	log_type <= "0000";
	    	op_type <= "01";
	    	op_sign <= '0';
	    	it <= "0000";
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '1';
	    	en_shift_reg <= '1';
	    	en_output <= '1';
	    	fw_a <= "000";
	    	fw_b <= "00";
	    	en_rd <= '1';
	    	
	    	wait for period;

	    	for i in 1 to to_integer(unsigned(it_limit)) loop
	    		
	    		it <= std_logic_vector(to_unsigned(i,4));
	    		wait for period;
	    	end loop;

	    	-- stop every operation and sample the result
	    	neg <= '0';
	    	en_add <= '0';
	    	en_mul <= '0';
	    	en_shift <= '0';
	    	en_a_neg <= '0';
	    	shift_reg <= '0';
	    	en_shift_reg <= '0';
	    	en_output <= '1';
	    	wait for period; 
	    	en_output <= '0';

	    	wait;
		end process;
end tb;