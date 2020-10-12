library ieee;
use ieee.std_logic_1164.all;

entity tb_cu is
end tb_cu;

architecture test of tb_cu is
	component cu is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- if stage inputs

			btb_addr_known_if: in std_logic; -- tells if the BTB has recognized or not the current PC address
			btb_predicted_taken_if: in std_logic; -- the BTB has predicted the branch to be taken
			instr_if: in std_logic_vector(31 downto 0); -- the fetched instruction

			-- if stage outputs

			pc_en_if: out std_logic; -- enable the PC register
			-- "00" if the next pc must me pc+4
			-- "01" if the next pc must be the one coming out from the BTB
			-- "10" if the next PC is the one coming out from the main adder
			-- "11" if the next PC is the one coming out from the secondary adder
			pc_sel_if: out std_logic_vector(1 downto 0);
			--btb_target_addr_if: out std_logic_vector(29 downto 0); -- address to be added to the BTB
	-- 0
			-- if/id regs

			en_npc_if: out std_logic;
			en_ir_if: out std_logic;
	-- 0
			-- id stage inputs

			rs_id: in std_logic_vector(4 downto 0);
			rt_id: in std_logic_vector(4 downto 0);

			-- id stage outputs

			i_instr_id: out std_logic; -- 1 if the istruction is of type I, 0 otherwise
			j_instr_id: out std_logic; -- 1 if the instruction is of type J, o otherwise
			-- rp1_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 output all 0s
			rp1_out_sel_id: out std_logic_vector(1 downto 0);
			-- rp2_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 output all 0s
			rp2_out_sel_id: out std_logic_vector(1 downto 0);
			is_signed_id: out std_logic; -- 1 if extension is signed, 0 if unsigned
			sign_ext_sel_id: out std_logic; -- 1 if the 16 bits input must be used, 0 if the 26 bits input must be used
			a_selector_id: out std_logic; -- 0 to select the PC as output, 1 to select the read port 1
			b_selector_id: out std_logic; -- 0 to select the immediate as output, 1 to select the read port 2
			data_tbs_selector_id: out std_logic; -- 0 to select the output of rp2, 1 to select the npc
	-- 11
			-- id/exe regs

			en_add_id: out std_logic;
		    en_mul_id: out std_logic;
		    en_shift_id: out std_logic;
		    en_a_neg_id: out std_logic;
		    shift_reg_id: out std_logic; -- signal that controls the shift register
		    en_shift_reg_id: out std_logic;
		    en_rd_id: out std_logic;
		    en_npc_id: out std_logic;
		    en_imm_id: out std_logic;
		    en_b_id: out std_logic;
	-- 21
			-- exe stage inputs

			taken_exe: in std_logic;

			-- exe stage outputs

			sub_add_exe: out std_logic;						-- 1 if it is a subtraction, 0 otherwise
	    	shift_type_exe: out std_logic_vector(3 downto 0);
	    	log_type_exe: out std_logic_vector(3 downto 0);
	    	op_type_exe: out std_logic_vector(1 downto 0);	-- 00: add/sub, 01: mul, 10: shift/rot, 11: log
	    	op_sign_exe: out std_logic; 						-- 1 if the operands are signed, 0 otherwise
	    	it_exe: out std_logic_vector(3 downto 0);		-- iterations of the multiplier
	    	neg_exe: out std_logic;							-- used to negate a before actually multiplying
	    	--fw_op_a_exe: out std_logic_vector(2 downto 0);	-- used to choose between the forwarded operands and the other ones
	    	--fw_op_b_exe: out std_logic_vector(1 downto 0);
	    	cond_sel_exe: out std_logic_vector(2 downto 0);  -- used to identify the condition of the branch instruction
	    	-- select if in the alu register goes the alu output or a comparison output
			-- "000" if le
			-- "001" if lt
			-- "010" if ge
			-- "011" if gt
			-- "100" if eq
			-- "101" if ne
			-- "110" if alu
			-- "111" reserved
			alu_comp_sel: out std_logic_vector(2 downto 0); 
	    	-- "00" if nothing has to be done
			-- "01" if an already known instruction has to be updated (taken/not taken)
			-- "10" if a new instruction must be added
			-- "11" reserved
			btb_update_exe: out std_logic_vector(1 downto 0);
			btb_taken_exe: out std_logic; -- when an address is being added to the BTB tells if it was taken or not
			fw_a: out std_logic_vector(1 downto 0); -- selection of operand a
			fw_b: out std_logic_vector(1 downto 0); -- selection of operand b
	--39
	    	-- exe/mem regs

	    	rd_exemem: in std_logic_vector(4 downto 0);
	    	
	    	en_output_exe: out std_logic;
			en_rd_exe: out std_logic;
			en_npc_exe: out std_logic;
			en_b_exe: out std_logic;
	-- 43
	    	-- mem stage inputs
	    	
			cu_resume_mem: in std_logic; -- raised by the memory controller when a cache miss has been solved
			hit_mem: in std_logic; -- if 1 the read operation was a hit, 0 otherwise
	    	
	    	-- mem stage outputs

	    	cpu_is_reading: out std_logic; -- used to discriminate by the memory controller false-positive cache misses when the CPU is not using at all the cache.
	    	wr_mem: out std_logic; -- 1 for writing to the cache, 0 for reading. In case of a cache miss it goes in high impedance
			-- controls how the data is added to the line. In case of a cache miss it goes in high impedance
			-- 00: stores N bits coming from the RAM
			-- 01: stores N bits coming from the CPU
			-- 10: stores N/2 bits coming from the CPU
			-- 11: stores N/4 bits coming from the CPU
			update_type_mem: out std_logic_vector(1 downto 0);
			ld_sign_mem: out std_logic; -- 1 if load is signed, 0 if unsigned
			-- controls how many bits of the word are kept after a load
			-- 00: load N bits
			-- 01: load N/2 bits
			-- 10: load N/4 bits
			-- 11: reserved
			ld_type_mem: out std_logic_vector(1 downto 0);
			alu_data_tbs_selector: out std_logic; -- 0 to select the output of the ALU, 1 to select the data_tbs
	-- 49
			-- mem/wb regs

			rd_memwb: in std_logic_vector(4 downto 0);

			en_alu_mem: out std_logic;
			en_cache_mem: out std_logic;
			en_rd_mem: out std_logic;
	-- 52
			-- wb stage inputs

			-- wb stage outputs
			wp_en_id: out std_logic; -- write port enable
			store_sel: out std_logic; -- 0 to select ALU output, 1 to select memory output
			hilo_wr_en_id: out std_logic -- 1 if the HI and LO register must be write
	-- 55
		);
	end component cu;

	constant period : time := 10 ns; 

	signal clk, rst: std_logic;

	signal btb_addr_known_if, btb_predicted_taken_if, pc_en_if, en_npc_if, en_ir_if: std_logic;
	signal instr_if: std_logic_vector(31 downto 0);
	signal pc_sel_if: std_logic_vector(1 downto 0);

	signal rs_id, rt_id: std_logic_vector(4 downto 0);
	signal i_instr_id, j_instr_id, is_signed_id, sign_ext_sel_id, a_selector_id, b_selector_id, data_tbs_selector_id, en_add_id, en_mul_id, en_shift_id, en_a_neg_id, shift_reg_id, en_shift_reg_id, en_rd_id, en_npc_id, en_imm_id, en_b_id: std_logic;
	signal rp1_out_sel_id, rp2_out_sel_id: std_logic_vector(1 downto 0);

	signal taken_exe, sub_add_exe, op_sign_exe, neg_exe, btb_taken_exe, en_output_exe, en_rd_exe, en_npc_exe, en_b_exe: std_logic;
	signal shift_type_exe, log_type_exe, it_exe: std_logic_vector(3 downto 0);
	signal op_type_exe, btb_update_exe, fw_a, fw_b: std_logic_vector(1 downto 0);
	signal cond_sel_exe, alu_comp_sel: std_logic_vector(2 downto 0);
	signal rd_exemem: std_logic_vector(4 downto 0);

	signal cu_resume_mem, hit_mem, cpu_is_reading, wr_mem, ld_sign_mem, alu_data_tbs_selector, en_alu_mem, en_cache_mem, en_rd_mem: std_logic;
	signal update_type_mem, ld_type_mem: std_logic_vector(1 downto 0);
	signal rd_memwb: std_logic_vector(4 downto 0);

	signal wp_en_id, store_sel, hilo_wr_en_id: std_logic;

