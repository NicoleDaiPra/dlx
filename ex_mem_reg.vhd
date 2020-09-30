library ieee;
use ieee.std_logic_1164.all;

-- This entity contains the set of registers that connects the exe stage to the mem stage. 
-- The alu output is splitted into two registers that contain the high and the low parts of the result.
-- There are also the PC's register, the flags' register and destination register. 
-- The results of the comparison are stored all together into a single register and then they are
-- returned each with its own signal.

entity ex_mem_reg is
	port(
		clk: in std_logic;
		rst: in std_logic;
		
		npc_in: in std_logic_vector(31 downto 0);
		alu_out_high_in: in std_logic_vector(31 downto 0);
    	alu_out_low_in: in std_logic_vector(31 downto 0);
    	alu_flags_in: in std_logic_vector(2 downto 0); 
		le_in: in std_logic; -- less than or equal
		lt_in: in std_logic; -- less than
		ge_in: in std_logic; -- greater than or equal
		gt_in: in std_logic; -- greater than
		eq_in: in std_logic; -- equal
		ne_in: in std_logic; -- not equal
		Rd_in: in std_logic_vector(4 downto 0); -- destination register

		en_output: in std_logic;
		en_rd: in std_logic;
		en_npc: in std_logic;

		-- outputs
		npc: out std_logic_vector(31 downto 0);
		Rd_out: out std_logic_vector(4 downto 0);
		mul_feedback: out std_logic_vector(63 downto 0); -- signal that goes back to the multiplier
		alu_out_high: out std_logic_vector(31 downto 0);
    	alu_out_low: out std_logic_vector(31 downto 0);
    	alu_flags: out std_logic_vector(2 downto 0); 
		le: out std_logic; -- less than or equal
		lt: out std_logic; -- less than
		ge: out std_logic; -- greater than or equal
		gt: out std_logic; -- greater than
		eq: out std_logic; -- equal
		ne: out std_logic -- not equal
	);
end ex_mem_reg;

architecture struct of ex_mem_reg is

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

	signal alu_out_high_int, alu_out_low_int: std_logic_vector(31 downto 0);
	signal cmp_res_in, cmp_res_out: std_logic_vector(5 downto 0);

begin

	-- feedback that goes to the multiplier
	-- It is on 64 bits and it represent the partial product
	mul_feedback <= alu_out_high_int & alu_out_low_int;

	npc_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => npc_in,
			en => en_npc,
			clk => clk,
			rst => rst,
			q => npc
		);

	alu_out_high_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => alu_out_high_in,
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
			d => alu_out_low_in,
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
			d => alu_flags_in,
			en => en_output,
			clk => clk,
			rst => rst,
			q => alu_flags
		);

	cmp_res_in <= le_in&lt_in&ge_in&gt_in&eq_in&ne_in;

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

	alu_out_low <= alu_out_low_int;
	alu_out_high <= alu_out_high_int;

	le <= cmp_res_out(5);
	lt <= cmp_res_out(4);
	ge <= cmp_res_out(3);
	gt <= cmp_res_out(2);
	eq <= cmp_res_out(1);
	ne <= cmp_res_out(0);


end struct;
