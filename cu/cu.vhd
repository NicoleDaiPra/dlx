library ieee;
use ieee.std_logic_1164.all;

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
		pc_sel: in std_logic_vector(1 downto 0); -- 1 if the next pc must be pc+4, 0 if it has to be the one coming out from the BTB
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
-- 9
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
-- 18
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
--33
    	-- exe/mem regs
    	
    	en_output_exe: out std_logic;
		en_rd_exe: out std_logic;
		en_npc_exe: out std_logic;
		en_b_exe: out std_logic;
-- 33
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
-- 36
		-- mem/wb regs
		en_alu_mem: out std_logic;
		en_cache_mem: out std_logic;
		en_rd_mem: out std_logic;
-- 39
		-- wb stage inputs

		-- wb stage outputs
		wp_en_id: out std_logic; -- write port enable
		hilo_wr_en_id: out std_logic -- 1 if the HI and LO register must be write
-- 41		
	);
end cu;



architecture behavioral of cu is
	type cw_array is array (0 to 63) of std_logic_vector(41 downto 0);
	type func_array is array (0 to 63) of std_logic_vector(32 downto 0);

	constant cw_mem : cw_array := (
									"", -- 000000
									"", -- 000001
									"", -- 000010
									"", -- 000011
									"", -- 000100
									"", -- 000101
									"", -- 000110
									"", -- 000111
									"", -- 001000
									"", -- 001001
									"", -- 001010
									"", -- 001011
									"", -- 001100
									"", -- 001101
									"", -- 001110
									"", -- 001111
									"", -- 010000
									"", -- 010001
									"", -- 010010
									"", -- 010011
									"", -- 010100
									"", -- 010101
									"", -- 010110
									"", -- 010111
									"", -- 011000
									"", -- 011001
									"", -- 011010
									"", -- 011011
									"", -- 011100
									"", -- 011101
									"", -- 011110
									"", -- 011111
									"", -- 100000
									"", -- 100001
									"", -- 100010
									"", -- 100011
									"", -- 100100
									"", -- 100101
									"", -- 100110
									"", -- 100111
									"", -- 101000
									"", -- 101001
									"", -- 101010
									"", -- 101011
									"", -- 101100
									"", -- 101101
									"", -- 101110
									"", -- 101111
									"", -- 110000
									"", -- 110001
									"", -- 110010
									"", -- 110011
									"", -- 110100
									"", -- 110101
									"", -- 110110
									"", -- 110111
									"", -- 111000
									"", -- 111001
									"", -- 111010
									"", -- 111011
									"", -- 111100
									"", -- 111101
									"", -- 111110
									"", -- 111111
		);

	constant func_mem : func_array := (
									"", -- 000000
									"", -- 000001
									"", -- 000010
									"", -- 000011
									"", -- 000100
									"", -- 000101
									"", -- 000110
									"", -- 000111
									"", -- 001000
									"", -- 001001
									"", -- 001010
									"", -- 001011
									"", -- 001100
									"", -- 001101
									"", -- 001110
									"", -- 001111
									"", -- 010000
									"", -- 010001
									"", -- 010010
									"", -- 010011
									"", -- 010100
									"", -- 010101
									"", -- 010110
									"", -- 010111
									"", -- 011000
									"", -- 011001
									"", -- 011010
									"", -- 011011
									"", -- 011100
									"", -- 011101
									"", -- 011110
									"", -- 011111
									"", -- 100000
									"", -- 100001
									"", -- 100010
									"", -- 100011
									"", -- 100100
									"", -- 100101
									"", -- 100110
									"", -- 100111
									"", -- 101000
									"", -- 101001
									"", -- 101010
									"", -- 101011
									"", -- 101100
									"", -- 101101
									"", -- 101110
									"", -- 101111
									"", -- 110000
									"", -- 110001
									"", -- 110010
									"", -- 110011
									"", -- 110100
									"", -- 110101
									"", -- 110110
									"", -- 110111
									"", -- 111000
									"", -- 111001
									"", -- 111010
									"", -- 111011
									"", -- 111100
									"", -- 111101
									"", -- 111110
									"", -- 111111
		);
	
	-- used by the EXE stage to communicate to the IF stage whether it has to use the PC calculated in the EXE stage or not
	-- "00": no PC
	-- "01": main adder PC
	-- "10": secondary adder PC
	signal exe_pc: std_logic_vector(1 downto 0);
	signal curr_id, next_id: std_logic_vector(40 downto 0);
	signal curr_exe, next_exe: std_logic_vector(22 downto 0);
	signal curr_mem, next_mem: std_logic_vector(7 downto 0);
	signal curr_wb, next_wb: std_logic_vector(1 downto 0);
begin

end behavioral;