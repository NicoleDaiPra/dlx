library ieee;
use ieee.std_logic_1164.all;

entity datapath is
	port(
		clk: std_logic;
		rst: std_logic;

    	-- operands
    	a: in std_logic_vector(31 downto 0);
    	b: in std_logic_vector(31 downto 0);
    	Rd_in: in std_logic_vector(4 downto 0);
    	npc_in: in std_logic_vector(31 downto 0);
    	imm_in: in std_logic_vector(31 downto 0);
    	op_b_in: in std_logic_vector(31 downto 0);

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
    	sub_add: in std_logic;						
    	shift_type: in std_logic_vector(3 downto 0);
    	log_type: in std_logic_vector(3 downto 0);
    	op_type: in std_logic_vector(1 downto 0);	
    	op_sign: in std_logic; 						
    	it: in std_logic_vector(3 downto 0);		
    	neg: in std_logic;							
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
    	en_npc_id: in std_logic;
    	en_imm: in std_logic;
    	en_b_id: in std_logic;
    	en_b_ex: in std_logic;
    	cond_sel: in std_logic_vector(2 downto 0);
    	alu_comp_sel: in std_logic_vector(2 downto 0);

    	-- outputs
    	npc_jump_reg: out std_logic_vector(31 downto 0);
    	op_b: out std_logic_vector(31 downto 0);
    	npc_jump_dp: out std_logic_vector(31 downto 0);
    	Rd_out: out std_logic_vector(4 downto 0);
    	alu_out_high_ex: out std_logic_vector(31 downto 0);
    	alu_out_low_ex: out std_logic_vector(31 downto 0);
    	taken: out std_logic
	);
end datapath;

architecture struct of datapath is

	component id_ex_reg is
		port (
			clk: in std_logic;
			rst: in std_logic;

			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(31 downto 0);
			a_neg_in: in std_logic_vector(63 downto 0);
			Rd_in: in std_logic_vector(4 downto 0); -- destination register
			npc_in: in std_logic_vector(31 downto 0);
			imm_in: in std_logic_vector(31 downto 0);
			op_b_in: in std_logic_vector(31 downto 0);
		
			-- control signals
			en_add: in std_logic;
		    en_mul: in std_logic;
		    en_shift: in std_logic;
		    en_a_neg: in std_logic;
		    shift_reg: in std_logic; -- signal that controls the shift register
		    en_shift_reg: in std_logic;
		    en_rd: in std_logic;
		    en_npc: in std_logic;
		    en_imm: in std_logic;
		    en_b: in std_logic;
		
			-- outputs
			op_b: out std_logic_vector(31 downto 0);
			npc: out std_logic_vector(31 downto 0);
			imm: out std_logic_vector(31 downto 0);
			Rd_out: out std_logic_vector(4 downto 0);
			a_adder: out std_logic_vector(31 downto 0);
			b_adder: out std_logic_vector(31 downto 0);
			a_mult: out std_logic_vector(63 downto 0);
			a_neg_mult: out std_logic_vector(63 downto 0);
			b_mult: out std_logic_vector(2 downto 0);
			b10_1_mult: out std_logic_vector(2 downto 0);
			a_shift: out std_logic_vector(31 downto 0);
			b_shift: out std_logic_vector(4 downto 0)
		);
	end component id_ex_reg;

	component ex_stage is
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
	    	sub_add: in std_logic; -- 1 if it is a subtraction, 0 otherwise
	    	shift_type: in std_logic_vector(3 downto 0);
	    	log_type: in std_logic_vector(3 downto 0);
	    	op_type: in std_logic_vector(1 downto 0); -- 00: add/sub, 01: mul, 10: shift/rot, 11: log
	    	op_sign: in std_logic; -- 1 if the operands are signed, 0 otherwise
	    	it: in std_logic_vector(3 downto 0); -- iterations of the multiplier
	    	neg: in std_logic; -- used to negate a before actually multiplying
	    	fw_op_a: in std_logic_vector(2 downto 0); -- used to choose between the forwarded operands and the other ones
	    	fw_op_b: in std_logic_vector(1 downto 0);
	    	cond_sel: in std_logic_vector(2 downto 0); -- used to identify the condition of the branch instruction
	    	alu_comp_sel: in std_logic_vector(2 downto 0); -- used to select the output to be stored in the alu out register	

	    	-- outputs
	    	npc_jump_reg: out std_logic_vector(31 downto 0);
	    	alu_out_high: out std_logic_vector(31 downto 0);
	    	alu_out_low: out std_logic_vector(31 downto 0);
	    	a_neg_out: out std_logic_vector(63 downto 0); -- negated a that goes back to the multiplier
	    	npc_jump: out std_logic_vector(31 downto 0); -- updated next program counter
	    	taken: out std_logic
	    );
	end component ex_stage;

	component ex_mem_reg is
		port(
			clk: in std_logic;
			rst: in std_logic;
			
			op_b_in: in std_logic_vector(31 downto 0);
			alu_out_high_in: in std_logic_vector(31 downto 0);
	    	alu_out_low_in: in std_logic_vector(31 downto 0);
			Rd_in: in std_logic_vector(4 downto 0); -- destination register

			en_output: in std_logic;
			en_rd: in std_logic;
			en_b: in std_logic;

			-- outputs
			op_b: out std_logic_vector(31 downto 0); 
			Rd_out: out std_logic_vector(4 downto 0);
			mul_feedback: out std_logic_vector(63 downto 0); -- signal that goes back to the multiplier
			alu_out_high: out std_logic_vector(31 downto 0);
	    	alu_out_low: out std_logic_vector(31 downto 0)
		);
	end component ex_mem_reg;

	signal a_neg_int, a_neg_ext: std_logic_vector(63 downto 0);
	signal a_adder_int, b_adder_int, a_shift_int: std_logic_vector(31 downto 0);
	signal b_shift_int: std_logic_vector(4 downto 0);
	signal a_mult_int: std_logic_vector(63 downto 0);
	signal b_mult_int, b10_1_mult_int: std_logic_vector(2 downto 0);
	signal mul_feedback_int: std_logic_vector(63 downto 0);
	signal alu_out_high_int, alu_out_low_int: std_logic_vector(31 downto 0);
	signal alu_flags_int: std_logic_vector(2 downto 0);
	signal le_int, lt_int, ge_int, gt_int, eq_int, ne_int: std_logic; 
	signal rd_int: std_logic_vector(4 downto 0);
	signal npc_int, next_pc: std_logic_vector(31 downto 0);
	signal imm_int: std_logic_vector(31 downto 0);
	signal op_b_int: std_logic_vector(31 downto 0);


