library ieee;
use ieee.std_logic_1164.all;

entity dlx_syn is
	port (
		clk: in std_logic;
		rst: in std_logic;

		-- btb cache interface
		btb_cache_update_line: out std_logic;
		btb_cache_update_data: out std_logic;
		btb_cache_hit_read: in std_logic;
		btb_cache_hit_rw: in std_logic;
		btb_cache_read_address: out std_logic_vector(29 downto 0);
		btb_cache_rw_address: out std_logic_vector(29 downto 0);
		btb_cache_data_in: out std_logic_vector(31 downto 0);
		btb_cache_data_out_read: in std_logic_vector(31 downto 0);
		btb_cache_data_out_rw: in std_logic_vector(31 downto 0);
		
		-- IROM interface
		pc_out: out std_logic_vector(29 downto 0);
		instr_if: in std_logic_vector(31 downto 0);

		-- dcache interface
		dcache_hit: in std_logic;
		dcache_update: out std_logic;
		dcache_update_type: out std_logic_vector(1 downto 0);
		dcache_data_in: in std_logic_vector(31 downto 0); -- data coming from the dcache
		dcache_address: out std_logic_vector(31 downto 0); -- address used by the dcache
		dcache_data_out: out std_logic_vector(31 downto 0); -- data going to the cache
		ram_update: in std_logic; -- raised by the cache, signals the need of an eviction
		ram_to_cache_data: out std_logic_vector(31 downto 0);
		cache_to_ram_data: in std_logic_vector(31 downto 0);
		cpu_cache_address: in std_logic_vector(31 downto 0); -- address currently used to access the dcache propagated to the memory controller
		evicted_cache_address: in std_logic_vector(31 downto 0); -- memory address where to write the evicted data
		
		-- RAM interface
		ram_rw: out std_logic;
		ram_address: out std_logic_vector(7 downto 0);
		ram_data_in: out std_logic_vector(31 downto 0);
		ram_data_out: in std_logic_vector(31 downto 0);

		-- output interface (used to evaluate execution when simulating)
		pc_en: out std_logic; -- shows if the processor is stalling
		predicted_taken: out std_logic; -- shows if the current PC is a branch or jump has been predicted as taken
		taken: out std_logic; -- shows if a branch (or jump) has been taken or not
		wp_en: out std_logic; -- shows if the dlx is writing in the output port
		hilo_wr_en: out std_logic; -- shows if the dlx is storing the res of a mul 
		wp_data: out std_logic_vector(31 downto 0); -- the value being written in the RF
		wp_alu_data_high: out std_logic_vector(31 downto 0) -- the highest part of the mul
	);
end dlx_syn;

