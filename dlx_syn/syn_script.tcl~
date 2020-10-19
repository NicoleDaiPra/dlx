# Period declaration
set clk_period 1.9
# Analysis of all the components
# Miscellanea
analyze -library WORK -format vhdl {./misc/rshift_reg.vhd ./misc/reg_en.vhd ./misc/priority_encoder_4to2.vhd ./misc/nand4.vhd ./misc/nand3.vhd ./misc/mux_7x1_single_bit.vhd ./misc/mux_7x1.vhd ./misc/mux_6x1.vhd ./misc/mux_4x1.vhd ./misc/mux_32x1.vhd ./misc/mux_2x1.vhd ./misc/equality_comparator.vhd ./misc/encoder_4to2.vhd ./misc/encoder_32x5.vhd ./misc/beh_adder.vhd ./misc/and2.vhd}
# Functions
analyze -library WORK -format vhdl {./fun/fun_pack_adder.vhd ./fun/fun_pack.vhd}
# IF stage
analyze -library WORK -format vhdl {./1_if/btb/btb.vhd ./1_if/if_stage.vhd }
# ID stage
analyze -library WORK -format vhdl {./2_id/sign_extender.vhd ./2_id/rf.vhd ./2_id/id_stage.vhd}
# EXE stage
analyze -library WORK -format vhdl {./3_ex/shifter/stype.vhd ./3_ex/shifter/shifter_t2.vhd ./3_ex/logicals/logicals.vhd ./3_ex/adder/fa.vhd ./3_ex/adder/rca_generic_struct.vhd ./3_ex/adder/pg_unit.vhd ./3_ex/adder/g_unit.vhd ./3_ex/adder/pg_net_block.vhd ./3_ex/adder/pg_network.vhd ./3_ex/adder/carry_generator.vhd ./3_ex/adder/carry_select_block.vhd ./3_ex/adder/sum_generator.vhd ./3_ex/adder/p4_adder.vhd ./3_ex/multiplier/a_generator.vhd ./3_ex/multiplier/booth_encoder.vhd ./3_ex/multiplier/mul.vhd ./3_ex/comparator.vhd ./3_ex/alu_out_selector.vhd ./3_ex/alu.vhd ./3_ex/ex_stage.vhd}
# MEM stage
analyze -library WORK -format vhdl {./4_mem/mem_sign_extender.vhd ./4_mem/mem_stage.vhd}
# WB stage
analyze -library WORK -format vhdl {./5_wb/wb_stage.vhd}
# Control Unit
analyze -library WORK -format vhdl {./cu/opcodes.vhd ./cu/control_words.vhd ./cu/func_words.vhd ./cu/stall_unit.vhd ./cu/cu.vhd ./cu/memory_controller.vhd}
# datapath
analyze -library WORK -format vhdl {./f_id_reg.vhd /home/ms20.9/Desktop/dlx_syn/id_ex_reg.vhd ./ex_mem_reg.vhd ./mem_wb_reg.vhd ./datapath.vhd ./dlx_syn.vhd}
#Elaborate and compile the whole DLX
elaborate DLX_SYN -architecture STRUCTURAL -library DEFAULT
set_max_delay $clk_period -from [all_inputs] -to [all_outputs]
create_clock -name "clk" -period $clk_period clk
compile_ultra
report_timing > ./reports/report_timing.txt
report_area > ./reports/report_area.txt
report_power > ./reports/report_power.txt
write -hierarchy -format verilog -output dlx.v



