library ieee;
use ieee.std_logic_1164.all;

-- This entity contains the set of registers that connects the id stage to the exe stage. 
-- There are the operands' registers (splitted based of the operation's type), 
-- the register that contains a negated when permorming a multiply and the registers 
-- in charge of sampling the program counter, the destination register and the immediate value.
-- A few signals are also manipulated in order to be adapted to the format used in the combinational logic.

entity id_ex_reg is
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

end id_ex_reg;

architecture struct of id_ex_reg is

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

 	signal a_mult_int: std_logic_vector(63 downto 0);
 	signal b10_1_int: std_logic_vector(2 downto 0);
 	signal msb_a: std_logic_vector(31 downto 0);
 	signal b_mult_int: std_logic_vector(30 downto 0);
 	

begin

	 b_reg: reg_en
    	generic map (
    		N => 32
		)
    	port map(
    		d => op_b_in,
    		en => en_b,
    		clk => clk,
    		rst => rst,
    		q => op_b
		);

    npc_reg: reg_en
    	generic map (
    		N => 32
		)
    	port map(
    		d => npc_in,
    		en => en_npc,
    		clk => clk,
    		rst => rst,
    		q => npc
		);

	imm_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => imm_in,
			en => en_imm,
			clk => clk,
			rst => rst,
			q => imm
		);

	rd_reg: reg_en
		generic map (
			N => 5
		)
		port map (
			d => Rd_in,
			en => en_rd,
			clk => clk,
			rst => rst,
			q => Rd_out
		);

	-- adder's registers
	a_add_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => a,
			en => en_add,
			clk => clk,
			rst  => rst,
			q => a_adder
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
			q => b_adder
		);

	-- multiplier's registers
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
			d => a_neg_in,
			en => en_a_neg,
			clk => clk,
			rst => rst,
			q => a_neg_mult
		);

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
			q => b_mult_int
		);

	b_mult <= b_mult_int(2 downto 0);

	-- shifter's registers
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


end struct;
