library ieee;
use ieee.std_logic_1164.all;

-- This is the combinational logic that compose the ex stage.
-- There is an alu composed by an adder/subtractor, a shifter and the unit in charge of computing the 
-- logic operations. Inside the alu there are also the comparator and the unit that selects the output. 
-- The inputs of the adder, the shifter and the logical unit are selected through a set of multiplexer.
-- This is done in order to support the forwarding of the data between the stages.

entity ex_stage is
	port ( 
    	-- inputs
    	a_adder: in std_logic_vector(31 downto 0);
    	b_adder: in std_logic_vector(31 downto 0);
    	a_mult: in std_logic_vector(63 downto 0); -- first operand of the multiplication
    	a_neg_mult: in std_logic_vector(63 downto 0); -- negated a computed by the multiplication unit
    	b_mult: in std_logic_vector(2 downto 0); -- part of the second operand extracted based on Booth's algorithm
    	b10_1_mult: in std_logic_vector(2 downto 0); -- first part of the second operand
    	a_shift: in std_logic_vector(31 downto 0);
    	b_shift: in std_logic_vector(4 downto 0);
    	mul_feedback: in std_logic_vector(63 downto 0); -- partial result of the multiplication 
    	npc_in: in std_logic_vector(31 downto 0); 
    	imm_in: in std_logic_vector(31 downto 0);
    	op_b_in: in std_logic_vector(31 downto 0);

    	-- forwarded ex/mem operands
    	a_adder_fw_ex: in std_logic_vector(31 downto 0);
    	b_adder_fw_ex: in std_logic_vector(31 downto 0);
    	a_shift_fw_ex: in std_logic_vector(31 downto 0);
    	b_shift_fw_ex: in std_logic_vector(4 downto 0);
    	op_b_fw_ex: in std_logic_vector(31 downto 0);

    	-- forwarded mem/wb operands
    	a_adder_fw_mem: in std_logic_vector(31 downto 0);
    	b_adder_fw_mem: in std_logic_vector(31 downto 0);
    	a_shift_fw_mem: in std_logic_vector(31 downto 0);
    	b_shift_fw_mem: in std_logic_vector(4 downto 0);
    	op_b_fw_mem: in std_logic_vector(31 downto 0);

    	-- control signals
    	sub_add: in std_logic; -- 1 if it is a subtraction, 0 otherwise
    	shift_type: in std_logic_vector(3 downto 0);
    	log_type: in std_logic_vector(3 downto 0);
    	op_type: in std_logic_vector(1 downto 0); -- 00: add/sub, 01: mul, 10: shift/rot, 11: log
    	op_sign: in std_logic; -- 1 if the operands are signed, 0 otherwise
    	it: in std_logic_vector(3 downto 0); -- iterations of the multiplier
    	neg: in std_logic; -- used to negate a before actually multiplying
    	-- fw_op: used to choose between the forwarded operands and the other ones
    	-- 00: normal operand
    	-- 01: forwarded operand from ex/mem
    	-- 10: forwarded operand from mem/wb
    	-- 11: reserved
    	fw_op_a: in std_logic_vector(1 downto 0); 
    	fw_op_b: in std_logic_vector(1 downto 0);
    	cond_sel: in std_logic_vector(2 downto 0); -- used to identify the condition of the branch instruction	
    	alu_comp_sel: in std_logic_vector(2 downto 0); -- used to select the output to be stored in the alu out register
    	op_b_fw_sel: in std_logic_vector(1 downto 0);

    	-- outputs
    	npc_jr: out std_logic_vector(31 downto 0); -- used by jalr and jr
    	alu_out_high: out std_logic_vector(31 downto 0);
    	alu_out_low: out std_logic_vector(31 downto 0);
    	a_neg_out: out std_logic_vector(63 downto 0); -- negated a that goes back to the multiplier
    	npc_jump: out std_logic_vector(31 downto 0); -- used by j instructions and branches
    	taken: out std_logic;
    	op_b: out std_logic_vector(31 downto 0)
    );
end ex_stage;

