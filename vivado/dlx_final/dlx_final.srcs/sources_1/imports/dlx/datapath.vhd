library ieee;
use ieee.std_logic_1164.all;

entity datapath is
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

		en_rs_rt_id: in std_logic;
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
end datapath;

architecture structural of datapath is
	component if_stage is
		port (
			clk: in std_logic;
			rst: in std_logic;

			pc_out: out std_logic_vector(29 downto 0); -- current PC value (used by the BTB cache and the IROM)
			pc_plus4_out: out std_logic_vector(29 downto 0); -- PC+4 value (used in the datapath)

			-- control interface
			pc_en: in std_logic; -- enable the PC register
			-- "00" if the next pc must me pc+4
			-- "01" if the next pc must be the one coming out from the BTB
			-- "10" if the next PC is the one coming out from the main adder
			-- "11" if the next PC is the one coming out from the secondary adder
			pc_sel: in std_logic_vector(1 downto 0);
			pc_main_adder: in std_logic_vector(29 downto 0);
			pc_secondary_adder: in std_logic_vector(29 downto 0);
			btb_pc_exe: in std_logic_vector(29 downto 0); -- pc+4 coming from the exe. Used as rw_address of the BTB
			-- "00" if nothing has to be done
			-- "01" if an already known instruction has to be updated (taken/not taken)
			-- "10" if a new instruction must be added
			-- "11" reserved
			btb_update: in std_logic_vector(1 downto 0);
			btb_taken: in std_logic; -- when an address is being added to the BTB tells if it was taken or not
			btb_addr_known: out std_logic; -- tells if the BTB has recognized or not the current PC address
			btb_predicted_taken: out std_logic; -- the BTB has predicted the branch to be taken

			-- cache interface
			cache_rw_address: out std_logic_vector(29 downto 0); -- address to perform write operations
			cache_update_line: out std_logic; -- set to 1 if the cache has to update a whole line
			cache_update_data: out std_logic; -- set to 1 if the cache has to update only a line's data
			cache_data_in: out std_logic_vector(31 downto 0); -- data to be written in the cache
			cache_data_out_read: in std_logic_vector(31 downto 0); -- data out of the read-only address port of the cache
			cache_data_out_rw: in std_logic_vector(31 downto 0); -- data out of the read-write address port of the cache
			cache_hit_read: in std_logic; -- set to 1 if the read-only address generated a hit 
			cache_hit_rw: in std_logic -- set to 1 if the read-write address generated a hit
		);
	end component if_stage;

	component if_id_reg is
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
	end component if_id_reg;

	component id_stage is
		port (
			clk: in std_logic;
			rst: in std_logic;

			pc: in std_logic_vector(31 downto 0);

			-- RF interface
			instr: in std_logic_vector(25 downto 0); -- instruction bits, without opcode
			i_instr: in std_logic; -- 1 if the istruction is of type I, 0 otherwise
			j_instr: in std_logic; -- 1 if the instruction is of type J, o otherwise
			wp_addr: in std_logic_vector(4 downto 0); -- write port address, coming from the WB stage
			wp_en: in std_logic; -- write port enable
			wp: in std_logic_vector(31 downto 0); -- data to be written in the RF
			-- rp1_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 output all 0s
			rp1_out_sel: in std_logic_vector(1 downto 0);
			-- rp2_out_sel values:
			-- 		00 for an arch register
			-- 		01 for the LO register
			-- 		10 for the HI register
			-- 		11 output all 0s
			rp2_out_sel: in std_logic_vector(1 downto 0);
			hilo_wr_en: in std_logic; -- 1 if the HI and LO register must be written
			lo_in: in std_logic_vector(31 downto 0); -- input data for the LO register
			hi_in: in std_logic_vector(31 downto 0); -- input data for the HI register

			-- sign extender interface
			is_signed: in std_logic; -- 1 if extension is signed, 0 if unsigned
			sign_ext_sel: in std_logic; -- 1 if the 16 bits input must be used, 0 if the 26 bits input must be used

			-- output interface
			a_selector: in std_logic; -- 0 to select the PC as output, 1 to select the read port 1
			b_selector: in std_logic; -- 0 to select the immediate as output, 1 to select the read port 2
			rs_out: out std_logic_vector(4 downto 0); -- index value of the rd register
			rt_out: out std_logic_vector(4 downto 0); -- index value of the rt register
			data_tbs_selector: in std_logic; -- 0 to select the output of rp2, 1 to select the npc
			a: out std_logic_vector(31 downto 0); -- first operand output
			b: out std_logic_vector(31 downto 0); -- second operand output
			dest_reg: out std_logic_vector(4 downto 0); -- propagate the destination register to the subsequent stages
			npc: out std_logic_vector(31 downto 0); -- propagate the PC to the EXE stage
			imm: out std_logic_vector(31 downto 0); -- propagate the immediate (needed for PC + offset calculation)
			data_tbs: out std_logic_vector(31 downto 0) -- data to be stored (used for str ops and to pass the return address to be stored in r31 in case of a jalr)
		);
	end component id_stage;

	component id_ex_reg is
		port (
			clk: in std_logic;
			rst: in std_logic;

			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(31 downto 0);
			a_neg_in: in std_logic_vector(63 downto 0);
			rs_in: in std_logic_vector(4 downto 0);
			rt_in: in std_logic_vector(4 downto 0);
			Rd_in: in std_logic_vector(4 downto 0); -- destination register
			npc_in: in std_logic_vector(31 downto 0);
			imm_in: in std_logic_vector(31 downto 0);
			op_b_in: in std_logic_vector(31 downto 0);
		
			-- control signals
			en_rs_rt_id: in std_logic;
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
			rs_idexe: out std_logic_vector(4 downto 0);
			rt_idexe: out std_logic_vector(4 downto 0);
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
	    	a_adder_fw_ex: in std_logic_vector(31 downto 0);
	    	b_adder_fw_ex: in std_logic_vector(31 downto 0);
	    	a_shift_fw_ex: in std_logic_vector(31 downto 0);
	    	b_shift_fw_ex: in std_logic_vector(4 downto 0);

	    	-- forwarded mem/wb operands
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
	    	-- fw_op: used to choose between the forwarded operands and the other ones
	    	-- 00: normal operand
	    	-- 01: forwarded operand from ex/mem
	    	-- 10: forwarded operand from mem/wb
	    	-- 11: reserved
	    	fw_op_a: in std_logic_vector(1 downto 0); 
	    	fw_op_b: in std_logic_vector(1 downto 0);
	    	cond_sel: in std_logic_vector(2 downto 0); -- used to identify the condition of the branch instruction	
	    	alu_comp_sel: in std_logic_vector(2 downto 0); -- used to select the output to be stored in the alu out register

	    	-- outputs
	    	npc_jr: out std_logic_vector(31 downto 0); -- used by jalr and jr
	    	alu_out_high: out std_logic_vector(31 downto 0);
	    	alu_out_low: out std_logic_vector(31 downto 0);
	    	a_neg_out: out std_logic_vector(63 downto 0); -- negated a that goes back to the multiplier
	    	npc_jump: out std_logic_vector(31 downto 0); -- used by j instructions and branches
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

	component mem_stage is
		port (
			alu_data_tbs_selector: in std_logic; -- 0 to select the output of the alu, 1 to select data_tbs (op_b) to be stored in the RF
			ld_sign: in std_logic; -- 1 if load is signed, 0 if unsigned
			-- controls how many bits of the word are kept after a load
			-- 00: load N bits
			-- 01: load N/2 bits
			-- 10: load N/4 bits
			-- 11: reserved
			ld_type: in std_logic_vector(1 downto 0);
			op_b_in: in std_logic_vector(31 downto 0);
			alu_out_low_in: in std_logic_vector(31 downto 0);
			mem_data_in: in std_logic_vector(31 downto 0);
			mem_data_out: out std_logic_vector(31 downto 0);
			data_tbs: out std_logic_vector(31 downto 0)
		);
	end component mem_stage;

	component mem_wb_reg is
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
	end component mem_wb_reg;

	component wb_stage is
		port (
			store_sel: in std_logic; -- 0 to select data_tbs, 1 to select the cache
			data_tbs_in: in std_logic_vector(31 downto 0);
			data_cache_in: in std_logic_vector(31 downto 0);
			data_rf: out std_logic_vector(31 downto 0) -- data to be stored in the RF
		);
	end component wb_stage;

	signal pc_plus4_out_if_int: std_logic_vector(29 downto 0);
	
	signal ir_if_id_int: std_logic_vector(25 downto 0);
	signal npc_if_id_int: std_logic_vector(31 downto 0);

	signal dest_reg_id_int, rs_id_int, rt_id_int: std_logic_vector(4 downto 0);
	signal a_id_int, b_id_int, npc_id_int, imm_id_int, data_tbs_id_int: std_logic_vector(31 downto 0);

	signal b_mult_id_exe_int, b10_1_mult_id_exe_int: std_logic_vector(2 downto 0);
	signal rd_out_id_exe_int, b_shift_id_exe_int: std_logic_vector(4 downto 0);
	signal op_b_id_exe_int, npc_id_exe_int, imm_id_exe_int, a_adder_id_exe_int, b_adder_id_exe_int, a_shift_id_exe_int: std_logic_vector(31 downto 0);
	signal a_mult_id_exe_int, a_neg_mult_id_exe_int: std_logic_vector(63 downto 0);
	
	signal npc_jr_exe_int, alu_out_high_exe_int, alu_out_low_exe_int, npc_jump_exe_int: std_logic_vector(31 downto 0);
	signal a_neg_out_exe_int: std_logic_vector(63 downto 0);

	signal rd_out_exe_mem_int: std_logic_vector(4 downto 0);
	signal op_b_exe_mem_int, alu_out_high_exe_mem_int, alu_out_low_exe_mem_int: std_logic_vector(31 downto 0);
	signal mul_feedback_exe_mem_int: std_logic_vector(63 downto 0);

	signal cache_in_mem_int, data_tbs_mem_int: std_logic_vector(31 downto 0);

	signal rd_out_mem_wb_int: std_logic_vector(4 downto 0);
	signal alu_out_high_mem_wb_int, alu_out_low_mem_wb_int, cache_data_mem_wb_int: std_logic_vector(31 downto 0);

	signal wp_wb_int: std_logic_vector(31 downto 0);
begin
	ifs: if_stage
		port map (
			clk => clk,
			rst => rst,
			pc_out => pc_out,
			pc_plus4_out => pc_plus4_out_if_int,
			pc_en => pc_en_if,
			pc_sel => pc_sel_if,
			pc_main_adder => npc_jr_exe_int(31 downto 2),
			pc_secondary_adder => npc_jump_exe_int(31 downto 2),
			btb_pc_exe => npc_id_exe_int(31 downto 2),
			btb_update => btb_update_exe,
			btb_taken => btb_taken_exe,
			btb_addr_known => btb_addr_known_if,
			btb_predicted_taken => btb_predicted_taken_if,
			cache_rw_address => cache_rw_address,
			cache_update_line => cache_update_line,
			cache_update_data => cache_update_data,
			cache_data_in => cache_data_in,
			cache_data_out_read => cache_data_out_read,
			cache_data_out_rw => cache_data_out_rw,
			cache_hit_read => cache_hit_read,
			cache_hit_rw => cache_hit_rw
		);

	if_id_regs: if_id_reg
		port map (
			clk => clk,
			rst => rst,
			npc_in => pc_plus4_out_if_int,
			ir_in => instr_if,
			en_npc => en_npc_if,
			en_ir => en_ir_if,
			npc_out => npc_if_id_int,
			ir_out => ir_if_id_int
		);

	ids: id_stage
		port map (
			clk => clk,
			rst => rst,
			pc => npc_if_id_int,
			instr => ir_if_id_int,
			i_instr => i_instr_id,
			j_instr => j_instr_id,
			wp_addr => rd_out_mem_wb_int,
			wp_en => wp_en_id,
			wp => wp_wb_int,
			rp1_out_sel => rp1_out_sel_id,
			rp2_out_sel => rp2_out_sel_id,
			hilo_wr_en => hilo_wr_en_id,
			lo_in => alu_out_low_mem_wb_int,
			hi_in => alu_out_high_mem_wb_int,
			is_signed => is_signed_id,
			sign_ext_sel => sign_ext_sel_id,
			rs_out => rs_id_int,
			rt_out => rt_id_int,
			a_selector => a_selector_id,
			b_selector => b_selector_id,
			data_tbs_selector => data_tbs_selector_id,
			a => a_id_int,
			b => b_id_int,
			dest_reg => dest_reg_id_int,
			npc => npc_id_int,
			imm => imm_id_int,
			data_tbs => data_tbs_id_int
		);

	rs_id <= rs_id_int;
	rt_id <= rt_id_int;
	rd_id <= dest_reg_id_int;

	id_exe_regs: id_ex_reg
		port map (
			clk => clk,
			rst => rst,
			a => a_id_int,
			b => b_id_int,
			en_rs_rt_id => en_rs_rt_id,
			a_neg_in => a_neg_out_exe_int,
			rs_in => rs_id_int,
			rt_in => rt_id_int,
			Rd_in => dest_reg_id_int,
			npc_in => npc_id_int,
			imm_in => imm_id_int,
			op_b_in => data_tbs_id_int,
			en_add => en_add_id,
		    en_mul => en_mul_id,
		    en_shift => en_shift_id,
		    en_a_neg => en_a_neg_id,
		    shift_reg => shift_reg_id,
		    en_shift_reg => en_shift_reg_id,
		    en_rd => en_rd_id,
		    en_npc => en_npc_id,
		    en_imm => en_imm_id,
		    en_b => en_b_id,
			op_b => op_b_id_exe_int,
			npc => npc_id_exe_int,
			imm => imm_id_exe_int,
			rs_idexe => rs_exe,
			rt_idexe => rt_exe,
			Rd_out => rd_out_id_exe_int,
			a_adder => a_adder_id_exe_int,
			b_adder => b_adder_id_exe_int,
			a_mult => a_mult_id_exe_int,
			a_neg_mult => a_neg_mult_id_exe_int,
			b_mult => b_mult_id_exe_int,
			b10_1_mult => b10_1_mult_id_exe_int,
			a_shift => a_shift_id_exe_int,
			b_shift => b_shift_id_exe_int
		);

	exs: ex_stage
		port map (
	    	a_adder => a_adder_id_exe_int, 
	    	b_adder => b_adder_id_exe_int,
	    	a_mult => a_mult_id_exe_int,
	    	a_neg_mult => a_neg_mult_id_exe_int,
	    	b_mult => b_mult_id_exe_int,
	    	b10_1_mult => b10_1_mult_id_exe_int,
	    	a_shift => a_shift_id_exe_int,
	    	b_shift => b_shift_id_exe_int,
	    	mul_feedback => mul_feedback_exe_mem_int,
	    	npc_in => npc_id_exe_int,
	    	imm_in => imm_id_exe_int,
	    	a_adder_fw_ex => alu_out_low_exe_mem_int,
	    	b_adder_fw_ex => alu_out_low_exe_mem_int,
	    	a_shift_fw_ex => alu_out_low_exe_mem_int,
	    	b_shift_fw_ex => alu_out_low_exe_mem_int(4 downto 0),
	    	a_adder_fw_mem => wp_wb_int,
	    	b_adder_fw_mem => wp_wb_int,
	    	a_shift_fw_mem => wp_wb_int,
	    	b_shift_fw_mem => wp_wb_int(4 downto 0),
	    	sub_add => sub_add_exe,
	    	shift_type => shift_type_exe,
	    	log_type => log_type_exe,
	    	op_type => op_type_exe,
	    	op_sign => op_sign_exe,
	    	it => it_exe,
	    	neg => neg_exe,
	    	fw_op_a => fw_a,
	    	fw_op_b => fw_b,
	    	cond_sel => cond_sel_exe,
	    	alu_comp_sel => alu_comp_sel,
	    	npc_jr => npc_jr_exe_int,
	    	alu_out_high => alu_out_high_exe_int,
	    	alu_out_low => alu_out_low_exe_int,
	    	a_neg_out => a_neg_out_exe_int,
	    	npc_jump => npc_jump_exe_int,
	    	taken => taken_exe
		);

	ex_mem_regs: ex_mem_reg
		port map (
			clk => clk,
			rst => rst,
			op_b_in => op_b_id_exe_int,
			alu_out_high_in => alu_out_high_exe_int,
	    	alu_out_low_in => alu_out_low_exe_int,
			Rd_in => rd_out_id_exe_int,
			en_output => en_output_exe,
			en_rd => en_rd_exe,
			en_b => en_b_exe,
			op_b => op_b_exe_mem_int,
			Rd_out => rd_out_exe_mem_int,
			mul_feedback => mul_feedback_exe_mem_int,
			alu_out_high => alu_out_high_exe_mem_int,
	    	alu_out_low => alu_out_low_exe_mem_int
		);

	rd_exemem <= rd_out_exe_mem_int;

	mems: mem_stage
		port map (
			alu_data_tbs_selector => alu_data_tbs_selector,
			ld_sign => ld_sign_mem,
			ld_type => ld_type_mem,
			op_b_in => op_b_exe_mem_int,
			alu_out_low_in => alu_out_low_exe_mem_int,
			mem_data_in => dcache_data_in,
			mem_data_out => cache_in_mem_int,
			data_tbs => data_tbs_mem_int
		);
    
    dcache_address <= alu_out_low_exe_mem_int;
	dcache_data_out <= op_b_exe_mem_int;
	
	mem_wb_regs: mem_wb_reg
		port map (
			clk => clk,
			rst => rst,
			alu_out_high_in => alu_out_high_exe_mem_int,
			alu_out_low_in => data_tbs_mem_int,
			cache_in => cache_in_mem_int,
			rd_in => rd_out_exe_mem_int,
			en_alu_out => en_alu_mem,
			en_cache => en_cache_mem,
			en_rd => en_rd_mem,
			alu_out_high => alu_out_high_mem_wb_int,
			alu_out_low => alu_out_low_mem_wb_int,
			cache_data => cache_data_mem_wb_int,
			rd => rd_out_mem_wb_int
		);

	rd_memwb <= rd_out_mem_wb_int;

	wbs: wb_stage
		port map (
			store_sel => store_sel,
			data_tbs_in => alu_out_low_mem_wb_int,
			data_cache_in => cache_data_mem_wb_int,
			data_rf => wp_wb_int
		);

	wp_data <= wp_wb_int;
	wp_alu_data_high <= alu_out_high_mem_wb_int;
end structural;
