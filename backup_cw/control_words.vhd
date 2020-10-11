library ieee;
use ieee.std_logic_1164.all;

-- add id_fw_type in ID, rd_valid for exmem and memwb
package control_words is
	subtype cw_t is std_logic_vector(62 downto 0);
								   --  ID		   ID/EXE       EXE                E/M     MEM      M/W  WB
	constant rtype_cw 		: cw_t := "00000000000 000000000010 000000000000000110 0011001 00000000 0001 000"; -- because the signals are determined using the func field
	constant bgez_bltz_cw 	: cw_t := "10000011110 100000011001 100000000001000110 1000000 00000000 0000 000";
	constant j_cw 			: cw_t := "01000010110 000000011000 000000000001110110 1000000 00000000 0000 000";
	constant jal_cw 		: cw_t := "01001110010 100000111000 000000000001110110 1011001 00000000 1011 100";
	constant beq_cw 		: cw_t := "10000011110 100000011010 100000000001100110 1000000 00000000 0000 000";
	constant bne_cw 		: cw_t := "10000011110 100000011010 100000000001101110 1000000 00000000 0000 000";
	constant blez_cw 		: cw_t := "10000011110 100000011001 100000000001000110 1000000 00000000 0000 000";
	constant bgtz_cw 		: cw_t := "10000011110 100000011001 100000000001011110 1000000 00000000 0000 000";
	constant addi_cw 		: cw_t := "10000011100 100000100001 000000000001111110 0011001 00000000 1011 100";
	constant addui_cw 		: cw_t := "10000001100 100000100001 000000000000111110 0011001 00000000 1011 100";
	constant subi_cw 		: cw_t := "10000011100 100000100001 100000000001111110 0011001 00000000 1011 100";
	constant subui_cw 		: cw_t := "10000001100 100000100001 100000000000111110 0011001 00000000 1011 100";
	constant andi_cw 		: cw_t := "10000001100 100000100001 000001000110111110 0011001 00000000 1011 100";
	constant ori_cw 		: cw_t := "10000001100 100000100001 000001110110111110 0011001 00000000 1011 100";
	constant xori_cw 		: cw_t := "10000001100 100000100001 000000110110111110 0011001 00000000 1011 100";
	constant beqz_cw 		: cw_t := "10000011110 100000011001 100000000001100110 1000000 00000000 0000 000";
	constant bnez_cw 		: cw_t := "10000011110 100000011001 100000000001101110 1000000 00000000 0000 000";
	constant slli_cw 		: cw_t := "10000001100 001000100001 000110000100111110 0011001 00000000 1011 100";
	constant srli_cw 		: cw_t := "10000001100 001000100001 000100000100111110 0011001 00000000 1011 100";
	constant srai_cw 		: cw_t := "10000001100 001000100001 001000000100111110 0011001 00000000 1011 100";
	constant seqi_cw 		: cw_t := "10000011100 100000100001 100000000001100100 0011001 00000000 1011 100";
	constant snei_cw 		: cw_t := "10000011100 100000100001 100000000001101101 0011001 00000000 1011 100";
	constant slti_cw 		: cw_t := "10000011100 100000100001 100000000001001001 0011001 00000000 1011 100";
	constant sgti_cw 		: cw_t := "10000011100 100000100001 100000000001011011 0011001 00000000 1011 100";
	constant slei_cw 		: cw_t := "10000011100 100000100001 100000000001000000 0011001 00000000 1011 100";
	constant sgei_cw 		: cw_t := "10000011100 100000100001 100000000001010010 0011001 00000000 1011 100";
	constant lb_cw			: cw_t := "10000011100 100000100001 000000000001111110 0011001 10001100 0111 110";
	constant lh_cw	 		: cw_t := "10000011100 100000100001 000000000001111110 0011001 10001010 0111 110";
	constant lw_cw	 		: cw_t := "10000011100 100000100001 000000000001111110 0011001 10001000 0111 110";
	constant lbu_cw 		: cw_t := "10000011100 100000100001 000000000001111110 0011001 10000100 0111 110";
	constant lhu_cw 		: cw_t := "10000011100 100000100001 000000000001111110 0011001 10000010 0111 110";
	constant sb_cw 			: cw_t := "10000011100 100000000110 000000000001111110 0011010 01110001 0000 000";
	constant sh_cw 			: cw_t := "10000011100 100000000110 000000000001111110 0011010 01100001 0000 000";
	constant sw_cw	 		: cw_t := "10000011100 100000000110 000000000001111110 0011010 01010001 0000 000";
	constant sltui_cw 		: cw_t := "10000011100 100000100001 100000000000001001 0011001 00000000 1011 100";
	constant sgtui_cw 		: cw_t := "10000011100 100000100001 100000000000011011 0011001 00000000 1011 100";
	constant sleui_cw 		: cw_t := "10000011100 100000100001 100000000000000000 0011001 00000000 1011 100";
	constant sgeui_cw 		: cw_t := "10000011100 100000100001 100000000000010010 0011001 00000000 1011 100";
end package control_words;