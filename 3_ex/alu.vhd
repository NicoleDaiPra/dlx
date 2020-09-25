library ieee;
use ieee.std_logic_1164.all;

-- ALU that encapsulate the computing units, the comparator and the selector of the result

entity alu is
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
end alu;

architecture beh of alu is

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

	component mul is
		port (
			a: in std_logic_vector(63 downto 0);
			a_neg: in std_logic_vector(63 downto 0);
			b10_1: in std_logic_vector(2 downto 0);
			b: in std_logic_vector(2 downto 0);
			it: in std_logic_vector(3 downto 0);
			neg: in std_logic; -- used to negate a before actually multiplying
			mul_feedback: in std_logic_vector(63 downto 0);
			res: out std_logic_vector(63 downto 0)
		);
	end component mul;

	component shifter_t2 is
	    port (
	        data_in: in std_logic_vector(31 downto 0);
	        shift: in std_logic_vector(4 downto 0);
	        shift_type: in std_logic_vector(3 downto 0);
	        data_out: out std_logic_vector(31 downto 0)
	    );
	end component shifter_t2;

	component logicals is
		generic (
			N: integer := 32
		);

		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic_vector(3 downto 0);
			res: out std_logic_vector(N-1 downto 0)
		);
	end component logicals;

	component alu_out_selector is
		generic(
			N: integer := 32
		);
	    port (	
	    	a: in std_logic;	-- MSB of a
	    	b: in std_logic;	-- MSB of b
	    	op_type: in std_logic_vector(1 downto 0); -- identifies which unit is computing the result
	    	op_sign: in std_logic; 	-- 1 if the operands are signed, 0 otherwise
	    	sub_add: std_logic;		-- 1 if it is a subtraction, 0 otherwise
	    	adder_out: in std_logic_vector(N-1 downto 0);
	    	adder_cout: in std_logic;
	    	mul_out: in std_logic_vector(2*N-1 downto 0);
	    	shifter_out: in std_logic_vector(N-1 downto 0);
	    	logicals_out: in std_logic_vector(N-1 downto 0);
	    	alu_sel_out_high: out std_logic_vector(N-1 downto 0); -- upper part (63 downto 32) of the result used only for the multiply
	    	alu_sel_out_low: out std_logic_vector(N-1 downto 0); -- lower part (31 downto 0) of the result
	    	alu_flags: out std_logic_vector(2 downto 0) 	
	    );
	end component alu_out_selector;

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

	signal adder_out, shifter_out, logicals_out: std_logic_vector(31 downto 0);
	signal mul_out: std_logic_vector(63 downto 0);
	signal adder_cout: std_logic;
	signal alu_out_high_int, alu_out_low_int: std_logic_vector(31 downto 0); 

begin
	
	add_sub: p4_adder
		generic map (
			N => 32
		)
		port map (
			a => a_adder,
			b => b_adder,
			cin => sub_add,
			s => adder_out,
			cout => adder_cout,
			carries => open
		);

	mult: mul
		port map (
			a => a_mult,
			a_neg => a_neg_mult,
			b10_1 => b10_1_mult,
			b => b_mult,
			it => it,
			neg => neg,
			mul_feedback => mul_feedback,
			res => mul_out
		);

	shifter: shifter_t2
		port map (
			data_in => a_shift,
			shift => b_shift,
			shift_type => shift_type,
			data_out => shifter_out
		);

	log_unit: logicals
		generic map (
			N => 32
		)
		port map (
			a => a_adder,
			b => b_adder,
			sel => log_type,
			res => logicals_out
		);

	alu_sel: alu_out_selector
		generic map (
			N => 32
		)
		port map (
			a => a_adder(31),
			b => b_adder(31),
			sub_add => sub_add,
			op_type => op_type,
			op_sign => op_sign,
			adder_out => adder_out,
			adder_cout => adder_cout,
			mul_out => mul_out,
			shifter_out => shifter_out,
			logicals_out => logicals_out,
			alu_sel_out_high => alu_out_high_int,
			alu_sel_out_low => alu_out_low_int,
			alu_flags => alu_flags
		);

	comp: comparator
		generic map (
			N => 32
		)
		port map (
			res => adder_out,
			cout => adder_cout,
			a_msb => a_adder(31),
			b_msb => b_adder(31),
			op_sign => op_sign,
			le => le,
			lt => lt,
			ge => ge,
			gt => gt,
			eq => eq,
			ne => ne
		);

	alu_out_high <= alu_out_high_int;
	alu_out_low <= alu_out_low_int;

	a_neg_out <= alu_out_high_int & alu_out_low_int;

end beh;