architecture struct of ex_stage is

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
	    	sub_add: in std_logic; -- 1 if it is a subtraction, 0 otherwise
	    	shift_type: in std_logic_vector(3 downto 0);
	    	log_type: in std_logic_vector(3 downto 0);
	    	op_type: in std_logic_vector(1 downto 0); -- 00: add/sub, 01: mul, 10: shift/rot, 11: log
	    	op_sign: in std_logic; -- 1 if the operands are signed, 0 otherwise
	    	it: in std_logic_vector(3 downto 0); -- iteration
	    	neg: in std_logic;	-- used to negate a before actually multiplying

	    	-- outputs
	    	alu_out_high: out std_logic_vector(31 downto 0);
	    	alu_out_low: out std_logic_vector(31 downto 0);
	    	a_neg_out: out std_logic_vector(63 downto 0);	
			le: out std_logic; 
			lt: out std_logic; 
			ge: out std_logic; 
			gt: out std_logic; 
			eq: out std_logic; 
			ne: out std_logic 
		);
	end component alu;

	component mux_4x1 is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			c: in std_logic_vector(N-1 downto 0);
			d: in std_logic_vector(N-1 downto 0);
			sel: in std_logic_vector(1 downto 0);
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_4x1;

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

	component mux_2x1 is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux_2x1;

	component mux_7x1_single_bit is
		port (
	        a: in std_logic;
	        b: in std_logic;
	        c: in std_logic;
	        d: in std_logic;
	        e: in std_logic;
	        f: in std_logic;
	        g: in std_logic;
	        sel: in std_logic_vector(2 downto 0);
	        y: out std_logic
		);
	end component mux_7x1_single_bit;

	component mux_7x1 is
		generic (
			N: integer := 4
		);
		port (
	        a: in std_logic_vector(N-1 downto 0);
	        b: in std_logic_vector(N-1 downto 0);
	        c: in std_logic_vector(N-1 downto 0);
	        d: in std_logic_vector(N-1 downto 0);
	        e: in std_logic_vector(N-1 downto 0);
	        f: in std_logic_vector(N-1 downto 0);
	        g: in std_logic_vector(N-1 downto 0);
	        sel: in std_logic_vector(2 downto 0);
	        y: out std_logic_vector(N-1 downto 0)
		);
	end component mux_7x1;

	signal a_add_int, b_add_int: std_logic_vector(31 downto 0);
	signal a_shift_int: std_logic_vector(31 downto 0); 
	signal b_shift_int: std_logic_vector(4 downto 0);
	signal pc_off, next_pc: std_logic_vector(31 downto 0);
	signal pc_sel: std_logic;
	signal le_int, lt_int, ge_int, gt_int, eq_int, ne_int: std_logic;
	signal le_ext, lt_ext, ge_ext, gt_ext, eq_ext, ne_ext: std_logic_vector(31 downto 0);
	signal alu_out_low_int: std_logic_vector(31 downto 0);
	--signal imm_in_shifted: std_logic_vector(31 downto 0);

	constant zeros: std_logic_vector(30 downto 0) := (others => '0');


begin

	rca_add: rca_generic_struct
		generic map (
			N => 32
		)
		port map (
			a => npc_in,
			b => imm_in,
			cin => '0',
			s => pc_off,
			cout => open
		);

	pc_mux: mux_2x1
		generic map (
			N => 32
		)
		port map (
			a => pc_off,
			b => npc_in,
			sel => pc_sel,
			o => npc_jump
		);

	cond_mux: mux_7x1_single_bit
		port map (
			a => le_int,
			b => lt_int,
			c => ge_int,
			d => gt_int,
			e => eq_int,
			f => ne_int,
			g => '1',
			sel => cond_sel,
			y => pc_sel
		);

	taken <= pc_sel;

	a_adder_mux: mux_4x1
		generic map (
			N => 32
		)
		port map (
			a => a_adder,
			b => a_adder_fw_ex,
			c => a_adder_fw_mem,
			d => (others => '0'),
			sel => fw_op_a,
			o => a_add_int
		);

	b_adder_mux: mux_4x1
		generic map (
			N => 32
		)
		port map (
			a => b_adder,
			b => b_adder_fw_ex,
			c => b_adder_fw_mem,
			d => (others  => '0'),
			sel => fw_op_b,
			o => b_add_int
		);


	a_shift_mux: mux_4x1
		generic map (
			N => 32
		)
		port map (
			a => a_shift,
			b => a_shift_fw_ex,
			c => a_shift_fw_mem,
			d => (others  => '0'),
			sel => fw_op_a,
			o => a_shift_int
	);

	b_shift_mux: mux_4x1
		generic map (
			N => 5
		)
		port map (
			a => b_shift,
			b => b_shift_fw_ex,
			c => b_shift_fw_mem,
			d => (others  => '0'),
			sel => fw_op_b,
			o => b_shift_int
	);

	op_b_selector: mux_4x1
		generic map (
			N => 32
		)
		port map (
			a => op_b_in,
			b => op_b_fw_ex,
			c => op_b_fw_mem,
			d => (others => '0'),
			sel => op_b_fw_sel,
			o => op_b
		);

	alu_unit: alu
		port map ( 
	    	-- operands
	    	a_adder => a_add_int,
	    	b_adder => b_add_int,
	    	a_mult => a_mult,
	    	a_neg_mult => a_neg_mult,
	    	b_mult => b_mult,
	    	b10_1_mult => b10_1_mult,
	    	a_shift => a_shift_int,
	    	b_shift => b_shift_int,
	    	
	    	mul_feedback => mul_feedback,

	    	-- control signals
	    	sub_add => sub_add,
	    	shift_type => shift_type,
	    	log_type => log_type,
	    	op_type => op_type,
	    	op_sign => op_sign,
	    	it => it,
	    	neg => neg,

	    	-- outputs
	    	alu_out_high => alu_out_high,
	    	alu_out_low => alu_out_low_int,
	    	a_neg_out => a_neg_out,	
			le => le_int,
			lt => lt_int,
			ge => ge_int,
			gt => gt_int,
			eq => eq_int,
			ne => ne_int
		);

		le_ext <= zeros&le_int;
		lt_ext <= zeros&lt_int;
		ge_ext <= zeros&ge_int;
		gt_ext <= zeros&gt_int;
		eq_ext <= zeros&eq_int;
		ne_ext <= zeros&ne_int;

	output_sel: mux_7x1
		generic map (
			N => 32
		)
		port map (
			a => le_ext,
			b => lt_ext,
			c => ge_ext,
			d => gt_ext,
			e => eq_ext,
			f => ne_ext,
			g => alu_out_low_int,
			sel => alu_comp_sel,
			y => alu_out_low
		);

	npc_jr <= alu_out_low_int;

end struct;
