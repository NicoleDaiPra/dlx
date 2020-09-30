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
    	en_jump: in std_logic;
    	en_npc: in std_logic;
    	cond_sel: in std_logic_vector(2 downto 0);

    	-- outputs
    	npc_out: out std_logic_vector(31 downto 0);
    	Rd_out: out std_logic_vector(4 downto 0);
    	alu_out_high_ex: out std_logic_vector(31 downto 0);
    	alu_out_low_ex: out std_logic_vector(31 downto 0);
    	alu_flags_ex: out std_logic_vector(2 downto 0); 
    	taken: out std_logic;	
		le: out std_logic; -- less than or equal
		lt: out std_logic; -- less than
		ge: out std_logic; -- greater than or equal
		gt: out std_logic; -- greater than
		eq: out std_logic; -- equal
		ne: out std_logic -- not equal
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
			Rd_in: in std_logic_vector(4 downto 0);
			npc_in: in std_logic_vector(31 downto 0);
			imm_in: in std_logic_vector(31 downto 0);
		
			-- control signals
			en_add: in std_logic;
		    en_mul: in std_logic;
		    en_shift: in std_logic;
		    en_a_neg: in std_logic;
		    shift_reg: in std_logic;
		    en_shift_reg: in std_logic;
		    en_rd: in std_logic;
		    en_jump: in std_logic;
		
			-- outputs
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
	    	sub_add: in std_logic;						
	    	shift_type: in std_logic_vector(3 downto 0);
	    	log_type: in std_logic_vector(3 downto 0);
	    	op_type: in std_logic_vector(1 downto 0);	
	    	op_sign: in std_logic; 						
	    	it: in std_logic_vector(3 downto 0);		
	    	neg: in std_logic;							
	    	fw_op_a: in std_logic_vector(2 downto 0);		
	    	fw_op_b: in std_logic_vector(1 downto 0);
	    	cond_sel: in std_logic_vector(2 downto 0);	

	    	-- outputs
	    	alu_out_high: out std_logic_vector(31 downto 0);
	    	alu_out_low: out std_logic_vector(31 downto 0);
	    	alu_flags: out std_logic_vector(2 downto 0); 
	    	a_neg_out: out std_logic_vector(63 downto 0);	
	    	npc_out: out std_logic_vector(31 downto 0);
	    	taken: out std_logic;
			le: out std_logic; 
			lt: out std_logic; 
			ge: out std_logic; 
			gt: out std_logic; 
			eq: out std_logic; 
			ne: out std_logic 
		);
	end component ex_stage;

	component ex_mem_reg is
		port(
			clk: in std_logic;
			rst: in std_logic;
			
			npc_in: in std_logic_vector(31 downto 0);
			alu_out_high_in: in std_logic_vector(31 downto 0);
	    	alu_out_low_in: in std_logic_vector(31 downto 0);
	    	alu_flags_in: in std_logic_vector(2 downto 0); 
			le_in: in std_logic; 
			lt_in: in std_logic; 
			ge_in: in std_logic; 
			gt_in: in std_logic; 
			eq_in: in std_logic; 
			ne_in: in std_logic; 
			Rd_in: in std_logic_vector(4 downto 0);

			en_output: in std_logic;
			en_rd: in std_logic;
			en_npc: in std_logic;

			-- outputs
			npc: out std_logic_vector(31 downto 0);
			Rd_out: out std_logic_vector(4 downto 0);
			mul_feedback: out std_logic_vector(63 downto 0);
			alu_out_high: out std_logic_vector(31 downto 0);
	    	alu_out_low: out std_logic_vector(31 downto 0);
	    	alu_flags: out std_logic_vector(2 downto 0); 
			le: out std_logic; 
			lt: out std_logic; 
			ge: out std_logic; 
			gt: out std_logic; 
			eq: out std_logic; 
			ne: out std_logic 
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

begin

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
		
			-- control signals
			en_add => en_add,
		    en_mul => en_mul,
		    en_shift => en_shift,
		    en_a_neg => en_a_neg,
		    shift_reg => shift_reg,
		    en_shift_reg => en_shift_reg,
		    en_rd =>  en_rd,
		    en_jump => en_jump,
		
			-- outputs
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
	    	
	    	-- outputs
	    	alu_out_high => alu_out_high_int,
	    	alu_out_low => alu_out_low_int,
	    	alu_flags => alu_flags_int,
	    	a_neg_out => a_neg_ext,
	    	npc_out => next_pc,
	    	taken => taken,
			le => le_int,
			lt => lt_int,
			ge => ge_int,
			gt => gt_int,
			eq => eq_int,
			ne => ne_int
		);

	ex_mem_regs: ex_mem_reg
		port map(
			clk => clk,
			rst => rst,
			
			npc_in => next_pc,
			alu_out_high_in => alu_out_high_int,
	    	alu_out_low_in => alu_out_low_int,
	    	alu_flags_in => alu_flags_int, 	
			le_in => le_int,
			lt_in => lt_int,
			ge_in => ge_int,
			gt_in => gt_int,
			eq_in => eq_int,
			ne_in => ne_int,
			Rd_in => rd_int,

			en_output => en_output,
			en_rd => en_rd,
			en_npc => en_npc,

			-- outputs
			npc => npc_out,
			Rd_out => Rd_out,
			mul_feedback => mul_feedback_int,
			alu_out_high => alu_out_high_ex,
	    	alu_out_low => alu_out_low_ex,
	    	alu_flags => alu_flags_ex,	
			le => le,
			lt => lt,
			ge => ge,
			gt => gt,
			eq => eq,
			ne => ne
		);
end struct;