architecture structural of dlx_syn is
	component datapath is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- IF stage inputs

			instr_if: in std_logic_vector(25 downto 0); -- instruction fetched from the IROM
			pc_en_if: in std_logic;
			pc_sel_if: in std_logic_vector(1 downto 0);

			-- IF stage outputs
			
			pc_out: out std_logic_vector(29 downto 0); -- current PC value (used by the BTB cache and the IROM)
			btb_addr_known_if: out std_logic;
			btb_predicted_taken_if: out std_logic;

			-- IF/ID regs
			
			en_npc_if: in std_logic;
			en_ir_if: in std_logic;

			-- IF stage cache interface
			
			cache_rw_address: out std_logic_vector(29 downto 0);
			cache_update_line: out std_logic; -- set to 1 if the cache has to update a whole line
			cache_update_data: out std_logic; -- set to 1 if the cache has to update only a line's data
			cache_data_in: out std_logic_vector(31 downto 0); -- data to be written in the cache
			cache_data_out_read: in std_logic_vector(31 downto 0); -- data out of the read-only address port of the cache
			cache_data_out_rw: in std_logic_vector(31 downto 0); -- data out of the read-write address port of the cache
			cache_hit_read: in std_logic; -- set to 1 if the read-only address generated a hit 
			cache_hit_rw: in std_logic; -- set to 1 if the read-write address generated a hit

			-- ID stage inputs

			i_instr_id: in std_logic; -- 1 if the istruction is of type I, 0 otherwise
			j_instr_id: in std_logic; -- 1 if the instruction is of type J, o otherwise
			-- rp1_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 output all 0s
			rp1_out_sel_id: in std_logic_vector(1 downto 0);
			-- rp2_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 output all 0s
			rp2_out_sel_id: in std_logic_vector(1 downto 0);
			is_signed_id: in std_logic; -- 1 if extension is signed, 0 if unsigned
			sign_ext_sel_id: in std_logic; -- 1 if the 16 bits input must be used, 0 if the 26 bits input must be used
			a_selector_id: in std_logic; -- 0 to select the PC as output, 1 to select the read port 1
			b_selector_id: in std_logic; -- 0 to select the immediate as output, 1 to select the read port 2
			data_tbs_selector_id: in std_logic; -- 0 to select the output of rp2, 1 to select the npc

			-- ID stage outputs

			rs_id: out std_logic_vector(4 downto 0);
			rt_id: out std_logic_vector(4 downto 0);
			rd_id: out std_logic_vector(4 downto 0);

			-- ID/EXE regs

			en_add_id: in std_logic;
		    en_mul_id: in std_logic;
		    en_shift_id: in std_logic;
		    en_a_neg_id: in std_logic;
		    shift_reg_id: in std_logic; -- signal that controls the shift register
		    en_shift_reg_id: in std_logic;
		    en_rd_id: in std_logic;
		    en_npc_id: in std_logic;
		    en_imm_id: in std_logic;
		    en_b_id: in std_logic;

			-- EXE stage inputs
			
			sub_add_exe: in std_logic;						-- 1 if it is a subtraction, 0 otherwise
	    	shift_type_exe: in std_logic_vector(3 downto 0);
	    	log_type_exe: in std_logic_vector(3 downto 0);
	    	op_type_exe: in std_logic_vector(1 downto 0);	-- 00: add/sub, 01: mul, 10: shift/rot, 11: log
	    	op_sign_exe: in std_logic; 						-- 1 if the operands are signed, 0 otherwise
	    	it_exe: in std_logic_vector(3 downto 0);		-- iterations of the multiplier
	    	neg_exe: in std_logic;							-- used to negate a before actually multiplying
	    	cond_sel_exe: in std_logic_vector(2 downto 0);  -- used to identify the condition of the branch instruction
	    	-- select if in the alu register goes the alu output or a comparison output
			-- "000" if le
			-- "001" if lt
			-- "010" if ge
			-- "011" if gt
			-- "100" if eq
			-- "101" if ne
			-- "110" if alu
			-- "111" reserved
			alu_comp_sel: in std_logic_vector(2 downto 0); 
	    	-- "00" if nothing has to be done
			-- "01" if an already known instruction has to be updated (taken/not taken)
			-- "10" if a new instruction must be added
			-- "11" reserved
			btb_update_exe: in std_logic_vector(1 downto 0);
			btb_taken_exe: in std_logic; -- when an address is being added to the BTB tells if it was taken or not
			fw_a: in std_logic_vector(1 downto 0); -- selection of operand a
			fw_b: in std_logic_vector(1 downto 0); -- selection of operand b

			-- EXE stage outputs

			taken_exe: out std_logic;
			rs_exe: out std_logic_vector(4 downto 0);
			rt_exe: out std_logic_vector(4 downto 0);

			-- EXE/MEM regs
			
			en_output_exe: in std_logic;
			en_rd_exe: in std_logic;
			en_b_exe: in std_logic;

			rd_exemem: out std_logic_vector(4 downto 0);

			-- MEM stage inputs

			ld_sign_mem: in std_logic; -- 1 if load is signed, 0 if unsigned
			-- controls how many bits of the word are kept after a load
			-- 00: load N bits
			-- 01: load N/2 bits
			-- 10: load N/4 bits
			-- 11: reserved
			ld_type_mem: in std_logic_vector(1 downto 0);
			alu_data_tbs_selector: in std_logic; -- 0 to select the output of the ALU, 1 to select the data_tbs
			dcache_data_in: in std_logic_vector(31 downto 0); -- data coming from the dcache

			-- MEM stage outputs
			
			dcache_address: out std_logic_vector(31 downto 0); -- address used by the dcache
			dcache_data_out: out std_logic_vector(31 downto 0); -- data going to the cache
			
			-- MEM/WB regs

			en_alu_mem: in std_logic;
			en_cache_mem: in std_logic;
			en_rd_mem: in std_logic;

			rd_memwb: out std_logic_vector(4 downto 0);

			-- WB stage inputs

			wp_en_id: in std_logic; -- write port enable
			store_sel: in std_logic; -- 0 to select ALU output, 1 to select memory output
			hilo_wr_en_id: in std_logic; -- 1 if the HI and LO register must be write

			-- WB stage outputs
			wp_data: out std_logic_vector(31 downto 0); -- the value being written in the RF
			wp_alu_data_high: out std_logic_vector(31 downto 0) -- the highest part of the mul
		);
	end component datapath;

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
		-- if/id regs

		en_npc_if: out std_logic;
		en_ir_if: out std_logic;
		
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
		
		-- id/exe regs

		rd_idexe: in std_logic_vector(4 downto 0);

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

		-- exe stage inputs

		taken_exe: in std_logic;
		rs_exe: in std_logic_vector(4 downto 0);
		rt_exe: in std_logic_vector(4 downto 0);

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

    	-- exe/mem regs

    	rd_exemem: in std_logic_vector(4 downto 0);
    	
    	en_output_exe: out std_logic;
		en_rd_exe: out std_logic;
		--en_npc_exe: out std_logic;
		en_b_exe: out std_logic;

    	-- mem stage inputs
    	
		cu_resume_mem: in std_logic; -- raised by the memory controller when a cache miss has been solved
		hit_mem: in std_logic; -- if 1 the read operation was a hit, 0 otherwise
    	
    	-- mem stage outputs

    	cpu_is_reading: out std_logic; -- used to discriminate by the memory controller false-positive cache misses when the CPU is not using at all the cache.
    	wr_mem: out std_logic; -- 1 for writing to the cache, 0 for reading (this goes inside the memory controller).
    	dcache_update: out std_logic; -- 1 for writing to the cache, 0 for reading. In case of a cache miss it goes in high impedance
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

		-- mem/wb regs

		rd_memwb: in std_logic_vector(4 downto 0);

		en_alu_mem: out std_logic;
		en_cache_mem: out std_logic;
		en_rd_mem: out std_logic;

		-- wb stage inputs

		-- wb stage outputs
		wp_en_id: out std_logic; -- write port enable
		store_sel: out std_logic; -- 0 to select ALU output, 1 to select memory output
		hilo_wr_en_id: out std_logic -- 1 if the HI and LO register must be write
	);
	end component cu;

	component memory_controller is
		generic (
			N: integer := 32; -- data size
			C: integer := 32; -- cache address size
			A: integer := 8 -- RAM address size
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			wr: in std_logic; -- operation being performed by the CPU: 0 for read, 1 for write
			cpu_is_reading: in std_logic; -- used to discriminate false cache misses when the CPU is not using at all the cache. Set to 1 for reading, to 0 otherwise. During a write operation it's not important its value
			cpu_cache_address: in std_logic_vector(C-1 downto 0); -- address used by the CPU coming from the cache
			evicted_cache_address: in std_logic_vector(C-1 downto 0); -- address of the evicted data coming from the cache
			cache_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the cache
			cache_hit: in std_logic;
			cache_eviction: in std_logic;
			cache_update: out std_logic;
			cache_update_type: out std_logic_vector(1 downto 0); -- always set to "00" when writing data from the RAM
			cache_data_out: out std_logic_vector(N-1 downto 0); -- data going to the cache
			ram_data_in: in std_logic_vector(N-1 downto 0); -- data coming from the RAM
			ram_rw: out std_logic; -- rw = '1' read, rw = '0' write
			ram_address: out std_logic_vector(A-1 downto 0); -- address going to the RAM
			ram_data_out: out std_logic_vector(N-1 downto 0); -- data going to the RAM
			cu_resume: out std_logic -- used to communicate to the Cu that it can resume the execution after a cache miss 
		);
	end component memory_controller;

	-- IF stage signals
	signal btb_addr_known_if, btb_predicted_taken_if, pc_en_if: std_logic;
	signal pc_sel_if: std_logic_vector(1 downto 0);
	signal pc_out_int: std_logic_vector(29 downto 0);

	-- IF/ID signals
	signal en_npc_if, en_ir_if: std_logic;

	-- ID stage signals
	signal i_instr_id, j_instr_id, is_signed_id, sign_ext_sel_id, a_selector_id, b_selector_id, data_tbs_selector_id: std_logic;
	signal rp1_out_sel_id, rp2_out_sel_id: std_logic_vector(1 downto 0);
	signal rs_id, rt_id: std_logic_vector(4 downto 0);

	-- ID/EXE signals
	signal en_add_id, en_mul_id, en_shift_id, en_a_neg_id, shift_reg_id, en_shift_reg_id, en_rd_id, en_npc_id, en_imm_id, en_b_id: std_logic;
	signal rd_idexe: std_logic_vector(4 downto 0);

	-- EXE signals
	signal taken_exe, sub_add_exe, op_sign_exe, neg_exe, btb_taken_exe: std_logic;
	signal op_type_exe, btb_update_exe, fw_a, fw_b: std_logic_vector(1 downto 0);
	signal cond_sel_exe, alu_comp_sel: std_logic_vector(2 downto 0);
	signal shift_type_exe, log_type_exe, it_exe: std_logic_vector(3 downto 0);
	signal rs_exe, rt_exe: std_logic_vector(4 downto 0);

	-- EXE/MEM signals
	signal en_output_exe, en_rd_exe, en_b_exe: std_logic;
	signal rd_exemem: std_logic_vector(4 downto 0);

	-- MEM stage signals
	signal cu_resume_mem, cpu_is_reading, wr_mem, ld_sign_mem, alu_data_tbs_selector: std_logic;
	signal ld_type_mem: std_logic_vector(1 downto 0);
	signal update_type_mem_int: std_logic_vector(1 downto 0);

	-- MEM/WB signals
	signal en_alu_mem, en_cache_mem, en_rd_mem: std_logic;
	signal rd_memwb: std_logic_vector(4 downto 0);

	-- WB signals
	signal wp_en_id, store_sel, hilo_wr_en_id: std_logic;
	signal wp_data_wb, wp_alu_data_high_wb: std_logic_vector(31 downto 0);

