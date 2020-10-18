#compile miscellanea logic such as muxes,...
vcom -reportprogress 300 -work work misc/*
#compile functions
vcom -reportprogress 300 -work work fun/*
#compile IF stage
vcom -reportprogress 300 -work work 1_if/btb/*
vcom -reportprogress 300 -work work 1_if/*
#compile ID stage
vcom -reportprogress 300 -work work 2_id/*
#compile EX stage
vcom -reportprogress 300 -work work 3_ex/adder/*
vcom -reportprogress 300 -work work 3_ex/logicals/*
vcom -reportprogress 300 -work work 3_ex/multiplier/*
vcom -reportprogress 300 -work work 3_ex/shifter/stype.vhd
vcom -reportprogress 300 -work work 3_ex/shifter/shifter_t2.vhd
vcom -reportprogress 300 -work work 3_ex/*
#compile MEM stage
vcom -reportprogress 300 -work work 4_mem/*
#compile WB stage
vcom -reportprogress 300 -work work 5_wb/*
#compile the control unit
vcom -reportprogress 300 -work work cu/opcodes.vhd
vcom -reportprogress 300 -work work cu/control_words.vhd
vcom -reportprogress 300 -work work cu/func_words.vhd
vcom -reportprogress 300 -work work cu/stall_unit.vhd
vcom -reportprogress 300 -work work cu/cu.vhd
vcom -reportprogress 300 -work work cu/memory_controller.vhd
#compile the pipeline's register
vcom -reportprogress 300 -work work f_id_reg.vhd
vcom -reportprogress 300 -work work id_ex_reg.vhd
vcom -reportprogress 300 -work work ex_mem_reg.vhd
vcom -reportprogress 300 -work work mem_wb_reg.vhd
#compile the entity that contain the whole datapath
vcom -reportprogress 300 -work work datapath.vhd
#compile the synthesizable part of the dlx
vcom -reportprogress 300 -work work dlx_syn.vhd
#compile the whole dlx with also the memories in order to simulate everything
vcom -reportprogress 300 -work work dlx_sim.vhd
#based on the test you want to perform remove the comment to the required lines

#test rithmetic instructions
#vcom -reportprogress 300 -work work tb/tb_arith.vhd
#vsim -t 100ps -novopt work.tb_arith(test)

#test generic instructions
#vcom -reportprogress 300 -work work tb/tb_r.vhd
#vsim -t 100ps -novopt work.tb_r(test)

#test branches
#vcom -reportprogress 300 -work work tb/tb_branches.vhd
#vsim -t 100ps -novopt work.tb_branches(test)

#test multiplications
#vcom -reportprogress 300 -work work tb/tb_mult.vhd
#vsim -t 100ps -novopt work.tb_mult(test)

#test load and store instructions
#vcom -reportprogress 300 -work work tb/tb_load_store.vhd
#vsim -t 100ps -novopt work.tb_load_store(test)

#test jumps
#vcom -reportprogress 300 -work work tb/tb_jump_and_link.vhd
#vsim -t 100ps -novopt work.tb_jump_and_link(test)

#test jalr
vcom -reportprogress 300 -work work tb/tb_jalr.vhd
vsim -t 100ps -novopt work.tb_jalr(test)
add wave *
run 100 ns
