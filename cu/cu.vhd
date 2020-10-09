library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.control_words.all;
use work.func_words.all;
use work.opcodes.all;

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
		pc_sel_if: out std_logic_vector(1 downto 0);
		--btb_target_addr_if: out std_logic_vector(29 downto 0); -- address to be added to the BTB
-- 0
		-- if/id regs

		en_npc_if: out std_logic;
		en_ir_if: out std_logic;
-- 0
		-- id stage inputs

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
	type exe_state is (NORMAL_OP_EXE, A_NEG_SAMPLE, MUL_IN_PROG, MUL_END);
	type mem_state is (NORMAL_OP_MEM, CACHE_MISS);
	
	signal curr_es, next_es: exe_state;
	signal curr_ms, next_ms: mem_state;

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
									nop_fw, 		-- 001111
									beqz_cw, 		-- 010000
									bnez_cw, 		-- 010001
									nop_fw, 		-- 010010
									nop_fw, 		-- 010011
									slli_cw, 		-- 010100
									nop_fw, 		-- 010101
									srli_cw, 		-- 010110
									srai_cw, 		-- 010111
									seqi_cw, 		-- 011000
									snei_cw, 		-- 011001
									slti_cw, 		-- 011010
									sgti_cw, 		-- 011011
									slei_cw, 		-- 011100
									sgei_cw, 		-- 011101
									nop_fw, 		-- 011110
									nop_fw, 		-- 011111
									lb_cw, 			-- 100000
									lh_cw, 			-- 100001
									nop_fw, 		-- 100010
									lw_cw, 			-- 100011
									lbu_cw, 		-- 100100
									lhu_cw, 		-- 100101
									nop_fw, 		-- 100110
									nop_fw, 		-- 100111
									sb_cw, 			-- 101000
									sh_cw, 			-- 101001
									nop_fw, 		-- 101010
									nop_fw, 		-- 101011
									sw_cw, 			-- 101100
									nop_fw, 		-- 101101
									nop_fw, 		-- 101110
									nop_fw, 		-- 101111
									nop_fw, 		-- 110000
									nop_fw, 		-- 110001
									nop_fw, 		-- 110010
									nop_fw, 		-- 110011
									nop_fw, 		-- 110100
									nop_fw, 		-- 110101
									nop_fw, 		-- 110110
									nop_fw, 		-- 110111
									nop_fw, 		-- 111000
									nop_fw, 		-- 111001
									sltui_cw, 		-- 111010
									sgtui_cw, 		-- 111011
									sleui_cw, 		-- 111100
									sgeui_cw, 		-- 111101
									nop_fw, 		-- 111110
									nop_fw 			-- 111111
		);

	constant func_mem : func_array := (
									sll_fw, 		-- 000000
									nop_fw, 		-- 000001
									nop_fw, 		-- 000010
									nop_fw, 		-- 000011
									nop_fw, 		-- 000100
									nop_fw, 		-- 000101
									srl_fw, 		-- 000110
									sra_fw, 		-- 000111
									jr_fw, 		-- 001000
									jalr_fw, 		-- 001001
									nop_fw, 		-- 001010
									nop_fw, 		-- 001011
									nop_fw, 		-- 001100
									nop_fw, 		-- 001101
									mult_fw, 		-- 001110
									nop_fw, 		-- 001111
									mfhi_fw, 		-- 010000
									mflo_fw, 		-- 010001
									nop_fw, 		-- 010010
									nop_fw, 		-- 010011
									nop_fw, 		-- 010100
									nop_fw, 		-- 010101
									nop_fw, 		-- 010110
									nop_fw, 		-- 010111
									nop_fw, 		-- 011000
									nop_fw, 		-- 011001
									nop_fw, 		-- 011010
									nop_fw, 		-- 011011
									nop_fw, 		-- 011100
									nop_fw, 		-- 011101
									nop_fw, 		-- 011110
									nop_fw, 		-- 011111
									add_fw, 		-- 100000
									addu_fw, 		-- 100001
									sub_fw, 		-- 100010
									subu_fw, 		-- 100011
									and_fw, 		-- 100100
									or_fw, 			-- 100101
									xor_fw, 		-- 100110
									nop_fw, 		-- 100111
									seq_fw, 		-- 101000
									sne_fw, 		-- 101001
									slt_fw, 		-- 101010
									sgt_fw, 		-- 101011
									sle_fw, 		-- 101100
									sge_fw, 		-- 101101
									nop_fw, 		-- 101110
									nop_fw, 		-- 101111
									nop_fw, 		-- 110000
									nop_fw, 		-- 110001
									nop_fw, 		-- 110010
									nop_fw, 		-- 110011
									nop_fw, 		-- 110100
									nop_fw, 		-- 110101
									nop_fw, 		-- 110110
									nop_fw, 		-- 110111
									nop_fw, 		-- 111000
									nop_fw, 		-- 111001
									sltu_fw, 		-- 111010
									sgtu_fw, 		-- 111011
									sleu_fw, 		-- 111100
									sgeu_fw, 		-- 111101
									nop_fw, 		-- 111110
									nop_fw  		-- 111111
		);
	
	signal id_en, exe_en, mem_en, wb_en: std_logic;

	-- used by the EXE stage to communicate to the IF stage whether it has to use the PC calculated in the EXE stage or not
	-- "00": no PC
	-- "01": main adder PC
	-- "10": secondary adder PC;
	signal pc_exe: std_logic_vector(1 downto 0);

	constant STD_PC : std_logic_vector(1 downto 0) := "00";
	constant MAIN_ADD_PC: std_logic_vector(1 downto 0) := "01";
	constant SEC_ADD_PC : std_logic_vector(1 downto 0) := "10";

	signal curr_ak_id, next_ak_id, curr_ak_exe, next_ak_exe: std_logic; -- propagate addr_known from the IF to the EXE stage
	signal curr_id, next_id: std_logic_vector(57 downto 0);
	signal curr_exe, next_exe: std_logic_vector(36 downto 0);
	signal curr_mem, next_mem: std_logic_vector(12 downto 0);
	signal curr_wb, next_wb: std_logic_vector(2 downto 0);
	signal curr_mul_in_prog, next_mul_in_prog: std_logic; -- tells to the ID stage to not drive some signals while a multiplication is in progress. SOURCE OF STALL	
	signal curr_it, next_it: std_logic_vector(3 downto 0);
	signal curr_cache_miss, next_cache_miss: std_logic;
