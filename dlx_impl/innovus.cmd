#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Mon Oct 19 17:44:30 2020                
#                                                     
#######################################################

#@(#)CDS: Innovus v17.11-s080_1 (64bit) 08/04/2017 11:13 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 17.11-s080_1 NR170721-2155/17_11-UB (database version 2.30, 390.7.1) {superthreading v1.44}
#@(#)CDS: AAE 17.11-s034 (64bit) 08/04/2017 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 17.11-s053_1 () Aug  1 2017 23:31:41 ( )
#@(#)CDS: SYNTECH 17.11-s012_1 () Jul 21 2017 02:29:12 ( )
#@(#)CDS: CPE v17.11-s095
#@(#)CDS: IQRC/TQRC 16.1.1-s215 (64bit) Thu Jul  6 20:18:10 PDT 2017 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
set defHierChar /
set delaycal_input_transition_delay 0.1ps
set fpIsMaxIoHeight 0
set init_gnd_net gnd
set init_mmmc_file Default.view
set init_oa_search_lib {}
set init_pwr_net vdd
set init_verilog dlx.v
set init_lef_file /software/dk/nangate45/lef/NangateOpenCellLibrary.lef
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
init_design
getIoFlowFlag
setIoFlowFlag 0
floorPlan -coreMarginsBy die -site FreePDK45_38x28_10R_NP_162NW_34O -r 1.0 0.6 5 5 5 5
uiSetTool select
getIoFlowFlag
fit
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {gnd vdd} -type core_rings -follow core -layer {top metal9 bottom metal9 left metal10 right metal10} -width {top 0.8 bottom 0.8 left 0.8 right 0.8} -spacing {top 0.8 bottom 0.8 left 0.8 right 0.8} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -extend_corner {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length 0 -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring }
addStripe -nets {gnd vdd} -layer metal10 -direction vertical -width 0.8 -spacing 0.8 -set_to_set_distance 20 -start_from left -start_offset 15 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit metal10 -padcore_ring_bottom_layer_limit metal1 -block_ring_top_layer_limit metal10 -block_ring_bottom_layer_limit metal1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { metal1(1) metal10(10) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { metal1(1) metal10(10) } -nets { gnd vdd } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { metal1(1) metal10(10) }
setPlaceMode -prerouteAsObs {1 2 3 4 5 6 7 8}
setPlaceMode -fp false
placeDesign
gui_select -rect {-14.879 56.248 62.619 -5.893}
deselectAll
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{btb_cache_data_in[0]} {btb_cache_data_in[1]} {btb_cache_data_in[2]} {btb_cache_data_in[3]} {btb_cache_data_in[4]} {btb_cache_data_in[5]} {btb_cache_data_in[6]} {btb_cache_data_in[7]} {btb_cache_data_in[8]} {btb_cache_data_in[9]} {btb_cache_data_in[10]} {btb_cache_data_in[11]} {btb_cache_data_in[12]} {btb_cache_data_in[13]} {btb_cache_data_in[14]} {btb_cache_data_in[15]} {btb_cache_data_in[16]} {btb_cache_data_in[17]} {btb_cache_data_in[18]} {btb_cache_data_in[19]} {btb_cache_data_in[20]} {btb_cache_data_in[21]} {btb_cache_data_in[22]} {btb_cache_data_in[23]} {btb_cache_data_in[24]} {btb_cache_data_in[25]} {btb_cache_data_in[26]} {btb_cache_data_in[27]} {btb_cache_data_in[28]} {btb_cache_data_in[29]} {btb_cache_data_in[30]} {btb_cache_data_in[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Bottom -layer 1 -spreadType side -pin {{btb_cache_data_out_read[0]} {btb_cache_data_out_read[1]} {btb_cache_data_out_read[2]} {btb_cache_data_out_read[3]} {btb_cache_data_out_read[4]} {btb_cache_data_out_read[5]} {btb_cache_data_out_read[6]} {btb_cache_data_out_read[7]} {btb_cache_data_out_read[8]} {btb_cache_data_out_read[9]} {btb_cache_data_out_read[10]} {btb_cache_data_out_read[11]} {btb_cache_data_out_read[12]} {btb_cache_data_out_read[13]} {btb_cache_data_out_read[14]} {btb_cache_data_out_read[15]} {btb_cache_data_out_read[16]} {btb_cache_data_out_read[17]} {btb_cache_data_out_read[18]} {btb_cache_data_out_read[19]} {btb_cache_data_out_read[20]} {btb_cache_data_out_read[21]} {btb_cache_data_out_read[22]} {btb_cache_data_out_read[23]} {btb_cache_data_out_read[24]} {btb_cache_data_out_read[25]} {btb_cache_data_out_read[26]} {btb_cache_data_out_read[27]} {btb_cache_data_out_read[28]} {btb_cache_data_out_read[29]} {btb_cache_data_out_read[30]} {btb_cache_data_out_read[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{btb_cache_data_out_rw[0]} {btb_cache_data_out_rw[1]} {btb_cache_data_out_rw[2]} {btb_cache_data_out_rw[3]} {btb_cache_data_out_rw[4]} {btb_cache_data_out_rw[5]} {btb_cache_data_out_rw[6]} {btb_cache_data_out_rw[7]} {btb_cache_data_out_rw[8]} {btb_cache_data_out_rw[9]} {btb_cache_data_out_rw[10]} {btb_cache_data_out_rw[11]} {btb_cache_data_out_rw[12]} {btb_cache_data_out_rw[13]} {btb_cache_data_out_rw[14]} {btb_cache_data_out_rw[15]} {btb_cache_data_out_rw[16]} {btb_cache_data_out_rw[17]} {btb_cache_data_out_rw[18]} {btb_cache_data_out_rw[19]} {btb_cache_data_out_rw[20]} {btb_cache_data_out_rw[21]} {btb_cache_data_out_rw[22]} {btb_cache_data_out_rw[23]} {btb_cache_data_out_rw[24]} {btb_cache_data_out_rw[25]} {btb_cache_data_out_rw[26]} {btb_cache_data_out_rw[27]} {btb_cache_data_out_rw[28]} {btb_cache_data_out_rw[29]} {btb_cache_data_out_rw[30]} {btb_cache_data_out_rw[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 0.14 -pin btb_cache_hit_read
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin btb_cache_hit_rw
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{btb_cache_read_address[0]} {btb_cache_read_address[1]} {btb_cache_read_address[2]} {btb_cache_read_address[3]} {btb_cache_read_address[4]} {btb_cache_read_address[5]} {btb_cache_read_address[6]} {btb_cache_read_address[7]} {btb_cache_read_address[8]} {btb_cache_read_address[9]} {btb_cache_read_address[10]} {btb_cache_read_address[11]} {btb_cache_read_address[12]} {btb_cache_read_address[13]} {btb_cache_read_address[14]} {btb_cache_read_address[15]} {btb_cache_read_address[16]} {btb_cache_read_address[17]} {btb_cache_read_address[18]} {btb_cache_read_address[19]} {btb_cache_read_address[20]} {btb_cache_read_address[21]} {btb_cache_read_address[22]} {btb_cache_read_address[23]} {btb_cache_read_address[24]} {btb_cache_read_address[25]} {btb_cache_read_address[26]} {btb_cache_read_address[27]} {btb_cache_read_address[28]} {btb_cache_read_address[29]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{btb_cache_rw_address[0]} {btb_cache_rw_address[1]} {btb_cache_rw_address[2]} {btb_cache_rw_address[3]} {btb_cache_rw_address[4]} {btb_cache_rw_address[5]} {btb_cache_rw_address[6]} {btb_cache_rw_address[7]} {btb_cache_rw_address[8]} {btb_cache_rw_address[9]} {btb_cache_rw_address[10]} {btb_cache_rw_address[11]} {btb_cache_rw_address[12]} {btb_cache_rw_address[13]} {btb_cache_rw_address[14]} {btb_cache_rw_address[15]} {btb_cache_rw_address[16]} {btb_cache_rw_address[17]} {btb_cache_rw_address[18]} {btb_cache_rw_address[19]} {btb_cache_rw_address[20]} {btb_cache_rw_address[21]} {btb_cache_rw_address[22]} {btb_cache_rw_address[23]} {btb_cache_rw_address[24]} {btb_cache_rw_address[25]} {btb_cache_rw_address[26]} {btb_cache_rw_address[27]} {btb_cache_rw_address[28]} {btb_cache_rw_address[29]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 0.14 -pin btb_cache_update_data
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 0.14 -pin btb_cache_update_line
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{cache_to_ram_data[0]} {cache_to_ram_data[1]} {cache_to_ram_data[2]} {cache_to_ram_data[3]} {cache_to_ram_data[4]} {cache_to_ram_data[5]} {cache_to_ram_data[6]} {cache_to_ram_data[7]} {cache_to_ram_data[8]} {cache_to_ram_data[9]} {cache_to_ram_data[10]} {cache_to_ram_data[11]} {cache_to_ram_data[12]} {cache_to_ram_data[13]} {cache_to_ram_data[14]} {cache_to_ram_data[15]} {cache_to_ram_data[16]} {cache_to_ram_data[17]} {cache_to_ram_data[18]} {cache_to_ram_data[19]} {cache_to_ram_data[20]} {cache_to_ram_data[21]} {cache_to_ram_data[22]} {cache_to_ram_data[23]} {cache_to_ram_data[24]} {cache_to_ram_data[25]} {cache_to_ram_data[26]} {cache_to_ram_data[27]} {cache_to_ram_data[28]} {cache_to_ram_data[29]} {cache_to_ram_data[30]} {cache_to_ram_data[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 0.14 -pin clk
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{cpu_cache_address[0]} {cpu_cache_address[1]} {cpu_cache_address[2]} {cpu_cache_address[3]} {cpu_cache_address[4]} {cpu_cache_address[5]} {cpu_cache_address[6]} {cpu_cache_address[7]} {cpu_cache_address[8]} {cpu_cache_address[9]} {cpu_cache_address[10]} {cpu_cache_address[11]} {cpu_cache_address[12]} {cpu_cache_address[13]} {cpu_cache_address[14]} {cpu_cache_address[15]} {cpu_cache_address[16]} {cpu_cache_address[17]} {cpu_cache_address[18]} {cpu_cache_address[19]} {cpu_cache_address[20]} {cpu_cache_address[21]} {cpu_cache_address[22]} {cpu_cache_address[23]} {cpu_cache_address[24]} {cpu_cache_address[25]} {cpu_cache_address[26]} {cpu_cache_address[27]} {cpu_cache_address[28]} {cpu_cache_address[29]} {cpu_cache_address[30]} {cpu_cache_address[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Bottom -layer 1 -spreadType side -pin {{dcache_address[0]} {dcache_address[1]} {dcache_address[2]} {dcache_address[3]} {dcache_address[4]} {dcache_address[5]} {dcache_address[6]} {dcache_address[7]} {dcache_address[8]} {dcache_address[9]} {dcache_address[10]} {dcache_address[11]} {dcache_address[12]} {dcache_address[13]} {dcache_address[14]} {dcache_address[15]} {dcache_address[16]} {dcache_address[17]} {dcache_address[18]} {dcache_address[19]} {dcache_address[20]} {dcache_address[21]} {dcache_address[22]} {dcache_address[23]} {dcache_address[24]} {dcache_address[25]} {dcache_address[26]} {dcache_address[27]} {dcache_address[28]} {dcache_address[29]} {dcache_address[30]} {dcache_address[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{dcache_data_in[0]} {dcache_data_in[1]} {dcache_data_in[2]} {dcache_data_in[3]} {dcache_data_in[4]} {dcache_data_in[5]} {dcache_data_in[6]} {dcache_data_in[7]} {dcache_data_in[8]} {dcache_data_in[9]} {dcache_data_in[10]} {dcache_data_in[11]} {dcache_data_in[12]} {dcache_data_in[13]} {dcache_data_in[14]} {dcache_data_in[15]} {dcache_data_in[16]} {dcache_data_in[17]} {dcache_data_in[18]} {dcache_data_in[19]} {dcache_data_in[20]} {dcache_data_in[21]} {dcache_data_in[22]} {dcache_data_in[23]} {dcache_data_in[24]} {dcache_data_in[25]} {dcache_data_in[26]} {dcache_data_in[27]} {dcache_data_in[28]} {dcache_data_in[29]} {dcache_data_in[30]} {dcache_data_in[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Bottom -layer 1 -spreadType side -pin {{dcache_data_out[0]} {dcache_data_out[1]} {dcache_data_out[2]} {dcache_data_out[3]} {dcache_data_out[4]} {dcache_data_out[5]} {dcache_data_out[6]} {dcache_data_out[7]} {dcache_data_out[8]} {dcache_data_out[9]} {dcache_data_out[10]} {dcache_data_out[11]} {dcache_data_out[12]} {dcache_data_out[13]} {dcache_data_out[14]} {dcache_data_out[15]} {dcache_data_out[16]} {dcache_data_out[17]} {dcache_data_out[18]} {dcache_data_out[19]} {dcache_data_out[20]} {dcache_data_out[21]} {dcache_data_out[22]} {dcache_data_out[23]} {dcache_data_out[24]} {dcache_data_out[25]} {dcache_data_out[26]} {dcache_data_out[27]} {dcache_data_out[28]} {dcache_data_out[29]} {dcache_data_out[30]} {dcache_data_out[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 0.14 -pin dcache_hit
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 0.14 -pin dcache_update
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType range -start 0.0 0.0 -end 0.0 0.0 -pin {{dcache_update_type[0]} {dcache_update_type[1]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{dcache_update_type[0]} {dcache_update_type[1]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{evicted_cache_address[0]} {evicted_cache_address[1]} {evicted_cache_address[2]} {evicted_cache_address[3]} {evicted_cache_address[4]} {evicted_cache_address[5]} {evicted_cache_address[6]} {evicted_cache_address[7]} {evicted_cache_address[8]} {evicted_cache_address[9]} {evicted_cache_address[10]} {evicted_cache_address[11]} {evicted_cache_address[12]} {evicted_cache_address[13]} {evicted_cache_address[14]} {evicted_cache_address[15]} {evicted_cache_address[16]} {evicted_cache_address[17]} {evicted_cache_address[18]} {evicted_cache_address[19]} {evicted_cache_address[20]} {evicted_cache_address[21]} {evicted_cache_address[22]} {evicted_cache_address[23]} {evicted_cache_address[24]} {evicted_cache_address[25]} {evicted_cache_address[26]} {evicted_cache_address[27]} {evicted_cache_address[28]} {evicted_cache_address[29]} {evicted_cache_address[30]} {evicted_cache_address[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin hilo_wr_en
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin pc_en
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{instr_if[0]} {instr_if[1]} {instr_if[2]} {instr_if[3]} {instr_if[4]} {instr_if[5]} {instr_if[6]} {instr_if[7]} {instr_if[8]} {instr_if[9]} {instr_if[10]} {instr_if[11]} {instr_if[12]} {instr_if[13]} {instr_if[14]} {instr_if[15]} {instr_if[16]} {instr_if[17]} {instr_if[18]} {instr_if[19]} {instr_if[20]} {instr_if[21]} {instr_if[22]} {instr_if[23]} {instr_if[24]} {instr_if[25]} {instr_if[26]} {instr_if[27]} {instr_if[28]} {instr_if[29]} {instr_if[30]} {instr_if[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{pc_out[0]} {pc_out[1]} {pc_out[2]} {pc_out[3]} {pc_out[4]} {pc_out[5]} {pc_out[6]} {pc_out[7]} {pc_out[8]} {pc_out[9]} {pc_out[10]} {pc_out[11]} {pc_out[12]} {pc_out[13]} {pc_out[14]} {pc_out[15]} {pc_out[16]} {pc_out[17]} {pc_out[18]} {pc_out[19]} {pc_out[20]} {pc_out[21]} {pc_out[22]} {pc_out[23]} {pc_out[24]} {pc_out[25]} {pc_out[26]} {pc_out[27]} {pc_out[28]} {pc_out[29]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin predicted_taken
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{ram_address[0]} {ram_address[1]} {ram_address[2]} {ram_address[3]} {ram_address[4]} {ram_address[5]} {ram_address[6]} {ram_address[7]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{ram_data_in[0]} {ram_data_in[1]} {ram_data_in[2]} {ram_data_in[3]} {ram_data_in[4]} {ram_data_in[5]} {ram_data_in[6]} {ram_data_in[7]} {ram_data_in[8]} {ram_data_in[9]} {ram_data_in[10]} {ram_data_in[11]} {ram_data_in[12]} {ram_data_in[13]} {ram_data_in[14]} {ram_data_in[15]} {ram_data_in[16]} {ram_data_in[17]} {ram_data_in[18]} {ram_data_in[19]} {ram_data_in[20]} {ram_data_in[21]} {ram_data_in[22]} {ram_data_in[23]} {ram_data_in[24]} {ram_data_in[25]} {ram_data_in[26]} {ram_data_in[27]} {ram_data_in[28]} {ram_data_in[29]} {ram_data_in[30]} {ram_data_in[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Bottom -layer 1 -spreadType side -pin {{ram_data_out[0]} {ram_data_out[1]} {ram_data_out[2]} {ram_data_out[3]} {ram_data_out[4]} {ram_data_out[5]} {ram_data_out[6]} {ram_data_out[7]} {ram_data_out[8]} {ram_data_out[9]} {ram_data_out[10]} {ram_data_out[11]} {ram_data_out[12]} {ram_data_out[13]} {ram_data_out[14]} {ram_data_out[15]} {ram_data_out[16]} {ram_data_out[17]} {ram_data_out[18]} {ram_data_out[19]} {ram_data_out[20]} {ram_data_out[21]} {ram_data_out[22]} {ram_data_out[23]} {ram_data_out[24]} {ram_data_out[25]} {ram_data_out[26]} {ram_data_out[27]} {ram_data_out[28]} {ram_data_out[29]} {ram_data_out[30]} {ram_data_out[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 0.14 -pin ram_rw
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{ram_to_cache_data[0]} {ram_to_cache_data[1]} {ram_to_cache_data[2]} {ram_to_cache_data[3]} {ram_to_cache_data[4]} {ram_to_cache_data[5]} {ram_to_cache_data[6]} {ram_to_cache_data[7]} {ram_to_cache_data[8]} {ram_to_cache_data[9]} {ram_to_cache_data[10]} {ram_to_cache_data[11]} {ram_to_cache_data[12]} {ram_to_cache_data[13]} {ram_to_cache_data[14]} {ram_to_cache_data[15]} {ram_to_cache_data[16]} {ram_to_cache_data[17]} {ram_to_cache_data[18]} {ram_to_cache_data[19]} {ram_to_cache_data[20]} {ram_to_cache_data[21]} {ram_to_cache_data[22]} {ram_to_cache_data[23]} {ram_to_cache_data[24]} {ram_to_cache_data[25]} {ram_to_cache_data[26]} {ram_to_cache_data[27]} {ram_to_cache_data[28]} {ram_to_cache_data[29]} {ram_to_cache_data[30]} {ram_to_cache_data[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 0.14 -pin ram_update
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Bottom -layer 1 -spreadType side -pin {{rd[0]} {rd[1]} {rd[2]} {rd[3]} {rd[4]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 0.14 -pin rst
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 0.14 -pin taken
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{wp_alu_data_high[0]} {wp_alu_data_high[1]} {wp_alu_data_high[2]} {wp_alu_data_high[3]} {wp_alu_data_high[4]} {wp_alu_data_high[5]} {wp_alu_data_high[6]} {wp_alu_data_high[7]} {wp_alu_data_high[8]} {wp_alu_data_high[9]} {wp_alu_data_high[10]} {wp_alu_data_high[11]} {wp_alu_data_high[12]} {wp_alu_data_high[13]} {wp_alu_data_high[14]} {wp_alu_data_high[15]} {wp_alu_data_high[16]} {wp_alu_data_high[17]} {wp_alu_data_high[18]} {wp_alu_data_high[19]} {wp_alu_data_high[20]} {wp_alu_data_high[21]} {wp_alu_data_high[22]} {wp_alu_data_high[23]} {wp_alu_data_high[24]} {wp_alu_data_high[25]} {wp_alu_data_high[26]} {wp_alu_data_high[27]} {wp_alu_data_high[28]} {wp_alu_data_high[29]} {wp_alu_data_high[30]} {wp_alu_data_high[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{wp_data[0]} {wp_data[1]} {wp_data[2]} {wp_data[3]} {wp_data[4]} {wp_data[5]} {wp_data[6]} {wp_data[7]} {wp_data[8]} {wp_data[9]} {wp_data[10]} {wp_data[11]} {wp_data[12]} {wp_data[13]} {wp_data[14]} {wp_data[15]} {wp_data[16]} {wp_data[17]} {wp_data[18]} {wp_data[19]} {wp_data[20]} {wp_data[21]} {wp_data[22]} {wp_data[23]} {wp_data[24]} {wp_data[25]} {wp_data[26]} {wp_data[27]} {wp_data[28]} {wp_data[29]} {wp_data[30]} {wp_data[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin wp_en
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{btb_cache_data_in[0]} {btb_cache_data_in[1]} {btb_cache_data_in[2]} {btb_cache_data_in[3]} {btb_cache_data_in[4]} {btb_cache_data_in[5]} {btb_cache_data_in[6]} {btb_cache_data_in[7]} {btb_cache_data_in[8]} {btb_cache_data_in[9]} {btb_cache_data_in[10]} {btb_cache_data_in[11]} {btb_cache_data_in[12]} {btb_cache_data_in[13]} {btb_cache_data_in[14]} {btb_cache_data_in[15]} {btb_cache_data_in[16]} {btb_cache_data_in[17]} {btb_cache_data_in[18]} {btb_cache_data_in[19]} {btb_cache_data_in[20]} {btb_cache_data_in[21]} {btb_cache_data_in[22]} {btb_cache_data_in[23]} {btb_cache_data_in[24]} {btb_cache_data_in[25]} {btb_cache_data_in[26]} {btb_cache_data_in[27]} {btb_cache_data_in[28]} {btb_cache_data_in[29]} {btb_cache_data_in[30]} {btb_cache_data_in[31]}}
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -spreadDirection clockwise -side Bottom -layer 1 -spreadType side -pin {{btb_cache_data_out_read[0]} {btb_cache_data_out_read[1]} {btb_cache_data_out_read[2]} {btb_cache_data_out_read[3]} {btb_cache_data_out_read[4]} {btb_cache_data_out_read[5]} {btb_cache_data_out_read[6]} {btb_cache_data_out_read[7]} {btb_cache_data_out_read[8]} {btb_cache_data_out_read[9]} {btb_cache_data_out_read[10]} {btb_cache_data_out_read[11]} {btb_cache_data_out_read[12]} {btb_cache_data_out_read[13]} {btb_cache_data_out_read[14]} {btb_cache_data_out_read[15]} {btb_cache_data_out_read[16]} {btb_cache_data_out_read[17]} {btb_cache_data_out_read[18]} {btb_cache_data_out_read[19]} {btb_cache_data_out_read[20]} {btb_cache_data_out_read[21]} {btb_cache_data_out_read[22]} {btb_cache_data_out_read[23]} {btb_cache_data_out_read[24]} {btb_cache_data_out_read[25]} {btb_cache_data_out_read[26]} {btb_cache_data_out_read[27]} {btb_cache_data_out_read[28]} {btb_cache_data_out_read[29]} {btb_cache_data_out_read[30]} {btb_cache_data_out_read[31]}}
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin btb_cache_hit_read -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin btb_cache_hit_rw -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin btb_cache_update_data -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin btb_cache_update_line -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin clk -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin dcache_hit -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin dcache_update -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin hilo_wr_en -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin pc_en -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin predicted_taken -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin ram_rw -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin ram_update -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin rst -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin taken -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
set ptngSprNoRefreshPins 1
setPtnPinStatus -cell dlx_syn -pin wp_en -status unplaced -silent
set ptngSprNoRefreshPins 0
ptnSprRefreshPinsAndBlockages
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{wp_data[0]} {wp_data[1]} {wp_data[2]} {wp_data[3]} {wp_data[4]} {wp_data[5]} {wp_data[6]} {wp_data[7]} {wp_data[8]} {wp_data[9]} {wp_data[10]} {wp_data[11]} {wp_data[12]} {wp_data[13]} {wp_data[14]} {wp_data[15]} {wp_data[16]} {wp_data[17]} {wp_data[18]} {wp_data[19]} {wp_data[20]} {wp_data[21]} {wp_data[22]} {wp_data[23]} {wp_data[24]} {wp_data[25]} {wp_data[26]} {wp_data[27]} {wp_data[28]} {wp_data[29]} {wp_data[30]} {wp_data[31]}}
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 1.0 -pin btb_cache_hit_read
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 1.0 -pin btb_cache_hit_rw
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 1.0 -pin btb_cache_update_data
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 1.0 -pin btb_cache_update_line
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 1.0 -pin clk
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 1.0 -pin dcache_hit
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 1.0 -pin dcache_update
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 1.0 -pin hilo_wr_en
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 1.0 -pin pc_en
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 1.0 -pin predicted_taken
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 1.0 -pin ram_rw
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 1 -spreadType center -spacing 1.0 -pin ram_update
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 1 -spreadType center -spacing 1.0 -pin rst
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 1.0 -pin taken
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 1.0 -pin wp_en
setPinAssignMode -pinEditInBatch true
editPin -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Right -layer 1 -spreadType center -spacing 0.14 -pin wp_en
setPinAssignMode -pinEditInBatch false
getPinAssignMode -pinEditInBatch -quiet
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postCTS
optDesign -postCTS -hold
getFillerMode -quiet
addFiller -cell FILLCELL_X8 FILLCELL_X4 FILLCELL_X32 FILLCELL_X2 FILLCELL_X16 FILLCELL_X1 -prefix FILLER
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail
setAnalysisMode -analysisType onChipVariation
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute
optDesign -postRoute -hold
saveDesign dlx_syn
win
set_analysis_view -setup {default} -hold {default}
reset_parasitics
extractRC
rcOut -setload dlx_syn.setload -rc_corner standard
rcOut -setres dlx_syn.setres -rc_corner standard
rcOut -spf dlx_syn.spf -rc_corner standard
rcOut -spef dlx_syn.spef -rc_corner standard
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix dlx_syn_postRoute -outDir timingReports
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix dlx_syn_postRoute -outDir timingReports
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt
verifyConnectivity -type all -error 1000 -warning 50
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -mergedMGridCheck true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000
verifyGeometry
setVerifyGeometryMode -area { 0 0 0 0 }
reportGateCount -level 5 -limit 100 -outfile dlx_syn.gateCount
saveNetlist dlx_syn.v
all_hold_analysis_views 
all_setup_analysis_views 
write_sdf  -ideal_clock_network dlx_syn.sdf
gui_select -rect {191.520 189.045 191.728 188.696}
selectMarker 190.8450 189.1750 190.9500 189.2450 1 1 6
deselectAll
selectMarker 190.8450 189.1750 190.9500 189.2450 1 1 6
deselectAll
selectMarker 190.8450 189.1750 190.9500 189.2450 1 1 6
deselectAll
selectMarker 190.8450 189.1750 190.9500 189.2450 1 1 6
setLayerPreference violation -isVisible 1
violationBrowser -all -no_display_false
zoomBox 190.345 188.675 191.45 189.745
zoomBox 190.345 188.675 191.45 189.745
