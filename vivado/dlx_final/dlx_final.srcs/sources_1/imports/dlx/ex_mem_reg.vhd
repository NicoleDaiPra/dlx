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

	-- register used to take the value to be stored from the ID stage to the MEM
	b_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => op_b_in,
			en => en_b,
			clk => clk,
			rst => rst,
			q => op_b
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

end struct;
