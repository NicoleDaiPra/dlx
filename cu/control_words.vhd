library ieee;
use ieee.std_logic_1164.all;

package control_words is
	subtype cw_t is std_logic_vector(54 downto 0);

	constant nop_cw 		: cw_t := "00000001110001000100000011000010000011011000000000101100";
	constant rtype_cw 		: cw_t := "00000000000000000000000000000000000011011000000000000000"; -- it does nothing because the signals are determined using the func field
	constant bgez_bltz_cw 	: cw_t := "10000011110100000011010000000000100011000000000000000000";
	constant j_cw 			: cw_t := "01000010110000000011000000000000111011000000000000000000";
	constant jal_cw 		: cw_t := "01001110010100000111000000000000111011011000000000101100";
	constant beq_cw 		: cw_t := "10000011110100000011010000000000110011000000000000000000";
	constant bne_cw 		: cw_t := "10000011110100000011010000000000110111000000000000000000";
	constant blez_cw 		: cw_t := "10000011110100000011010000000000100011000000000000000000";
	constant bgtz_cw 		: cw_t := "10000011110100000011010000000000101111000000000000000000";
	constant addi_cw 		: cw_t := "10000011100100000100000000000000100011011000000000101100";
	constant addui_cw 		: cw_t := "10000001100100000100000000000000000011011000000000101100";
	constant subi_cw 		: cw_t := "10000011100100000100010000000000100011011000000000101100";
	constant subui_cw 		: cw_t := "10000001100100000100010000000000000011011000000000101100";
	constant andi_cw 		: cw_t := "10000001100100000100000000100011000011011000000000101100";
	constant ori_cw 		: cw_t := "10000001100100000100000000111011000011011000000000101100";
	constant xori_cw 		: cw_t := "10000001100100000100000000011011000011011000000000101100";
	constant beqz_cw 		: cw_t := "10000011110100000011010000000000110011000000000000000000";
	constant bnez_cw 		: cw_t := "10000011110100000011010000000000110111000000000000000000";
	constant slli_cw 		: cw_t := "10000001100001000100000011000010000011011000000000101100";
	constant srli_cw 		: cw_t := "10000001100001000100000010000010000011011000000000101100";
	constant srai_cw 		: cw_t := "10000001100001000100000100000010000011011000000000101100";
	constant seqi_cw 		: cw_t := "10000011100100000100010000000000100010011000000000101100";
	constant snei_cw 		: cw_t := "10000011100100000100010000000000100010111000000000101100";
	constant slti_cw 		: cw_t := "10000011100100000100010000000000100000111000000000101100";
	constant sgti_cw 		: cw_t := "10000011100100000100010000000000100001111000000000101100";
	constant slei_cw 		: cw_t := "10000011100100000100010000000000100000011000000000101100";
	constant sgei_cw 		: cw_t := "10000011100100000100010000000000100001011000000000101100";
	constant lb_cw			: cw_t := "10000011100100000100000000000000100011011000001100011110";
	constant lh_cw	 		: cw_t := "10000011100100000100000000000000100011011000001010011110";
	constant lw_cw	 		: cw_t := "10000011100100000100000000000000100011011000001000011110";
	constant lbu_cw 		: cw_t := "10000011100100000100000000000000100011011000000100011110";
	constant lhu_cw 		: cw_t := "10000011100100000100000000000000100011011000000010011110";
	constant sb_cw 			: cw_t := "10000011100100000000100000000000100011011011110001000000";
	constant sh_cw 			: cw_t := "10000011100100000000100000000000100011011011100001000000";
	constant sw_cw	 		: cw_t := "10000011100100000000100000000000100011011011010001000000";
	constant sltui_cw 		: cw_t := "10000011100100000100010000000000000000111000000000101100";
	constant sgtui_cw 		: cw_t := "10000011100100000100010000000000000001111000000000101100";
	constant sleui_cw 		: cw_t := "10000011100100000100010000000000000000011000000000101100";
	constant sgeui_cw 		: cw_t := "10000011100100000100010000000000000001011000000000101100";
end package control_words;