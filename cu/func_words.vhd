library ieee;
use ieee.std_logic_1164.all;

package func_words is
	subtype fw_t is std_logic_vector(52 downto 0);
								    --  ID	   ID/EXE     EXE                E/M  MEM    M/W WB
	constant nop_func 	: fw_t	:= "0000000111 0010001000 000110000100000110 1100 000000 101 10";
	constant sll_func 	: fw_t 	:= "0000000111 0010001000 000110000100000110 1100 000000 101 10";
	constant srl_func 	: fw_t 	:= "0000000111 0010001000 000100000100000110 1100 000000 101 10";
	constant sra_func 	: fw_t 	:= "0000000111 0010001000 001000000100000110 1100 000000 101 10";
	constant jr_func 	: fw_t 	:= "0000110111 1000001000 000000000000000110 0000 000000 000 00";
	constant jalr_func	: fw_t 	:= 
	constant mult_func 	: fw_t 	:= 
	constant mfhi_func 	: fw_t 	:=  
	constant mflo_func 	: fw_t 	:= 
	constant add_func 	: fw_t 	:= 
	constant addu_func 	: fw_t 	:= 
	constant sub_func 	: fw_t 	:= 
	constant subu_func 	: fw_t 	:= 
	constant and_func 	: fw_t 	:= 
	constant or_func 	: fw_t 	:= 
	constant xor_func 	: fw_t 	:= 
	constant seq_func 	: fw_t 	:= 
	constant sne_func 	: fw_t 	:= 
	constant slt_func 	: fw_t 	:= 
	constant sgt_func 	: fw_t 	:= 
	constant sle_func 	: fw_t 	:= 
	constant sge_func 	: fw_t 	:= 
	constant sltu_func 	: fw_t 	:=
	constant sgtu_func 	: fw_t 	:= 
	constant sleu_func 	: fw_t 	:=  
	constant sgeu_func 	: fw_t 	:= 
end package func_words;