library ieee;
use ieee.std_logic_1164.all;

package opcodes is
	subtype reg_t is std_logic_vector(4 downto 0);
	subtype opcode_t is std_logic_vector(5 downto 0);
	subtype func_t is std_logic_vector(10 downto 0);

	-- R type instructions
	constant rtype_opc : opcode_t := "000000"; -- 0x00

	constant nop_func : func_t 		:= "00000000000"; -- 0x000
	constant sll_func : func_t 		:= "00000000000"; -- 0x000
	constant srl_func : func_t 		:= "00000000110"; -- 0x006
	constant sra_func : func_t 		:= "00000000111"; -- 0x007
	constant jr_func : func_t 		:= "00000001000"; -- 0x008 
	constant jalr_func : func_t 	:= "00000001001"; -- 0x009 
	constant mult_func : func_t 	:= "00000001110"; -- 0x00E 
	constant mfhi_func : func_t 	:= "00000010000"; -- 0x010 
	constant mflo_func : func_t 	:= "00000010010"; -- 0x012
	constant add_func : func_t 		:= "00000100000"; -- 0x020
	constant addu_func : func_t 	:= "00000100001"; -- 0x021
	constant sub_func : func_t 		:= "00000100010"; -- 0x022
	constant subu_func : func_t 	:= "00000100011"; -- 0x023
	constant and_func : func_t 		:= "00000100100"; -- 0x024
	constant or_func : func_t 		:= "00000100101"; -- 0x025
	constant xor_func : func_t 		:= "00000100110"; -- 0x026
	constant seq_func : func_t 		:= "00000101000"; -- 0x028
	constant sne_func : func_t 		:= "00000101001"; -- 0x029
	constant slt_func : func_t 		:= "00000101010"; -- 0x02A
	constant sgt_func : func_t 		:= "00000101011"; -- 0x02B
	constant sle_func : func_t 		:= "00000101100"; -- 0x02C
	constant sge_func : func_t 		:= "00000101101"; -- 0x02D
	constant sltu_func : func_t 	:= "00000111010"; -- 0x03A 
	constant sgtu_func : func_t 	:= "00000111011"; -- 0x03B
	constant sleu_func : func_t 	:= "00000111100"; -- 0x03C 
	constant sgeu_func : func_t 	:= "00000111101"; -- 0x03D 

	-- I type instructions
	constant bgez_opc : opcode_t 	:= "000001"; -- 0x01
	constant bltz_opc : opcode_t 	:= "000001"; -- 0x01
	constant beq_opc : opcode_t 	:= "000100"; -- 0x04
	constant bne_opc : opcode_t 	:= "000101"; -- 0x05
	constant blez_opc : opcode_t 	:= "000110"; -- 0x06 
	constant bgtz_opc : opcode_t 	:= "000111"; -- 0x07 
	constant addi_opc : opcode_t 	:= "001000"; -- 0x08
	constant addui_opc : opcode_t 	:= "001001"; -- 0x09 
	constant subi_opc : opcode_t 	:= "001010"; -- 0x0A
	constant subui_opc : opcode_t 	:= "001011"; -- 0x0B 
	constant andi_opc : opcode_t 	:= "001100"; -- 0x0C
	constant ori_opc : opcode_t 	:= "001101"; -- 0x0D
	constant xori_opc : opcode_t 	:= "001110"; -- 0x0E
	constant beqz_opc : opcode_t 	:= "010000"; -- 0x10
	constant bnez_opc : opcode_t 	:= "010001"; -- 0x11
	constant slli_opc : opcode_t 	:= "010100"; -- 0x14 
	constant srli_opc : opcode_t 	:= "010110"; -- 0X16
	constant srai_opc : opcode_t 	:= "010111"; -- 0x17
	constant seqi_opc : opcode_t 	:= "011000"; -- 0x18
	constant snei_opc : opcode_t 	:= "011001"; -- 0x19
	constant slti_opc : opcode_t 	:= "011010"; -- 0x1A
	constant sgti_opc : opcode_t 	:= "011011"; -- 0x1B
	constant slei_opc : opcode_t 	:= "011100"; -- 0x1C
	constant sgei_opc : opcode_t 	:= "011101"; -- 0x1D  
	constant lb_opc : opcode_t 		:= "100000"; -- 0x20 
	constant lh_opc : opcode_t 		:= "010001"; -- 0x21 
	constant lw_opc : opcode_t 		:= "100011"; -- 0x23
	constant lbu_opc : opcode_t 	:= "100100"; -- 0x24
	constant lhu_opc : opcode_t 	:= "100101"; -- 0x25
	constant sb_opc : opcode_t 		:= "101000"; -- 0x28
	constant sh_opc : opcode_t 		:= "101001"; -- 0x29
	constant sw_opc : opcode_t 		:= "101011"; -- 0x2B
	constant sltui_opc : opcode_t 	:= "111010"; -- 0x3A 
	constant sgtui_opc : opcode_t 	:= "111011"; -- 0x3B
	constant sleui_opc : opcode_t 	:= "111100"; -- 0x3C 
	constant sgeui_opc : opcode_t 	:= "111101"; -- 0x3D

	-- BXXX "rt" format
	constant bltz_reg : reg_t 		:= "00000";
	constant bgez_reg : reg_t 		:= "00001";  

	-- J type instructions
	constant j_opc : opcode_t 		:= "000010"; -- 0x02
	constant jal_opc : opcode_t 	:= "000011"; -- 0x03
end package opcodes;