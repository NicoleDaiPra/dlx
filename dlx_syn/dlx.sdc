###################################################################

# Created by write_sdc on Mon Oct 19 17:41:39 2020

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports clk]  -period 1.9  -waveform {0 0.95}
set_max_delay 1.9  -from [list [get_ports clk] [get_ports rst] [get_ports btb_cache_hit_read]    \
[get_ports btb_cache_hit_rw] [get_ports {btb_cache_data_out_read[31]}]         \
[get_ports {btb_cache_data_out_read[30]}] [get_ports                           \
{btb_cache_data_out_read[29]}] [get_ports {btb_cache_data_out_read[28]}]       \
[get_ports {btb_cache_data_out_read[27]}] [get_ports                           \
{btb_cache_data_out_read[26]}] [get_ports {btb_cache_data_out_read[25]}]       \
[get_ports {btb_cache_data_out_read[24]}] [get_ports                           \
{btb_cache_data_out_read[23]}] [get_ports {btb_cache_data_out_read[22]}]       \
[get_ports {btb_cache_data_out_read[21]}] [get_ports                           \
{btb_cache_data_out_read[20]}] [get_ports {btb_cache_data_out_read[19]}]       \
[get_ports {btb_cache_data_out_read[18]}] [get_ports                           \
{btb_cache_data_out_read[17]}] [get_ports {btb_cache_data_out_read[16]}]       \
[get_ports {btb_cache_data_out_read[15]}] [get_ports                           \
{btb_cache_data_out_read[14]}] [get_ports {btb_cache_data_out_read[13]}]       \
[get_ports {btb_cache_data_out_read[12]}] [get_ports                           \
{btb_cache_data_out_read[11]}] [get_ports {btb_cache_data_out_read[10]}]       \
[get_ports {btb_cache_data_out_read[9]}] [get_ports                            \
{btb_cache_data_out_read[8]}] [get_ports {btb_cache_data_out_read[7]}]         \
[get_ports {btb_cache_data_out_read[6]}] [get_ports                            \
{btb_cache_data_out_read[5]}] [get_ports {btb_cache_data_out_read[4]}]         \
[get_ports {btb_cache_data_out_read[3]}] [get_ports                            \
{btb_cache_data_out_read[2]}] [get_ports {btb_cache_data_out_read[1]}]         \
[get_ports {btb_cache_data_out_read[0]}] [get_ports                            \
{btb_cache_data_out_rw[31]}] [get_ports {btb_cache_data_out_rw[30]}]           \
[get_ports {btb_cache_data_out_rw[29]}] [get_ports                             \
{btb_cache_data_out_rw[28]}] [get_ports {btb_cache_data_out_rw[27]}]           \
[get_ports {btb_cache_data_out_rw[26]}] [get_ports                             \
{btb_cache_data_out_rw[25]}] [get_ports {btb_cache_data_out_rw[24]}]           \
[get_ports {btb_cache_data_out_rw[23]}] [get_ports                             \
{btb_cache_data_out_rw[22]}] [get_ports {btb_cache_data_out_rw[21]}]           \
[get_ports {btb_cache_data_out_rw[20]}] [get_ports                             \
{btb_cache_data_out_rw[19]}] [get_ports {btb_cache_data_out_rw[18]}]           \
[get_ports {btb_cache_data_out_rw[17]}] [get_ports                             \
{btb_cache_data_out_rw[16]}] [get_ports {btb_cache_data_out_rw[15]}]           \
[get_ports {btb_cache_data_out_rw[14]}] [get_ports                             \
{btb_cache_data_out_rw[13]}] [get_ports {btb_cache_data_out_rw[12]}]           \
[get_ports {btb_cache_data_out_rw[11]}] [get_ports                             \
{btb_cache_data_out_rw[10]}] [get_ports {btb_cache_data_out_rw[9]}] [get_ports \
{btb_cache_data_out_rw[8]}] [get_ports {btb_cache_data_out_rw[7]}] [get_ports  \
{btb_cache_data_out_rw[6]}] [get_ports {btb_cache_data_out_rw[5]}] [get_ports  \
{btb_cache_data_out_rw[4]}] [get_ports {btb_cache_data_out_rw[3]}] [get_ports  \
{btb_cache_data_out_rw[2]}] [get_ports {btb_cache_data_out_rw[1]}] [get_ports  \
{btb_cache_data_out_rw[0]}] [get_ports {instr_if[31]}] [get_ports              \
{instr_if[30]}] [get_ports {instr_if[29]}] [get_ports {instr_if[28]}]          \
[get_ports {instr_if[27]}] [get_ports {instr_if[26]}] [get_ports               \
{instr_if[25]}] [get_ports {instr_if[24]}] [get_ports {instr_if[23]}]          \
[get_ports {instr_if[22]}] [get_ports {instr_if[21]}] [get_ports               \
{instr_if[20]}] [get_ports {instr_if[19]}] [get_ports {instr_if[18]}]          \
[get_ports {instr_if[17]}] [get_ports {instr_if[16]}] [get_ports               \
{instr_if[15]}] [get_ports {instr_if[14]}] [get_ports {instr_if[13]}]          \
[get_ports {instr_if[12]}] [get_ports {instr_if[11]}] [get_ports               \
{instr_if[10]}] [get_ports {instr_if[9]}] [get_ports {instr_if[8]}] [get_ports \
{instr_if[7]}] [get_ports {instr_if[6]}] [get_ports {instr_if[5]}] [get_ports  \
{instr_if[4]}] [get_ports {instr_if[3]}] [get_ports {instr_if[2]}] [get_ports  \
{instr_if[1]}] [get_ports {instr_if[0]}] [get_ports dcache_hit] [get_ports     \
{dcache_data_in[31]}] [get_ports {dcache_data_in[30]}] [get_ports              \
{dcache_data_in[29]}] [get_ports {dcache_data_in[28]}] [get_ports              \
{dcache_data_in[27]}] [get_ports {dcache_data_in[26]}] [get_ports              \
{dcache_data_in[25]}] [get_ports {dcache_data_in[24]}] [get_ports              \
{dcache_data_in[23]}] [get_ports {dcache_data_in[22]}] [get_ports              \
{dcache_data_in[21]}] [get_ports {dcache_data_in[20]}] [get_ports              \
{dcache_data_in[19]}] [get_ports {dcache_data_in[18]}] [get_ports              \
{dcache_data_in[17]}] [get_ports {dcache_data_in[16]}] [get_ports              \
{dcache_data_in[15]}] [get_ports {dcache_data_in[14]}] [get_ports              \
{dcache_data_in[13]}] [get_ports {dcache_data_in[12]}] [get_ports              \
{dcache_data_in[11]}] [get_ports {dcache_data_in[10]}] [get_ports              \
{dcache_data_in[9]}] [get_ports {dcache_data_in[8]}] [get_ports                \
{dcache_data_in[7]}] [get_ports {dcache_data_in[6]}] [get_ports                \
{dcache_data_in[5]}] [get_ports {dcache_data_in[4]}] [get_ports                \
{dcache_data_in[3]}] [get_ports {dcache_data_in[2]}] [get_ports                \
{dcache_data_in[1]}] [get_ports {dcache_data_in[0]}] [get_ports ram_update]    \
[get_ports {cache_to_ram_data[31]}] [get_ports {cache_to_ram_data[30]}]        \
[get_ports {cache_to_ram_data[29]}] [get_ports {cache_to_ram_data[28]}]        \
[get_ports {cache_to_ram_data[27]}] [get_ports {cache_to_ram_data[26]}]        \
[get_ports {cache_to_ram_data[25]}] [get_ports {cache_to_ram_data[24]}]        \
[get_ports {cache_to_ram_data[23]}] [get_ports {cache_to_ram_data[22]}]        \
[get_ports {cache_to_ram_data[21]}] [get_ports {cache_to_ram_data[20]}]        \
[get_ports {cache_to_ram_data[19]}] [get_ports {cache_to_ram_data[18]}]        \
[get_ports {cache_to_ram_data[17]}] [get_ports {cache_to_ram_data[16]}]        \
[get_ports {cache_to_ram_data[15]}] [get_ports {cache_to_ram_data[14]}]        \
[get_ports {cache_to_ram_data[13]}] [get_ports {cache_to_ram_data[12]}]        \
[get_ports {cache_to_ram_data[11]}] [get_ports {cache_to_ram_data[10]}]        \
[get_ports {cache_to_ram_data[9]}] [get_ports {cache_to_ram_data[8]}]          \
[get_ports {cache_to_ram_data[7]}] [get_ports {cache_to_ram_data[6]}]          \
[get_ports {cache_to_ram_data[5]}] [get_ports {cache_to_ram_data[4]}]          \
[get_ports {cache_to_ram_data[3]}] [get_ports {cache_to_ram_data[2]}]          \
[get_ports {cache_to_ram_data[1]}] [get_ports {cache_to_ram_data[0]}]          \
[get_ports {cpu_cache_address[31]}] [get_ports {cpu_cache_address[30]}]        \
[get_ports {cpu_cache_address[29]}] [get_ports {cpu_cache_address[28]}]        \
[get_ports {cpu_cache_address[27]}] [get_ports {cpu_cache_address[26]}]        \
[get_ports {cpu_cache_address[25]}] [get_ports {cpu_cache_address[24]}]        \
[get_ports {cpu_cache_address[23]}] [get_ports {cpu_cache_address[22]}]        \
[get_ports {cpu_cache_address[21]}] [get_ports {cpu_cache_address[20]}]        \
[get_ports {cpu_cache_address[19]}] [get_ports {cpu_cache_address[18]}]        \
[get_ports {cpu_cache_address[17]}] [get_ports {cpu_cache_address[16]}]        \
[get_ports {cpu_cache_address[15]}] [get_ports {cpu_cache_address[14]}]        \
[get_ports {cpu_cache_address[13]}] [get_ports {cpu_cache_address[12]}]        \
[get_ports {cpu_cache_address[11]}] [get_ports {cpu_cache_address[10]}]        \
[get_ports {cpu_cache_address[9]}] [get_ports {cpu_cache_address[8]}]          \
[get_ports {cpu_cache_address[7]}] [get_ports {cpu_cache_address[6]}]          \
[get_ports {cpu_cache_address[5]}] [get_ports {cpu_cache_address[4]}]          \
[get_ports {cpu_cache_address[3]}] [get_ports {cpu_cache_address[2]}]          \
[get_ports {cpu_cache_address[1]}] [get_ports {cpu_cache_address[0]}]          \
[get_ports {evicted_cache_address[31]}] [get_ports                             \
{evicted_cache_address[30]}] [get_ports {evicted_cache_address[29]}]           \
[get_ports {evicted_cache_address[28]}] [get_ports                             \
{evicted_cache_address[27]}] [get_ports {evicted_cache_address[26]}]           \
[get_ports {evicted_cache_address[25]}] [get_ports                             \
{evicted_cache_address[24]}] [get_ports {evicted_cache_address[23]}]           \
[get_ports {evicted_cache_address[22]}] [get_ports                             \
{evicted_cache_address[21]}] [get_ports {evicted_cache_address[20]}]           \
[get_ports {evicted_cache_address[19]}] [get_ports                             \
{evicted_cache_address[18]}] [get_ports {evicted_cache_address[17]}]           \
[get_ports {evicted_cache_address[16]}] [get_ports                             \
{evicted_cache_address[15]}] [get_ports {evicted_cache_address[14]}]           \
[get_ports {evicted_cache_address[13]}] [get_ports                             \
{evicted_cache_address[12]}] [get_ports {evicted_cache_address[11]}]           \
[get_ports {evicted_cache_address[10]}] [get_ports {evicted_cache_address[9]}] \
[get_ports {evicted_cache_address[8]}] [get_ports {evicted_cache_address[7]}]  \
[get_ports {evicted_cache_address[6]}] [get_ports {evicted_cache_address[5]}]  \
[get_ports {evicted_cache_address[4]}] [get_ports {evicted_cache_address[3]}]  \
[get_ports {evicted_cache_address[2]}] [get_ports {evicted_cache_address[1]}]  \
[get_ports {evicted_cache_address[0]}] [get_ports {ram_data_out[31]}]          \
[get_ports {ram_data_out[30]}] [get_ports {ram_data_out[29]}] [get_ports       \
{ram_data_out[28]}] [get_ports {ram_data_out[27]}] [get_ports                  \
{ram_data_out[26]}] [get_ports {ram_data_out[25]}] [get_ports                  \
{ram_data_out[24]}] [get_ports {ram_data_out[23]}] [get_ports                  \
{ram_data_out[22]}] [get_ports {ram_data_out[21]}] [get_ports                  \
{ram_data_out[20]}] [get_ports {ram_data_out[19]}] [get_ports                  \
{ram_data_out[18]}] [get_ports {ram_data_out[17]}] [get_ports                  \
{ram_data_out[16]}] [get_ports {ram_data_out[15]}] [get_ports                  \
{ram_data_out[14]}] [get_ports {ram_data_out[13]}] [get_ports                  \
{ram_data_out[12]}] [get_ports {ram_data_out[11]}] [get_ports                  \
{ram_data_out[10]}] [get_ports {ram_data_out[9]}] [get_ports                   \
{ram_data_out[8]}] [get_ports {ram_data_out[7]}] [get_ports {ram_data_out[6]}] \
[get_ports {ram_data_out[5]}] [get_ports {ram_data_out[4]}] [get_ports         \
{ram_data_out[3]}] [get_ports {ram_data_out[2]}] [get_ports {ram_data_out[1]}] \
[get_ports {ram_data_out[0]}]]  -to [list [get_ports btb_cache_update_line] [get_ports btb_cache_update_data] \
[get_ports {btb_cache_read_address[29]}] [get_ports                            \
{btb_cache_read_address[28]}] [get_ports {btb_cache_read_address[27]}]         \
[get_ports {btb_cache_read_address[26]}] [get_ports                            \
{btb_cache_read_address[25]}] [get_ports {btb_cache_read_address[24]}]         \
[get_ports {btb_cache_read_address[23]}] [get_ports                            \
{btb_cache_read_address[22]}] [get_ports {btb_cache_read_address[21]}]         \
[get_ports {btb_cache_read_address[20]}] [get_ports                            \
{btb_cache_read_address[19]}] [get_ports {btb_cache_read_address[18]}]         \
[get_ports {btb_cache_read_address[17]}] [get_ports                            \
{btb_cache_read_address[16]}] [get_ports {btb_cache_read_address[15]}]         \
[get_ports {btb_cache_read_address[14]}] [get_ports                            \
{btb_cache_read_address[13]}] [get_ports {btb_cache_read_address[12]}]         \
[get_ports {btb_cache_read_address[11]}] [get_ports                            \
{btb_cache_read_address[10]}] [get_ports {btb_cache_read_address[9]}]          \
[get_ports {btb_cache_read_address[8]}] [get_ports                             \
{btb_cache_read_address[7]}] [get_ports {btb_cache_read_address[6]}]           \
[get_ports {btb_cache_read_address[5]}] [get_ports                             \
{btb_cache_read_address[4]}] [get_ports {btb_cache_read_address[3]}]           \
[get_ports {btb_cache_read_address[2]}] [get_ports                             \
{btb_cache_read_address[1]}] [get_ports {btb_cache_read_address[0]}]           \
[get_ports {btb_cache_rw_address[29]}] [get_ports {btb_cache_rw_address[28]}]  \
[get_ports {btb_cache_rw_address[27]}] [get_ports {btb_cache_rw_address[26]}]  \
[get_ports {btb_cache_rw_address[25]}] [get_ports {btb_cache_rw_address[24]}]  \
[get_ports {btb_cache_rw_address[23]}] [get_ports {btb_cache_rw_address[22]}]  \
[get_ports {btb_cache_rw_address[21]}] [get_ports {btb_cache_rw_address[20]}]  \
[get_ports {btb_cache_rw_address[19]}] [get_ports {btb_cache_rw_address[18]}]  \
[get_ports {btb_cache_rw_address[17]}] [get_ports {btb_cache_rw_address[16]}]  \
[get_ports {btb_cache_rw_address[15]}] [get_ports {btb_cache_rw_address[14]}]  \
[get_ports {btb_cache_rw_address[13]}] [get_ports {btb_cache_rw_address[12]}]  \
[get_ports {btb_cache_rw_address[11]}] [get_ports {btb_cache_rw_address[10]}]  \
[get_ports {btb_cache_rw_address[9]}] [get_ports {btb_cache_rw_address[8]}]    \
[get_ports {btb_cache_rw_address[7]}] [get_ports {btb_cache_rw_address[6]}]    \
[get_ports {btb_cache_rw_address[5]}] [get_ports {btb_cache_rw_address[4]}]    \
[get_ports {btb_cache_rw_address[3]}] [get_ports {btb_cache_rw_address[2]}]    \
[get_ports {btb_cache_rw_address[1]}] [get_ports {btb_cache_rw_address[0]}]    \
[get_ports {btb_cache_data_in[31]}] [get_ports {btb_cache_data_in[30]}]        \
[get_ports {btb_cache_data_in[29]}] [get_ports {btb_cache_data_in[28]}]        \
[get_ports {btb_cache_data_in[27]}] [get_ports {btb_cache_data_in[26]}]        \
[get_ports {btb_cache_data_in[25]}] [get_ports {btb_cache_data_in[24]}]        \
[get_ports {btb_cache_data_in[23]}] [get_ports {btb_cache_data_in[22]}]        \
[get_ports {btb_cache_data_in[21]}] [get_ports {btb_cache_data_in[20]}]        \
[get_ports {btb_cache_data_in[19]}] [get_ports {btb_cache_data_in[18]}]        \
[get_ports {btb_cache_data_in[17]}] [get_ports {btb_cache_data_in[16]}]        \
[get_ports {btb_cache_data_in[15]}] [get_ports {btb_cache_data_in[14]}]        \
[get_ports {btb_cache_data_in[13]}] [get_ports {btb_cache_data_in[12]}]        \
[get_ports {btb_cache_data_in[11]}] [get_ports {btb_cache_data_in[10]}]        \
[get_ports {btb_cache_data_in[9]}] [get_ports {btb_cache_data_in[8]}]          \
[get_ports {btb_cache_data_in[7]}] [get_ports {btb_cache_data_in[6]}]          \
[get_ports {btb_cache_data_in[5]}] [get_ports {btb_cache_data_in[4]}]          \
[get_ports {btb_cache_data_in[3]}] [get_ports {btb_cache_data_in[2]}]          \
[get_ports {btb_cache_data_in[1]}] [get_ports {btb_cache_data_in[0]}]          \
[get_ports {pc_out[29]}] [get_ports {pc_out[28]}] [get_ports {pc_out[27]}]     \
[get_ports {pc_out[26]}] [get_ports {pc_out[25]}] [get_ports {pc_out[24]}]     \
[get_ports {pc_out[23]}] [get_ports {pc_out[22]}] [get_ports {pc_out[21]}]     \
[get_ports {pc_out[20]}] [get_ports {pc_out[19]}] [get_ports {pc_out[18]}]     \
[get_ports {pc_out[17]}] [get_ports {pc_out[16]}] [get_ports {pc_out[15]}]     \
[get_ports {pc_out[14]}] [get_ports {pc_out[13]}] [get_ports {pc_out[12]}]     \
[get_ports {pc_out[11]}] [get_ports {pc_out[10]}] [get_ports {pc_out[9]}]      \
[get_ports {pc_out[8]}] [get_ports {pc_out[7]}] [get_ports {pc_out[6]}]        \
[get_ports {pc_out[5]}] [get_ports {pc_out[4]}] [get_ports {pc_out[3]}]        \
[get_ports {pc_out[2]}] [get_ports {pc_out[1]}] [get_ports {pc_out[0]}]        \
[get_ports dcache_update] [get_ports {dcache_update_type[1]}] [get_ports       \
{dcache_update_type[0]}] [get_ports {dcache_address[31]}] [get_ports           \
{dcache_address[30]}] [get_ports {dcache_address[29]}] [get_ports              \
{dcache_address[28]}] [get_ports {dcache_address[27]}] [get_ports              \
{dcache_address[26]}] [get_ports {dcache_address[25]}] [get_ports              \
{dcache_address[24]}] [get_ports {dcache_address[23]}] [get_ports              \
{dcache_address[22]}] [get_ports {dcache_address[21]}] [get_ports              \
{dcache_address[20]}] [get_ports {dcache_address[19]}] [get_ports              \
{dcache_address[18]}] [get_ports {dcache_address[17]}] [get_ports              \
{dcache_address[16]}] [get_ports {dcache_address[15]}] [get_ports              \
{dcache_address[14]}] [get_ports {dcache_address[13]}] [get_ports              \
{dcache_address[12]}] [get_ports {dcache_address[11]}] [get_ports              \
{dcache_address[10]}] [get_ports {dcache_address[9]}] [get_ports               \
{dcache_address[8]}] [get_ports {dcache_address[7]}] [get_ports                \
{dcache_address[6]}] [get_ports {dcache_address[5]}] [get_ports                \
{dcache_address[4]}] [get_ports {dcache_address[3]}] [get_ports                \
{dcache_address[2]}] [get_ports {dcache_address[1]}] [get_ports                \
{dcache_address[0]}] [get_ports {dcache_data_out[31]}] [get_ports              \
{dcache_data_out[30]}] [get_ports {dcache_data_out[29]}] [get_ports            \
{dcache_data_out[28]}] [get_ports {dcache_data_out[27]}] [get_ports            \
{dcache_data_out[26]}] [get_ports {dcache_data_out[25]}] [get_ports            \
{dcache_data_out[24]}] [get_ports {dcache_data_out[23]}] [get_ports            \
{dcache_data_out[22]}] [get_ports {dcache_data_out[21]}] [get_ports            \
{dcache_data_out[20]}] [get_ports {dcache_data_out[19]}] [get_ports            \
{dcache_data_out[18]}] [get_ports {dcache_data_out[17]}] [get_ports            \
{dcache_data_out[16]}] [get_ports {dcache_data_out[15]}] [get_ports            \
{dcache_data_out[14]}] [get_ports {dcache_data_out[13]}] [get_ports            \
{dcache_data_out[12]}] [get_ports {dcache_data_out[11]}] [get_ports            \
{dcache_data_out[10]}] [get_ports {dcache_data_out[9]}] [get_ports             \
{dcache_data_out[8]}] [get_ports {dcache_data_out[7]}] [get_ports              \
{dcache_data_out[6]}] [get_ports {dcache_data_out[5]}] [get_ports              \
{dcache_data_out[4]}] [get_ports {dcache_data_out[3]}] [get_ports              \
{dcache_data_out[2]}] [get_ports {dcache_data_out[1]}] [get_ports              \
{dcache_data_out[0]}] [get_ports {ram_to_cache_data[31]}] [get_ports           \
{ram_to_cache_data[30]}] [get_ports {ram_to_cache_data[29]}] [get_ports        \
{ram_to_cache_data[28]}] [get_ports {ram_to_cache_data[27]}] [get_ports        \
{ram_to_cache_data[26]}] [get_ports {ram_to_cache_data[25]}] [get_ports        \
{ram_to_cache_data[24]}] [get_ports {ram_to_cache_data[23]}] [get_ports        \
{ram_to_cache_data[22]}] [get_ports {ram_to_cache_data[21]}] [get_ports        \
{ram_to_cache_data[20]}] [get_ports {ram_to_cache_data[19]}] [get_ports        \
{ram_to_cache_data[18]}] [get_ports {ram_to_cache_data[17]}] [get_ports        \
{ram_to_cache_data[16]}] [get_ports {ram_to_cache_data[15]}] [get_ports        \
{ram_to_cache_data[14]}] [get_ports {ram_to_cache_data[13]}] [get_ports        \
{ram_to_cache_data[12]}] [get_ports {ram_to_cache_data[11]}] [get_ports        \
{ram_to_cache_data[10]}] [get_ports {ram_to_cache_data[9]}] [get_ports         \
{ram_to_cache_data[8]}] [get_ports {ram_to_cache_data[7]}] [get_ports          \
{ram_to_cache_data[6]}] [get_ports {ram_to_cache_data[5]}] [get_ports          \
{ram_to_cache_data[4]}] [get_ports {ram_to_cache_data[3]}] [get_ports          \
{ram_to_cache_data[2]}] [get_ports {ram_to_cache_data[1]}] [get_ports          \
{ram_to_cache_data[0]}] [get_ports ram_rw] [get_ports {ram_address[7]}]        \
[get_ports {ram_address[6]}] [get_ports {ram_address[5]}] [get_ports           \
{ram_address[4]}] [get_ports {ram_address[3]}] [get_ports {ram_address[2]}]    \
[get_ports {ram_address[1]}] [get_ports {ram_address[0]}] [get_ports           \
{ram_data_in[31]}] [get_ports {ram_data_in[30]}] [get_ports {ram_data_in[29]}] \
[get_ports {ram_data_in[28]}] [get_ports {ram_data_in[27]}] [get_ports         \
{ram_data_in[26]}] [get_ports {ram_data_in[25]}] [get_ports {ram_data_in[24]}] \
[get_ports {ram_data_in[23]}] [get_ports {ram_data_in[22]}] [get_ports         \
{ram_data_in[21]}] [get_ports {ram_data_in[20]}] [get_ports {ram_data_in[19]}] \
[get_ports {ram_data_in[18]}] [get_ports {ram_data_in[17]}] [get_ports         \
{ram_data_in[16]}] [get_ports {ram_data_in[15]}] [get_ports {ram_data_in[14]}] \
[get_ports {ram_data_in[13]}] [get_ports {ram_data_in[12]}] [get_ports         \
{ram_data_in[11]}] [get_ports {ram_data_in[10]}] [get_ports {ram_data_in[9]}]  \
[get_ports {ram_data_in[8]}] [get_ports {ram_data_in[7]}] [get_ports           \
{ram_data_in[6]}] [get_ports {ram_data_in[5]}] [get_ports {ram_data_in[4]}]    \
[get_ports {ram_data_in[3]}] [get_ports {ram_data_in[2]}] [get_ports           \
{ram_data_in[1]}] [get_ports {ram_data_in[0]}] [get_ports pc_en] [get_ports    \
predicted_taken] [get_ports taken] [get_ports wp_en] [get_ports hilo_wr_en]    \
[get_ports {rd[4]}] [get_ports {rd[3]}] [get_ports {rd[2]}] [get_ports         \
{rd[1]}] [get_ports {rd[0]}] [get_ports {wp_data[31]}] [get_ports              \
{wp_data[30]}] [get_ports {wp_data[29]}] [get_ports {wp_data[28]}] [get_ports  \
{wp_data[27]}] [get_ports {wp_data[26]}] [get_ports {wp_data[25]}] [get_ports  \
{wp_data[24]}] [get_ports {wp_data[23]}] [get_ports {wp_data[22]}] [get_ports  \
{wp_data[21]}] [get_ports {wp_data[20]}] [get_ports {wp_data[19]}] [get_ports  \
{wp_data[18]}] [get_ports {wp_data[17]}] [get_ports {wp_data[16]}] [get_ports  \
{wp_data[15]}] [get_ports {wp_data[14]}] [get_ports {wp_data[13]}] [get_ports  \
{wp_data[12]}] [get_ports {wp_data[11]}] [get_ports {wp_data[10]}] [get_ports  \
{wp_data[9]}] [get_ports {wp_data[8]}] [get_ports {wp_data[7]}] [get_ports     \
{wp_data[6]}] [get_ports {wp_data[5]}] [get_ports {wp_data[4]}] [get_ports     \
{wp_data[3]}] [get_ports {wp_data[2]}] [get_ports {wp_data[1]}] [get_ports     \
{wp_data[0]}] [get_ports {wp_alu_data_high[31]}] [get_ports                    \
{wp_alu_data_high[30]}] [get_ports {wp_alu_data_high[29]}] [get_ports          \
{wp_alu_data_high[28]}] [get_ports {wp_alu_data_high[27]}] [get_ports          \
{wp_alu_data_high[26]}] [get_ports {wp_alu_data_high[25]}] [get_ports          \
{wp_alu_data_high[24]}] [get_ports {wp_alu_data_high[23]}] [get_ports          \
{wp_alu_data_high[22]}] [get_ports {wp_alu_data_high[21]}] [get_ports          \
{wp_alu_data_high[20]}] [get_ports {wp_alu_data_high[19]}] [get_ports          \
{wp_alu_data_high[18]}] [get_ports {wp_alu_data_high[17]}] [get_ports          \
{wp_alu_data_high[16]}] [get_ports {wp_alu_data_high[15]}] [get_ports          \
{wp_alu_data_high[14]}] [get_ports {wp_alu_data_high[13]}] [get_ports          \
{wp_alu_data_high[12]}] [get_ports {wp_alu_data_high[11]}] [get_ports          \
{wp_alu_data_high[10]}] [get_ports {wp_alu_data_high[9]}] [get_ports           \
{wp_alu_data_high[8]}] [get_ports {wp_alu_data_high[7]}] [get_ports            \
{wp_alu_data_high[6]}] [get_ports {wp_alu_data_high[5]}] [get_ports            \
{wp_alu_data_high[4]}] [get_ports {wp_alu_data_high[3]}] [get_ports            \
{wp_alu_data_high[2]}] [get_ports {wp_alu_data_high[1]}] [get_ports            \
{wp_alu_data_high[0]}]]
