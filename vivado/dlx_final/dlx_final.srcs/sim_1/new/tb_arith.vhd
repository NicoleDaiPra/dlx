library ieee;
use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

entity tb_arith is
end tb_arith;

architecture test of tb_arith is
	component dlx_sim is
		generic (
			F: string := "C:\Users\leona\dlx\test\test.asm.exe"
		);
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- output interface (used to evaluate execution when simulating)
			pc_en: out std_logic; -- shows if the processor is stalling
			pc_out: out std_logic_vector(29 downto 0);
			instr_fetched: out std_logic_vector(31 downto 0); -- the instruction currently fetched by the dlx
			predicted_taken: out std_logic; -- shows if the current PC is a branch or jump has been predicted as taken
			taken: out std_logic; -- shows if a branch (or jump) has been taken or not
			wp_en: out std_logic; -- shows if the dlx is writing in the output port
			hilo_wr_en: out std_logic; -- shows if the dlx is storing the res of a mul 
			wp_data: out std_logic_vector(31 downto 0); -- the value being written in the RF
			wp_alu_data_high: out std_logic_vector(31 downto 0); -- the highest part of the mul

			-- debug
			btb_cache_update_line_d, btb_cache_update_data_d, btb_cache_hit_read_d, btb_cache_hit_rw_d: out std_logic;
			btb_cache_read_address_d, btb_cache_rw_address_d: out std_logic_vector(29 downto 0);
			btb_cache_data_in_d, btb_cache_data_out_read_d, btb_cache_data_out_rw_d: out std_logic_vector(31 downto 0)
		);
	end component dlx_sim;

	constant F : string := "C:\Users\Nicole\Desktop\dlx\test_assembly\test_arith_new\test_arith.mem";
	constant period : time := 1 ns; 

	signal clk, rst, pc_en, predicted_taken, taken, wp_en, hilo_wr_en: std_logic;
	signal pc_out: std_logic_vector(29 downto 0);
	signal instr_fetched, wp_data, wp_alu_data_high: std_logic_vector(31 downto 0);

	signal btb_cache_update_line, btb_cache_update_data, btb_cache_hit_read, btb_cache_hit_rw: std_logic;
	signal btb_cache_read_address, btb_cache_rw_address: std_logic_vector(29 downto 0);
	signal btb_cache_data_in, btb_cache_data_out_read, btb_cache_data_out_rw: std_logic_vector(31 downto 0);
	
begin
	dut: dlx_sim
		generic map (
			F => F
		)
		port map (
			clk => clk,
			rst => rst,
			pc_en => pc_en,
			pc_out => pc_out,
			instr_fetched => instr_fetched,
			predicted_taken => predicted_taken,
			taken => taken,
			wp_en => wp_en,
			hilo_wr_en => hilo_wr_en,
			wp_data => wp_data,
			wp_alu_data_high => wp_alu_data_high,

			btb_cache_update_line_d => btb_cache_update_line,
			btb_cache_update_data_d => btb_cache_update_data,
			btb_cache_hit_read_d => btb_cache_hit_read,
			btb_cache_hit_rw_d => btb_cache_hit_rw,
			btb_cache_read_address_d => btb_cache_read_address,
			btb_cache_rw_address_d => btb_cache_rw_address,
			btb_cache_data_in_d => btb_cache_data_in,
			btb_cache_data_out_read_d => btb_cache_data_out_read,
			btb_cache_data_out_rw_d => btb_cache_data_out_rw
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
	begin
		rst <= '0';
		wait for period + period/2;
		rst <= '1';
		wait;
	end process test_proc;



end test;
