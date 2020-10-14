library ieee;
use ieee.std_logic_1164.all;

entity mem_wb_reg is
	port (
		clk: std_logic;
		rst: std_logic;

		-- input signals
		alu_out_high_in: in std_logic_vector(31 downto 0); -- alu's result
		alu_out_low_in: in std_logic_vector(31 downto 0);
		cache_in: in std_logic_vector(31 downto 0); -- data read from the cache
		rd_in: in std_logic_vector(4 downto 0); -- destination registers

		-- control signals
		en_alu_out: in std_logic;
		en_cache: in std_logic;
		en_rd: in std_logic;

		-- outputs
		alu_out_high: out std_logic_vector(31 downto 0);
		alu_out_low: out std_logic_vector(31 downto 0);
		cache_data: out std_logic_vector(31 downto 0);
		rd: out std_logic_vector(4 downto 0)
	);
end entity mem_wb_reg;

architecture struct of mem_wb_reg is

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

begin

	alu_high_reg: reg_en
	   generic map (
	       N => 32
	   )
		port map (
			d => alu_out_high_in,
			en => en_alu_out,
			clk => clk,
			rst => rst,
			q => alu_out_high
		);

	alu_low_reg: reg_en
	generic map (
	       N => 32
	   )
	port map (
		d => alu_out_low_in,
		en => en_alu_out,
		clk => clk,
		rst => rst,
		q => alu_out_low
	);

	cache_data_reg: reg_en
	generic map (
	       N => 32
	   )
		port map (
			d => cache_in,
			en => en_cache,
			clk => clk,
			rst => rst,
			q => cache_data
		);
	
	rd_reg: reg_en
	generic map (
	       N => 5
	   )
		port map (
			d => rd_in,
			en => en_rd,
			clk => clk,
			rst => rst,
			q => rd
		);
end architecture struct;