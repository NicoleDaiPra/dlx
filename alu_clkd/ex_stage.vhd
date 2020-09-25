library ieee;
use ieee.std_logic_1164.all;

entity ex_stage is
	port (
		clk: std_logic;
		rst: std_logic;

    	-- operands
    	a: in std_logic_vector(31 downto 0);
    	b: in std_logic_vector(31 downto 0);
    	
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

    	-- outputs
    	alu_out_high_ex: out std_logic_vector(31 downto 0);
    	alu_out_low_ex: out std_logic_vector(31 downto 0);
    	alu_flags_ex: out std_logic_vector(2 downto 0); 
    	a_neg_out_ex: out std_logic_vector(63 downto 0);	
		le: out std_logic; -- less than or equal
		lt: out std_logic; -- less than
		ge: out std_logic; -- greater than or equal
		gt: out std_logic; -- greater than
		eq: out std_logic; -- equal
		ne: out std_logic -- not equal
		);
end ex_stage;

architecture beh of ex_stage is

	component alu is
		port ( 
	    	-- operands
	    	a_adder: in std_logic_vector(31 downto 0);
	    	b_adder: in std_logic_vector(31 downto 0);
	    	a_mult: in std_logic_vector(63 downto 0);
	    	a_neg_mult: in std_logic_vector(63 downto 0);
	    	b_mult: in std_logic_vector(2 downto 0);
	    	b10_1_mult: in std_logic_vector(2 downto 0);
	    	a_shift: in std_logic_vector(31 downto 0);
	    	b_shift: in std_logic_vector(4 downto 0);
	    	mul_feedback: in std_logic_vector(63 downto 0);

	    	-- control signals
	    	sub_add: in std_logic;						-- 1 if it is a subtraction, 0 otherwise
	    	shift_type: in std_logic_vector(3 downto 0);
	    	log_type: in std_logic_vector(3 downto 0);
	    	op_type: in std_logic_vector(1 downto 0);	--00: add/sub, 01: mul, 10: shift/rot, 11: log
	    	op_sign: in std_logic; 						-- 1 if the operands are signed, 0 otherwise
	    	it: in std_logic_vector(3 downto 0);		-- iteration
	    	neg: in std_logic;							-- used to negate a before actually multiplying

	    	-- outputs
	    	alu_out_high: out std_logic_vector(31 downto 0);
	    	alu_out_low: out std_logic_vector(31 downto 0);
	    	alu_flags: out std_logic_vector(2 downto 0); 
	    	a_neg_out: out std_logic_vector(63 downto 0);	
			le: out std_logic; -- less than or equal
			lt: out std_logic; -- less than
			ge: out std_logic; -- greater than or equal
			gt: out std_logic; -- greater than
			eq: out std_logic; -- equal
			ne: out std_logic -- not equal
		);
	end component alu;

	component reg_en is
		generic (
			N: integer := 32
		);
		port (
			d: in std_logic_vector(N-1 downto 0);
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			q: out std_logic_vector(N-1 downto 0)	
		);
	end component reg_en;

	component rshift_reg is
		generic (
			N: integer := 32;
			S: integer := 2
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			shift: in std_logic; -- tell whether the register have to sample the input data or the shifted one
			en: in std_logic;
			d: in std_logic_vector(N-1 downto 0);
			q: out std_logic_vector(N-1 downto 0)
		);
	end component rshift_reg;

	signal a_add_log, b_add_log, a_shift: std_logic_vector(31 downto 0);
	signal b_mult: std_logic_Vector(30 downto 0);
	signal a_mult, a_neg_mult: std_logic_vector(63 downto 0);
	signal b10_1_mult, b10_1_int: std_logic_vector(2 downto 0);
	signal b_shift: std_logic_vector(4 downto 0);
	signal msb_a: std_logic_vector(31 downto 0);
	signal a_mult_int: std_logic_vector(63 downto 0);
	signal cmp_res_in, cmp_res_out: std_logic_vector(5 downto 0);
	signal le_alu, lt_alu, ge_alu, gt_alu, eq_alu, ne_alu: std_logic;

	signal alu_out_high, alu_out_low: std_logic_vector(31 downto 0);
	signal alu_out_high_int, alu_out_low_int: std_logic_vector(31 downto 0);
	signal alu_flags: std_logic_vector(2 downto 0);
	signal a_neg_out: std_logic_vector(63 downto 0);
	signal feedback: std_logic_vector(63 downto 0);


