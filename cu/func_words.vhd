library ieee;
use ieee.std_logic_1164.all;

package func_words is
	subtype fw_t is std_logic_vector(54 downto 0);

	constant nop_func 	: fw_t	:= "00000001110001000100000011000010000011011000000000101100";
	constant sll_func 	: fw_t 	:= "00000001110001000100000011000010000011011000000000101100";
	constant srl_func 	: fw_t 	:= "00000001110001000100000010000010000011011000000000101100";
	constant sra_func 	: fw_t 	:= "00000001110001000100000100000010000011011000000000101100";
	constant jr_func 	: fw_t 	:= "01001101110100000000000000000000000011000000000000000000";
	constant jalr_func	: fw_t 	:= "01001101111100000100100000000000000011011010000001101100";
	constant mult_func 	: fw_t 	:= "00000001110010001000000000000001000011010000000000100001";
	constant mfhi_func 	: fw_t 	:= "00100001110100000100000000000000000011011000000000101100";
	constant mflo_func 	: fw_t 	:= "00010001110100000100000000000000000011011000000000101100";
	constant add_func 	: fw_t 	:= "00000001110100000100000000000000100011011000000000101100";
	constant addu_func 	: fw_t 	:= "00000001110100000100000000000000000011011000000000101100";
	constant sub_func 	: fw_t 	:= "00000001110100000100010000000000100011011000000000101100";
	constant subu_func 	: fw_t 	:= "00000001110100000100010000000000000011011000000000101100";
	constant and_func 	: fw_t 	:= "00000001110100000100000000100011000011011000000000101100";
	constant or_func 	: fw_t 	:= "00000001110100000100000000111011000011011000000000101100";
	constant xor_func 	: fw_t 	:= "00000001110100000100000000011011000011011000000000101100";
	constant seq_func 	: fw_t 	:= "00000001110100000100010000000000100010011000000000101100";
	constant sne_func 	: fw_t 	:= "00000001110100000100010000000000100010111000000000101100";
	constant slt_func 	: fw_t 	:= "00000001110100000100010000000000100000111000000000101100";
	constant sgt_func 	: fw_t 	:= "00000001110100000100010000000000100001111000000000101100";
	constant sle_func 	: fw_t 	:= "00000001110100000100010000000000100000011000000000101100";
	constant sge_func 	: fw_t 	:= "00000001110100000100010000000000100001011000000000101100";
	constant sltu_func 	: fw_t 	:= "00000001110100000100010000000000000000111000000000101100";
	constant sgtu_func 	: fw_t 	:= "00000001110100000100010000000000000001111000000000101100";
	constant sleu_func 	: fw_t 	:= "00000001110100000100010000000000000000011000000000101100";
	constant sgeu_func 	: fw_t 	:= "00000001110100000100010000000000000001011000000000101100";
end package func_words;