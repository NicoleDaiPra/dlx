library ieee;
use ieee.std_logic_1164.all;
use work.control_words.all;
use work.func_words.all;

entity cu is
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
		pc_sel: in std_logic_vector(1 downto 0);
		--btb_target_addr_if: out std_logic_vector(29 downto 0); -- address to be added to the BTB
-- 0
		-- if/id regs

		en_npc_if: out std_logic;
		en_ir_if: out std_logic;
-- 0
		-- id stage inputs

		-- id stage outputs

		i_instr_id: out std_logic; -- 1 if the istruction is of type I, 0 otherwise
		j_instr_id: in std_logic; -- 1 if the instruction is of type J, o otherwise
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
--39
    	-- exe/mem regs
    	
    	en_output_exe: out std_logic;
		en_rd_exe: out std_logic;
		en_npc_exe: out std_logic;
		en_b_exe: out std_logic;
-- 43
    	-- mem stage inputs
    	
		cu_resume_mem: in std_logic; -- raised by the memory controller when a cache miss has been solved
		hit_mem: in std_logic; -- if 1 the read operation was a hit, 0 otherwise
		cache_eviction_mem: in std_logic; -- tells if the cache has to perform an eviction
    	
    	-- mem stage outputs
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
end cu;



architecture behavioral of cu is
	type cw_array is array (0 to 63) of cw_t;
	type func_array is array (0 to 63) of fw_t;

	constant cw_mem : cw_array := (
									rtype_cw,		-- 000000
									bgez_bltz_cw,	-- 000001
									j_cw, 			-- 000010
									jal_cw, 		-- 000011
									beq_cw, 		-- 000100
									bne_cw, 		-- 000101
									blez_cw, 		-- 000110
									bgtz_cw, 		-- 000111
									addi_cw, 		-- 001000
									addui_cw, 		-- 001001
									subi_cw, 		-- 001010
									subui_cw, 		-- 001011
									andi_cw, 		-- 001100
									ori_cw, 		-- 001101
									xori_cw, 		-- 001110
									nop_cw, 		-- 001111
									beqz_cw, 		-- 010000
									bnez_cw, 		-- 010001
									nop_cw, 		-- 010010
									nop_cw, 		-- 010011
									slli_cw, 		-- 010100
									nop_cw, 		-- 010101
									srli_cw, 		-- 010110
									srai_cw, 		-- 010111
									seqi_cw, 		-- 011000
									snei_cw, 		-- 011001
									slti_cw, 		-- 011010
									sgti_cw, 		-- 011011
									slei_cw, 		-- 011100
									sgei_cw, 		-- 011101
									nop_cw, 		-- 011110
									nop_cw, 		-- 011111
									lb_cw, 			-- 100000
									lh_cw, 			-- 100001
									nop_cw, 		-- 100010
									lw_cw, 			-- 100011
									lbu_cw, 		-- 100100
									lhu_cw, 		-- 100101
									nop_cw, 		-- 100110
									nop_cw, 		-- 100111
									sb_cw, 			-- 101000
									sh_cw, 			-- 101001
									nop_cw, 		-- 101010
									nop_cw, 		-- 101011
									sw_cw, 			-- 101100
									nop_cw, 		-- 101101
									nop_cw, 		-- 101110
									nop_cw, 		-- 101111
									nop_cw, 		-- 110000
									nop_cw, 		-- 110001
									nop_cw, 		-- 110010
									nop_cw, 		-- 110011
									nop_cw, 		-- 110100
									nop_cw, 		-- 110101
									nop_cw, 		-- 110110
									nop_cw, 		-- 110111
									nop_cw, 		-- 111000
									nop_cw, 		-- 111001
									sltui_cw, 		-- 111010
									sgtui_cw, 		-- 111011
									sleui_cw, 		-- 111100
									sgeui_cw, 		-- 111101
									nop_cw, 		-- 111110
									nop_cw 			-- 111111
		);

	constant func_mem : func_array := (
									sll_func, 		-- 000000
									nop_func, 		-- 000001
									nop_func, 		-- 000010
									nop_func, 		-- 000011
									nop_func, 		-- 000100
									nop_func, 		-- 000101
									srl_func, 		-- 000110
									sra_func, 		-- 000111
									jr_func, 		-- 001000
									jalr_func, 		-- 001001
									nop_func, 		-- 001010
									nop_func, 		-- 001011
									nop_func, 		-- 001100
									nop_func, 		-- 001101
									mult_func, 		-- 001110
									nop_func, 		-- 001111
									mfhi_func, 		-- 010000
									mflo_func, 		-- 010001
									nop_func, 		-- 010010
									nop_func, 		-- 010011
									nop_func, 		-- 010100
									nop_func, 		-- 010101
									nop_func, 		-- 010110
									nop_func, 		-- 010111
									nop_func, 		-- 011000
									nop_func, 		-- 011001
									nop_func, 		-- 011010
									nop_func, 		-- 011011
									nop_func, 		-- 011100
									nop_func, 		-- 011101
									nop_func, 		-- 011110
									nop_func, 		-- 011111
									add_func, 		-- 100000
									addu_func, 		-- 100001
									sub_func, 		-- 100010
									subu_func, 		-- 100011
									and_func, 		-- 100100
									or_func, 		-- 100101
									xor_func, 		-- 100110
									nop_func, 		-- 100111
									seq_func, 		-- 101000
									sne_func, 		-- 101001
									slt_func, 		-- 101010
									sgt_func, 		-- 101011
									sle_func, 		-- 101100
									sge_func, 		-- 101101
									nop_func, 		-- 101110
									nop_func, 		-- 101111
									nop_func, 		-- 110000
									nop_func, 		-- 110001
									nop_func, 		-- 110010
									nop_func, 		-- 110011
									nop_func, 		-- 110100
									nop_func, 		-- 110101
									nop_func, 		-- 110110
									nop_func, 		-- 110111
									nop_func, 		-- 111000
									nop_func, 		-- 111001
									sltu_func, 		-- 111010
									sgtu_func, 		-- 111011
									sleu_func, 		-- 111100
									sgeu_func, 		-- 111101
									nop_func, 		-- 111110
									nop_func  		-- 111111
		);
	
	-- used by the EXE stage to communicate to the IF stage whether it has to use the PC calculated in the EXE stage or not
	-- "00": no PC
	-- "01": main adder PC
	-- "10": secondary adder PC
	signal exe_pc: std_logic_vector(1 downto 0);

	-- THEY HAVE TO BE SIZED AGAIN
	signal curr_id, next_id: std_logic_vector(40 downto 0);
	signal curr_exe, next_exe: std_logic_vector(22 downto 0);
	signal curr_mem, next_mem: std_logic_vector(7 downto 0);
	signal curr_wb, next_wb: std_logic_vector(1 downto 0);
begin

end behavioral;