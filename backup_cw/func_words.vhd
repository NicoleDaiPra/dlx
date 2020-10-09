library ieee;
use ieee.std_logic_1164.all;

package func_words is
	subtype fw_t is std_logic_vector(57 downto 0);
							   --  ID	        ID/EXE     EXE                  E/M  MEM     M/W WB
	constant nop_func 	: fw_t	:= "00000001110 0010001000 00011000010011111000 1100 0000000 101 100";
	constant sll_func 	: fw_t 	:= "00000001110 0010001000 00011000010011111000 1100 0000000 101 100";
	constant srl_func 	: fw_t 	:= "00000001110 0010001000 00010000010011111000 1100 0000000 101 100";
	constant sra_func 	: fw_t 	:= "00000001110 0010001000 00100000010011111000 1100 0000000 101 100";
	constant jr_func 	: fw_t 	:= "01001101110 1000000000 00000000000011011001 0000 0000000 000 000";
	constant jalr_func	: fw_t 	:= "01001101111 1000001001 00000000000011011001 1101 0000001 101 100";
	constant mult_func 	: fw_t 	:= "00000001110 0100010000 00000000001011111000 1000 0000000 100 001";
	constant mfhi_func 	: fw_t 	:= "00100001110 1000001000 00000000000011111000 1100 0000000 101 100";
	constant mflo_func 	: fw_t 	:= "00010001110 1000001000 00000000000011111000 1100 0000000 101 100";
	constant add_func 	: fw_t 	:= "00000001110 1000001000 00000000000111111000 1100 0000000 101 100";
	constant addu_func 	: fw_t 	:= "00000001110 1000001000 00000000000011111000 1100 0000000 101 100";
	constant sub_func 	: fw_t 	:= "00000001110 1000001000 10000000000111111000 1100 0000000 101 100";
	constant subu_func 	: fw_t 	:= "00000001110 1000001000 10000000000011111000 1100 0000000 101 100";
	constant and_func 	: fw_t 	:= "00000001110 1000001000 00000100011011111000 1100 0000000 101 100";
	constant or_func 	: fw_t 	:= "00000001110 1000001000 00000111011011111000 1100 0000000 101 100";
	constant xor_func 	: fw_t 	:= "00000001110 1000001000 00000011011011111000 1100 0000000 101 100";
	constant seq_func 	: fw_t 	:= "00000001110 1000001000 10000000000111110000 1100 0000000 101 100";
	constant sne_func 	: fw_t 	:= "00000001110 1000001000 10000000000111110100 1100 0000000 101 100";
	constant slt_func 	: fw_t 	:= "00000001110 1000001000 10000000000111100100 1100 0000000 101 100";
	constant sgt_func 	: fw_t 	:= "00000001110 1000001000 10000000000111101100 1100 0000000 101 100";
	constant sle_func 	: fw_t 	:= "00000001110 1000001000 10000000000111100000 1100 0000000 101 100";
	constant sge_func 	: fw_t 	:= "00000001110 1000001000 10000000000111101000 1100 0000000 101 100";
	constant sltu_func 	: fw_t 	:= "00000001110 1000001000 10000000000011100100 1100 0000000 101 100";
	constant sgtu_func 	: fw_t 	:= "00000001110 1000001000 10000000000011101100 1100 0000000 101 100";
	constant sleu_func 	: fw_t 	:= "00000001110 1000001000 10000000000011100000 1100 0000000 101 100";
	constant sgeu_func 	: fw_t 	:= "00000001110 1000001000 10000000000011101000 1100 0000000 101 100";
end package func_words;