begin
	dut: cu
		port map (
			clk => clk,
			rst => rst,
			btb_addr_known_if => btb_addr_known_if,
			btb_predicted_taken_if => btb_predicted_taken_if,
			instr_if => instr_if,
			pc_en_if => pc_en_if,
			pc_sel_if => pc_sel_if,

			en_npc_if => en_npc_if,
			en_ir_if => en_ir_if,

			rs_id => rs_id,
			rt_id => rt_id,
			i_instr_id => i_instr_id,
			j_instr_id => j_instr_id,
			rp1_out_sel_id => rp1_out_sel_id,
			rp2_out_sel_id => rp2_out_sel_id,
			is_signed_id => is_signed_id,
			sign_ext_sel_id => sign_ext_sel_id,
			a_selector_id => a_selector_id,
			b_selector_id => b_selector_id,
			data_tbs_selector_id => data_tbs_selector_id,

			en_add_id => en_add_id,
		    en_mul_id => en_mul_id,
		    en_shift_id => en_shift_id,
		    en_a_neg_id => en_a_neg_id,
		    shift_reg_id => shift_reg_id,
		    en_shift_reg_id => en_shift_reg_id,
		    en_rd_id => en_rd_id,
		    en_npc_id => en_npc_id,
		    en_imm_id => en_imm_id,
		    en_b_id => en_b_id,

			taken_exe => taken_exe,
			sub_add_exe => sub_add_exe,
	    	shift_type_exe => shift_type_exe,
	    	log_type_exe => log_type_exe,
	    	op_type_exe => op_type_exe,
	    	op_sign_exe => op_sign_exe,
	    	it_exe => it_exe,
	    	neg_exe => neg_exe,
	    	cond_sel_exe => cond_sel_exe,
			alu_comp_sel => alu_comp_sel,
			btb_update_exe => btb_update_exe,
			btb_taken_exe => btb_taken_exe,
			fw_a => fw_a,
			fw_b => fw_b,

	    	rd_exemem => rd_exemem,
	    	en_output_exe => en_output_exe,
			en_rd_exe => en_rd_exe,
			en_npc_exe => en_npc_exe,
			en_b_exe => en_b_exe,
	    	
			cu_resume_mem => cu_resume_mem,
			hit_mem => hit_mem,
	    	cpu_is_reading => cpu_is_reading,
	    	wr_mem => wr_mem,
			update_type_mem => update_type_mem,
			ld_sign_mem => ld_sign_mem,
			ld_type_mem => ld_type_mem,
			alu_data_tbs_selector => alu_data_tbs_selector,

			rd_memwb => rd_memwb,
			en_alu_mem => en_alu_mem,
			en_cache_mem => en_cache_mem,
			en_rd_mem => en_rd_mem,

			wp_en_id => wp_en_id,
			store_sel => store_sel,
			hilo_wr_en_id => hilo_wr_en_id
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
		-- clock 0 -> reset
		wait for period/2;
		rst <= '0';
		-- clock 0.5 -> reset
		wait for period;
		--clock 1.5 -> disable reset
		rst <= '1';
		wait for period/2;
		-- clock 2
		-- F: add r1, r2, r3
		-- D: nop
		-- E: nop
		-- M: nop
		-- W: nop
		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"00430820";

		rs_id <= "00000";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00000";

		wait for period;

		-- clock 3
		-- F: mult r4, r1
		-- D: add r1, r2, r3
		-- E: nop
		-- M: nop
		-- W: nop
		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"0081000e";

		rs_id <= "00010";
		rt_id <= "00011";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00000";

		wait for period;

		-- clock 4
		-- F: mflo r5
		-- D: mult r4, r1
		-- E: add r1, r2, r3
		-- M: nop
		-- W: nop
		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"00002812";

		rs_id <= "00100";
		rt_id <= "00001";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00000";

		wait for period;

		-- clock 5
		-- F: slli r6, r7, 4
		-- D: mflo r5
		-- E: mult r4, r1
		-- M: add r1, r2, r3
		-- W: nop
		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"50e60004";

		rs_id <= "00000";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00001";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00000";

		wait for period;

		-- clock 6
		-- F: slli r6, r7, 4
		-- D: mflo r5
		-- E: mult r4, r1
		-- M: ???
		-- W: add r1, r2, r3
		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"50e60004";

		rs_id <= "00000";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00001";

		wait for period;

		-- clock 6
		-- F: slli r6, r7, 4
		-- D: mflo r5
		-- E: mult r4, r1
		-- M: ???
		-- W: ???
		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"50e60004";

		rs_id <= "00000";
		rt_id <= "00001";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00001";

		wait until pc_en_if = '1';
		
		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"50e60004";

		rs_id <= "00000";
		rt_id <= "00001";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00001";
		
		wait for period;

		-- cycle N
		-- F: beqz r5, 100
		-- D: slli r6, r7, 4
		-- E: mflo r5
		-- M: ???
		-- W: ???

		-- THE MFLO AND SLLI ARE SKIPPED BY THE CU

		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"40a00050";

		rs_id <= "00111";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00001";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00001";

		wait for period;

		-- cycle N+1
		-- F: nop
		-- D: beqz r5, 100
		-- E: slli r6, r7, 4
		-- M: mflo r5
		-- W: ???

		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"00000000";

		rs_id <= "00101";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00101";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00001";

		wait for period;

		-- cycle N+2
		-- F: nop
		-- D: nop
		-- E: beqz r5, 100
		-- M: slli r6, r7, 4
		-- W: mflo r5

		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"00000000";

		rs_id <= "00000";
		rt_id <= "00000";

		taken_exe <= '1';

		rd_exemem <= "00110";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00101";

		wait for period;

		-- cycle N+3
		-- F: nop
		-- D: nop
		-- E: nop
		-- M: beqz r5, 100
		-- W: slli r6, r7, 4

		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"00000000";

		rs_id <= "00000";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00101";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00110";

		wait for period;

		-- cycle N+4
		-- F: nop
		-- D: nop
		-- E: nop
		-- M: nop
		-- W: beqz r5, 100

		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"00000000";

		rs_id <= "00000";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00101";

		wait for period;

		-- cycle N+4
		-- F: nop
		-- D: nop
		-- E: nop
		-- M: nop
		-- W: nop

		btb_addr_known_if <= '0';
		btb_predicted_taken_if <= '0';
		instr_if <= X"00000000";

		rs_id <= "00000";
		rt_id <= "00000";

		taken_exe <= '0';

		rd_exemem <= "00000";
		cu_resume_mem <= '1';
		hit_mem <= '0';

		rd_memwb <= "00000";

		wait;
	end process test_proc;
end test;