begin
	state_reg: process(clk, rst)
	begin
		if (clk = '1') then
			if (rst = '0') then
				curr_id <= nop_fw;
				curr_exe <= nop_fw(36 downto 0);
				curr_mem <= nop_fw(12 downto 0);
				curr_wb <= nop_fw(2 downto 0);
				curr_ak_id <= '0';
				curr_ak_exe <= '0';
				curr_mul_in_prog <= '0';
				curr_es <= NORMAL_OP_EXE;
				curr_it <= (others => '0');
				curr_ms <= NORMAL_OP_MEM;
				curr_cache_miss <= '0';
			else
				if (id_en = '1') then
					curr_id <= next_id;
					curr_ak_id <= next_ak_id;
				end if;

				if (exe_en = '1') then
					curr_exe <= next_exe;
					curr_ak_exe <= next_ak_exe;
					curr_mul_in_prog <= next_mul_in_prog;
					curr_es <= next_es;
					curr_it <= next_it;
				end if;

				if (mem_en = '1') then
					curr_mem <= next_mem;
					curr_cache_miss <= next_cache_miss;
				end if;

				if (wb_en = '1') then
					curr_wb <= next_wb;
				end if;
			end if;
		end if;
	end process state_reg;


	-- IF stage logic
	if_comblogic: process(btb_addr_known_if, btb_predicted_taken_if, instr_if, pc_exe)
	begin
		next_id <= curr_id;

		case (instr_if(31 downto 26)) is
			when rtype_opc => -- next_id must be fetched from func_mem
				if (instr_if(10 downto 6) = "00000") then
					-- the instruction is properly coded
					next_id <= func_mem(to_integer(unsigned(instr_if(5 downto 0))));
				else
					-- schedule a nop
					next_id <= nop_fw;	
				end if;

			when others => -- any other kind of instruction
				next_id <= cw_mem(to_integer(unsigned(instr_if(31 downto 26))));
		end case;

		case (pc_exe) is
			when STD_PC => -- the EXE didn't executed a branch or a jump
				if (btb_predicted_taken_if = '1') then
					pc_sel_if <= "01";
				else
					pc_sel_if <= "00";
				end if;

			when MAIN_ADD_PC => -- the EXE executed a jr or a jalr
				pc_sel_if <= "10";

			when SEC_ADD_PC => -- the EXE executed a branch or a jump with offset
				pc_sel_if <= "11";

			when others => -- by default use the pc + 4
				pc_sel_if <= "00";
		end case;

		next_ak_id <= btb_addr_known_if;
		en_npc_if <= '1';
		en_ir_if <= '1';
		pc_en_if <= '1';
	end process if_comblogic;

	-- ID stage logic
	id_comblogic: process(curr_id, curr_ak_id)
	begin
		next_exe <= curr_id(36 downto 0); -- pass to the EXE stage its control signals

		i_instr_id <= curr_id(57);
		j_instr_id <= curr_id(56);
		rp1_out_sel_id <= curr_id(55 downto 54);
		rp2_out_sel_id <= curr_id(53 downto 52);
		is_signed_id <= curr_id(51);
		sign_ext_sel_id <= curr_id(50);
		a_selector_id <= curr_id(49);
		b_selector_id <= curr_id(48);
		data_tbs_selector_id <= curr_id(47);

		en_add_id <= curr_id(46);
	    en_shift_id <= curr_id(44);
	    
	    if (curr_mul_in_prog = '0') then
	    	en_mul_id <= curr_id(45);
	    	en_a_neg_id <= curr_id(43);
	    	shift_reg_id <= curr_id(42);
	    	en_shift_reg_id <= curr_id(41);
	    else
	    	en_mul_id <= 'Z';
	    	en_a_neg_id <= 'Z';
	    	shift_reg_id <= 'Z';
	    	en_shift_reg_id <= 'Z';
	    end if;
	    
	    next_ak_exe <= curr_ak_id; -- propagate "addr_known" to the exe
	    en_rd_id <= curr_id(40);
	    en_npc_id <= curr_id(39);
	    en_imm_id <= curr_id(38);
	    en_b_id <= curr_id(37);
	end process id_comblogic;

	exe_comblogic: process(curr_exe, curr_mul_in_prog, curr_es, curr_ak_exe, taken_exe)
	begin
		next_mul_in_prog <= curr_mul_in_prog;
		next_es <= curr_es;
		it_exe <= curr_it;
		neg_exe <= '0';
		btb_update_exe <= "00";
		btb_taken_exe <= '0';
		neg_exe <= '1';
		en_mul_id <= 'Z';
	    en_a_neg_id <= 'Z';
	    shift_reg_id <= 'Z';
	    en_shift_reg_id <= 'Z';

		-- deliver the control signals to the EXE datapath
		sub_add_exe <= curr_exe(36);
    	shift_type_exe <= curr_exe(35 downto 32);
    	log_type_exe <= curr_exe(31 downto 28);
    	op_type_exe <= curr_exe(27 downto 26);
    	op_sign_exe <= curr_exe(25);
    	cond_sel_exe <= curr_exe(24 downto 22);
		alu_comp_sel <= curr_exe(21 downto 19);
		en_output_exe <= curr_exe(18);
		en_rd_exe <= curr_exe(17);
		en_npc_exe <= curr_exe(16);
		en_b_exe <= curr_exe(15);
		pc_exe <= curr_exe(14 downto 13);
		next_mem <= curr_exe(12 downto 0); -- propagate the remaining control signals to the MEM stage
    	
    	-- FSM to handle normal ops and multiplication 
		case (curr_es) is
			when NORMAL_OP_EXE => -- anything but a mul
				next_it <= (others => '0');
				if (curr_exe(16 downto 13) = "1000") then -- workaround to detect the start of a multiplication
					next_mul_in_prog <= '1'; -- stall IF and ID
					next_es <= A_NEG_SAMPLE;
				else
					if (curr_ak_exe = '1') then -- we're executing a branch (or a jump) known by the BTB
						btb_taken_exe <= taken_exe; -- tell to the BTB if the branch is taken or not (for jumps taken_exe is always equal to '1')
						btb_update_exe <= "01";
					else
						if (taken_exe = '1') then
							-- a new branch (or jump) has been discovered: add it to the BTB	
							btb_taken_exe <= taken_exe;
							btb_update_exe <= "10";
						end if;
					end if;
				end if;

			when A_NEG_SAMPLE => -- first the mul needs to sample "-a" 
				neg_exe <= '1';
				en_mul_id <= '0';
	    		en_a_neg_id <= '1';
	    		shift_reg_id <= '0';
	    		en_shift_reg_id <= '0';
	    		en_output_exe <= '1';
	    		next_it <= (others => '0');

			when MUL_IN_PROG => -- calculate the partial results
				neg_exe <= '0';
				en_mul_id <= '0';
	    		en_a_neg_id <= '0';
	    		shift_reg_id <= '1';
	    		en_shift_reg_id <= '1';
	    		en_output_exe <= '1';
	    		next_it <= std_logic_vector(unsigned(curr_it) + 1);
	    		if (curr_it = "1110") then
	    			next_es <= MUL_END;
	    			next_it <= curr_it;
	    		end if;

			when MUL_END => -- sample the result and unlock the pipeline
				neg_exe <= '0';
				en_mul_id <= '0';
	    		en_a_neg_id <= '0';
	    		shift_reg_id <= '0';
	    		en_shift_reg_id <= '0';
	    		en_output_exe <= '1';
	    		next_it <= "0000";
	    		next_mul_in_prog <= '0';
	    		next_es <= NORMAL_OP_EXE;

			when others => -- why are we even here?
				next_es <= NORMAL_OP_EXE;
		end case;

	end process exe_comblogic;

	mem_comblogic: process(curr_mem, curr_ms, curr_cache_miss, cu_resume_mem, hit_mem)
	begin
		wr_mem <= curr_mem(12);
		update_type_mem <= curr_mem(11 downto 10);
		ld_sign_mem <= curr_mem(9);
		ld_type_mem <= curr_mem(8 downto 7);
		alu_data_tbs_selector <= curr_mem(6);
		en_alu_mem <= curr_mem(5);
		en_cache_mem <= curr_mem(4);
		en_rd_mem <= curr_mem(3);
		next_wb <= curr_mem(2 downto 0);
		next_cache_miss <= '0';
		next_ms <= curr_ms;

		case (curr_ms) is
			when NORMAL_OP_MEM =>
				if (curr_mem(12) = '0' and hit_mem = '0') then
					-- we have detected a cache miss, pass the ball to the memory controller
					next_ms <= CACHE_MISS;
					next_cache_miss <= '1'; -- stall IF, ID and EXE
				end if;

			when CACHE_MISS =>
				-- allow the memory controller to perform its job 
				wr_mem <= 'Z';
				update_type_mem <= "ZZ";
				if (cu_resume_mem = '1') then
					next_ms <= NORMAL_OP_MEM;
					next_cache_miss <= '0'; -- unlock the pipeline
				end if;

			when others =>
				next_ms <= NORMAL_OP_MEM;
		end case;
	end process mem_comblogic;

	wb_comblogic: process(curr_wb)
	begin
		wp_en_id <= curr_wb(2);
		store_sel <= curr_wb(1);
		hilo_wr_en_id <= curr_wb(0);
	end process wb_comblogic;
end behavioral;