begin

	pc_en <= pc_en_if;
	predicted_taken <= btb_predicted_taken_if;
	taken <= taken_exe;
	wp_en <= wp_en_id;
	hilo_wr_en <= hilo_wr_en_id;
	wp_data <= wp_data_wb;
	wp_alu_data_high <= wp_alu_data_high_wb;

	dp: datapath
		port map (
			clk => clk,
			rst => rst,

			instr_if => instr_if(25 downto 0),
			pc_en_if => pc_en_if,
			pc_sel_if => pc_sel_if,
			pc_out => pc_out_int,
			btb_addr_known_if => btb_addr_known_if,
			btb_predicted_taken_if => btb_predicted_taken_if,
			
			en_npc_if => en_npc_if,
			en_ir_if => en_ir_if,
			
			cache_rw_address => btb_cache_rw_address,
			cache_update_line => btb_cache_update_line,
			cache_update_data => btb_cache_update_data,
			cache_data_in => btb_cache_data_in,
			cache_data_out_read => btb_cache_data_out_read,
			cache_data_out_rw => btb_cache_data_out_rw,
			cache_hit_read => btb_cache_hit_read,
			cache_hit_rw => btb_cache_hit_rw,

			i_instr_id => i_instr_id,
			j_instr_id => j_instr_id,
			rp1_out_sel_id => rp1_out_sel_id,
			rp2_out_sel_id => rp2_out_sel_id,
			is_signed_id => is_signed_id,
			sign_ext_sel_id => sign_ext_sel_id,
			a_selector_id => a_selector_id,
			b_selector_id => b_selector_id,
			data_tbs_selector_id => data_tbs_selector_id,
			rs_id => rs_id,
			rt_id => rt_id,
			rd_id => rd_idexe,

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
			taken_exe => taken_exe,
			rs_exe => rs_exe,
			rt_exe => rt_exe,
			
			en_output_exe => en_output_exe,
			en_rd_exe => en_rd_exe,
			en_b_exe => en_b_exe,
			rd_exemem => rd_exemem,

			ld_sign_mem => ld_sign_mem,
			ld_type_mem => ld_type_mem,
			alu_data_tbs_selector => alu_data_tbs_selector,
			dcache_data_in => dcache_data_in,
			dcache_address => dcache_address,
			dcache_data_out => dcache_data_out,

			en_alu_mem => en_alu_mem,
			en_cache_mem => en_cache_mem,
			en_rd_mem => en_rd_mem,
			rd_memwb => rd_memwb,

			wp_en_id => wp_en_id,
			store_sel => store_sel,
			hilo_wr_en_id => hilo_wr_en_id,
			wp_data => wp_data_wb,
			wp_alu_data_high => wp_alu_data_high_wb
		);

	btb_cache_read_address <= pc_out_int;
	pc_out <= pc_out_int;

	ctrl_u: cu
		port map (
			clk => clk,
			rst => rst,

			instr_if => instr_if,
			pc_en_if => pc_en_if,
			pc_sel_if => pc_sel_if,
			btb_addr_known_if => btb_addr_known_if,
			btb_predicted_taken_if => btb_predicted_taken_if,
			
			en_npc_if => en_npc_if,
			en_ir_if => en_ir_if,

			i_instr_id => i_instr_id,
			j_instr_id => j_instr_id,
			rp1_out_sel_id => rp1_out_sel_id,
			rp2_out_sel_id => rp2_out_sel_id,
			is_signed_id => is_signed_id,
			sign_ext_sel_id => sign_ext_sel_id,
			a_selector_id => a_selector_id,
			b_selector_id => b_selector_id,
			data_tbs_selector_id => data_tbs_selector_id,
			rs_id => rs_id,
			rt_id => rt_id,
			rd_idexe => rd_idexe,

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
			taken_exe => taken_exe,
			rs_exe => rs_exe,
			rt_exe => rt_exe,
			
			en_output_exe => en_output_exe,
			en_rd_exe => en_rd_exe,
			en_b_exe => en_b_exe,
			rd_exemem => rd_exemem,

			cu_resume_mem => cu_resume_mem,
			hit_mem => dcache_hit,
			cpu_is_reading => cpu_is_reading,
			wr_mem => wr_mem,
			dcache_update => dcache_update,
			update_type_mem => update_type_mem_int,
			ld_sign_mem => ld_sign_mem,
			ld_type_mem => ld_type_mem,
			alu_data_tbs_selector => alu_data_tbs_selector,

			en_alu_mem => en_alu_mem,
			en_cache_mem => en_cache_mem,
			en_rd_mem => en_rd_mem,
			rd_memwb => rd_memwb,

			wp_en_id => wp_en_id,
			store_sel => store_sel,
			hilo_wr_en_id => hilo_wr_en_id
		);
		
	dcache_update_type <= update_type_mem_int;

	mc: memory_controller
		generic map (
			N => 32,
			C => 32,
			A => 8
		)
		port map (
			clk => clk,
			rst => rst,
			wr => wr_mem,
			cpu_is_reading => cpu_is_reading,
			cpu_cache_address => cpu_cache_address,
			evicted_cache_address => evicted_cache_address,
			cache_data_in => cache_to_ram_data,
			cache_hit => dcache_hit,
			cache_eviction => ram_update,
			cache_update => dcache_update,
			cache_update_type => update_type_mem_int,
			cache_data_out => ram_to_cache_data,
			ram_data_in => ram_data_out,
			ram_rw => ram_rw,
			ram_address => ram_address,
			ram_data_out => ram_data_in,
			cu_resume => cu_resume_mem
		);	
end structural;
