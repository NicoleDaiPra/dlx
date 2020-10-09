library ieee;
use ieee.std_logic_1164.all;

package control_words is
	subtype cw_t is std_logic_vector(57 downto 0);
								   --  ID		   ID/EXE     EXE                  E/M  MEM     M/W WB
	constant rtype_cw 		: cw_t := "0000000000000000000000000000000000001100011000000000000000"; -- because the signals are determined using the func field
	constant bgez_bltz_cw 	: cw_t := "1000001111010000001101000000000010001101000000000000000000";
	constant j_cw 			: cw_t := "0100001011000000001100000000000011101101000000000000000000";
	constant jal_cw 		: cw_t := "0100111001010000011100000000000011101101011000000000101100";
	constant beq_cw 		: cw_t := "1000001111010000001101000000000011001101000000000000000000";
	constant bne_cw 		: cw_t := "1000001111010000001101000000000011011101000000000000000000";
	constant blez_cw 		: cw_t := "1000001111010000001101000000000010001101000000000000000000";
	constant bgtz_cw 		: cw_t := "1000001111010000001101000000000010111101000000000000000000";
	constant addi_cw 		: cw_t := "1000001110010000010000000000000011111100011000000000101100";
	constant addui_cw 		: cw_t := "1000000110010000010000000000000001111100011000000000101100";
	constant subi_cw 		: cw_t := "1000001110010000010001000000000011111100011000000000101100";
	constant subui_cw 		: cw_t := "1000000110010000010001000000000001111100011000000000101100";
	constant andi_cw 		: cw_t := "1000000110010000010000000010001101111100011000000000101100";
	constant ori_cw 		: cw_t := "1000000110010000010000000011101101111100011000000000101100";
	constant xori_cw 		: cw_t := "1000000110010000010000000001101101111100011000000000101100";
	constant beqz_cw 		: cw_t := "1000001111010000001101000000000011001101000000000000000000";
	constant bnez_cw 		: cw_t := "1000001111010000001101000000000011011101000000000000000000";
	constant slli_cw 		: cw_t := "1000000110000100010000001100001001111100011000000000101100";
	constant srli_cw 		: cw_t := "1000000110000100010000001000001001111100011000000000101100";
	constant srai_cw 		: cw_t := "1000000110000100010000010000001001111100011000000000101100";
	constant seqi_cw 		: cw_t := "1000001110010000010001000000000011111000011000000000101100";
	constant snei_cw 		: cw_t := "1000001110010000010001000000000011111010011000000000101100";
	constant slti_cw 		: cw_t := "1000001110010000010001000000000011110010011000000000101100";
	constant sgti_cw 		: cw_t := "1000001110010000010001000000000011110110011000000000101100";
	constant slei_cw 		: cw_t := "1000001110010000010001000000000011110000011000000000101100";
	constant sgei_cw 		: cw_t := "1000001110010000010001000000000011110100011000000000101100";
	constant lb_cw			: cw_t := "1000001110010000010000000000000011111100011000001100011110";
	constant lh_cw	 		: cw_t := "1000001110010000010000000000000011111100011000001010011110";
	constant lw_cw	 		: cw_t := "1000001110010000010000000000000011111100011000001000011110";
	constant lbu_cw 		: cw_t := "1000001110010000010000000000000011111100011000000100011110";
	constant lhu_cw 		: cw_t := "1000001110010000010000000000000011111100011000000010011110";
	constant sb_cw 			: cw_t := "1000001110010000000010000000000011111100011011110001000000";
	constant sh_cw 			: cw_t := "1000001110010000000010000000000011111100011011100001000000";
	constant sw_cw	 		: cw_t := "1000001110010000000010000000000011111100011011010001000000";
	constant sltui_cw 		: cw_t := "1000001110010000010001000000000001110010011000000000101100";
	constant sgtui_cw 		: cw_t := "1000001110010000010001000000000001110110011000000000101100";
	constant sleui_cw 		: cw_t := "1000001110010000010001000000000001110000011000000000101100";
	constant sgeui_cw 		: cw_t := "1000001110010000010001000000000001110100011000000000101100";
end package control_words;