begin

	feedback <= alu_out_high_int&alu_out_low_int;
	
	alu_unit: alu
		port map (
			a_adder => a_add_log,
	    	b_adder => b_add_log,
	    	a_mult => a_mult,
	    	a_neg_mult => a_neg_mult,
	    	b_mult => b_mult(2 downto 0),
	    	b10_1_mult => b10_1_mult,
	    	a_shift => a_shift,
	    	b_shift => b_shift,
	    	mul_feedback => feedback,

	    	-- control signals
	    	sub_add => sub_add,						-- 1 if it is a subtraction, 0 otherwise
	    	shift_type => shift_type,
	    	log_type => log_type,
	    	op_type => op_type,						-- 00: add/sub, 01: mul, 10: shift/rot, 11: log
	    	op_sign => op_sign, 					-- 1 if the operands are signed, 0 otherwise
	    	it => it,								-- iteration
	    	neg =>  neg,							-- used to negate a before actually multiplying

	    	-- outputs
	    	alu_out_high => alu_out_high,
	    	alu_out_low => alu_out_low,
	    	alu_flags => alu_flags,
	    	a_neg_out => a_neg_out,	
			le => le_alu, -- less than or equal
			lt => lt_alu, -- less than
			ge => ge_alu, -- greater than or equal
			gt => gt_alu, -- greater than
			eq => eq_alu, -- equal
			ne => ne_alu -- not equal
		);


	-- inputs

	a_add_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => a,
			en => en_add,
			clk => clk,
			rst  => rst,
			q => a_add_log
		);

	b_add_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => b,
			en => en_add,
			clk => clk,
			rst  => rst,
			q => b_add_log
		);

	-- sign extend "a"
	msb_a <= (others => a(31));
	a_mult_int <= msb_a&a;

	a_mult_reg: reg_en
		generic map (
			N => 64
		)
		port map (
			d => a_mult_int,
			en => en_mul,
			clk => clk,
			rst => rst,
			q => a_mult
		);

	a_neg_mult_reg: reg_en
		generic map (
			N => 64
		)
		port map (
			d => a_neg_out,
			en => en_a_neg,
			clk => clk,
			rst => rst,
			q => a_neg_mult
		);

	a_neg_out_ex <= a_neg_mult;

	b10_1_int <= b(1 downto 0)&'0';
	b10_1_reg: reg_en
		generic map (
			N => 3
		)
		port map (
			d => b10_1_int,
			en => en_mul,
			clk => clk,
			rst => rst,
			q => b10_1_mult
		);

	b_mult_reg: rshift_reg
		generic map (
			N => 31,
			S => 2
		)
		port map (
			clk => clk,
			rst => rst,
			shift => shift_reg,
			en => en_shift_reg,
			d => b(31 downto 1),
			q => b_mult
		);


	a_shift_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => a,
			en => en_shift,
			clk => clk,
			rst => rst,
			q => a_shift
		);

	b_shift_reg: reg_en
		generic map (
			N => 5
		)
		port map (
			d => b(4 downto 0),
			en => en_shift,
			clk => clk,
			rst => rst,
			q => b_shift
		);	


	-- outputs
	
	alu_out_high_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => alu_out_high,
			en => en_output,
			clk => clk,
			rst => rst,
			q => alu_out_high_int
		);

	alu_out_low_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => alu_out_low,
			en => en_output,
			clk => clk,
			rst => rst,
			q => alu_out_low_int
		);

	flags_reg: reg_en
		generic map (
			N => 3
		)
		port map (
			d => alu_flags,
			en => en_output,
			clk => clk,
			rst => rst,
			q => alu_flags_ex
		);

	cmp_res_in <= le_alu&lt_alu&ge_alu&gt_alu&eq_alu&ne_alu;

	cmp_reg: reg_en
		generic map (
			N => 6
		)
		port map (
			d => cmp_res_in,
			en => en_output,
			clk => clk,
			rst => rst,
			q => cmp_res_out	
		);

	alu_out_low_ex <= alu_out_low_int;
	alu_out_high_ex <= alu_out_high_int;

	le <= cmp_res_out(5);
	lt <= cmp_res_out(4);
	ge <= cmp_res_out(3);
	gt <= cmp_res_out(2);
	eq <= cmp_res_out(1);
	ne <= cmp_res_out(0);

end beh;
