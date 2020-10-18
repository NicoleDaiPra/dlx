library ieee;
use ieee.std_logic_1164.all;

entity if_id_reg is
	port(
		clk: in std_logic;
		rst: in std_logic;

		-- inputs data
		npc_in: in std_logic_vector(29 downto 0);
		ir_in: in std_logic_vector(25 downto 0);

		-- enable signals for the registers
		en_npc: in std_logic;
		en_ir: in std_logic;

		-- outputs data
		npc_out: out std_logic_vector(31 downto 0);
		ir_out: out std_logic_vector(25 downto 0)
	);
end if_id_reg;

architecture struct of if_id_reg is

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

	npc_reg: reg_en
		generic map (
			N => 30
		)
		port map (
			d => npc_in,
			en => en_npc,
			clk => clk,
			rst => rst,
			q => npc_out(31 downto 2)
		);

	npc_out(1 downto 0) <= "00";

	ir_reg: reg_en
		generic map (
			N => 26
		)
		port map (
			d => ir_in,
			en => en_ir,
			clk => clk,
			rst => rst,
			q => ir_out
		);

end struct;