begin

	npc_jump_dp <= next_pc;

	id_ex_regs: id_ex_reg
		port map (
			clk => clk,
			rst => rst,

			a => a,
			b => b,
			a_neg_in => a_neg_ext,
			Rd_in => Rd_in,
			npc_in => npc_in,
			imm_in => imm_in,
			op_b_in => op_b_in,
		
			-- control signals
			en_add => en_add,
		    en_mul => en_mul,
		    en_shift => en_shift,
		    en_a_neg => en_a_neg,
		    shift_reg => shift_reg,
		    en_shift_reg => en_shift_reg,
		    en_rd =>  en_rd,
		    en_npc => en_npc_id,
		    en_imm => en_imm,
		    en_b => en_b_id,
		
			-- outputs
			op_b => op_b_int,
			npc => npc_int,
			imm => imm_int,
			Rd_out => rd_int,
			a_adder => a_adder_int,
			b_adder => b_adder_int,
			a_mult => a_mult_int,
			a_neg_mult => a_neg_int,
			b_mult => b_mult_int,
			b10_1_mult => b10_1_mult_int,
			a_shift => a_shift_int,
			b_shift => b_shift_int
		);

	es: ex_stage
		port map (
			a_adder => a_adder_int,
	    	b_adder => b_adder_int,
	    	a_mult => a_mult_int,
	    	a_neg_mult => a_neg_int,
	    	b_mult => b_mult_int,
	    	b10_1_mult => b10_1_mult_int,
	    	a_shift => a_shift_int,
	    	b_shift => b_shift_int,
	    	mul_feedback => mul_feedback_int,
	    	npc_in => npc_int,
	    	imm_in => imm_int,

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
	    	fw_op_a => fw_op_a,	
	    	fw_op_b => fw_op_b,
	    	cond_sel => cond_sel,
	    	alu_comp_sel => alu_comp_sel,
	    	
	    	-- outputs
	    	npc_jump_reg => npc_jump_reg,
	    	alu_out_high => alu_out_high_int,
	    	alu_out_low => alu_out_low_int,
	    	a_neg_out => a_neg_ext,
	    	npc_jump => next_pc,
	    	taken => taken
		);

	ex_mem_regs: ex_mem_reg
		port map(
			clk => clk,
			rst => rst,
			
			op_b_in => op_b_int,
			alu_out_high_in => alu_out_high_int,
	    	alu_out_low_in => alu_out_low_int,
			Rd_in => rd_int,

			en_output => en_output,
			en_rd => en_rd,
			en_b => en_b_ex,

			-- outputs
			op_b => op_b,
			Rd_out => Rd_out,
			mul_feedback => mul_feedback_int,
			alu_out_high => alu_out_high_ex,
	    	alu_out_low => alu_out_low_ex
		);
end struct;