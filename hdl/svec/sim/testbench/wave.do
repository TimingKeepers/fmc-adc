onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /main/DUT/sys_clk_62_5
add wave -noupdate /main/DUT/sys_clk_125
add wave -noupdate /main/DUT/sys_rst_n
add wave -noupdate -divider {wb vme}
add wave -noupdate /main/DUT/cnx_slave_in(0).cyc
add wave -noupdate /main/DUT/cnx_slave_in(0).stb
add wave -noupdate /main/DUT/cnx_slave_in(0).we
add wave -noupdate -radix hexadecimal /main/DUT/cnx_slave_in(0).adr
add wave -noupdate -radix hexadecimal /main/DUT/cnx_slave_in(0).dat
add wave -noupdate /main/DUT/cnx_slave_out(0).ack
add wave -noupdate /main/DUT/cnx_slave_out(0).stall
add wave -noupdate -radix hexadecimal /main/DUT/cnx_slave_out(0).dat
add wave -noupdate -divider {wb ddr0 addr}
add wave -noupdate /main/DUT/cnx_master_out(6).cyc
add wave -noupdate /main/DUT/cnx_master_out(6).stb
add wave -noupdate /main/DUT/cnx_master_out(6).we
add wave -noupdate -radix hexadecimal /main/DUT/cnx_master_out(6).adr
add wave -noupdate -radix hexadecimal /main/DUT/cnx_master_out(6).dat
add wave -noupdate /main/DUT/cnx_master_in(6).ack
add wave -noupdate -radix hexadecimal /main/DUT/cnx_master_in(6).dat
add wave -noupdate -radix hexadecimal /main/DUT/ddr0_addr_cnt
add wave -noupdate -divider {wb ddr0 data}
add wave -noupdate /main/DUT/cnx_master_out(5).cyc
add wave -noupdate /main/DUT/cnx_master_out(5).stb
add wave -noupdate /main/DUT/cnx_master_out(5).we
add wave -noupdate -radix hexadecimal /main/DUT/cnx_master_out(5).adr
add wave -noupdate -radix hexadecimal /main/DUT/cnx_master_out(5).dat
add wave -noupdate /main/DUT/cnx_master_in(5).ack
add wave -noupdate -radix hexadecimal /main/DUT/cnx_master_in(5).dat
add wave -noupdate /main/DUT/ddr0_wb_cyc_d
add wave -noupdate /main/DUT/ddr0_wb_cyc_fe
add wave -noupdate -divider {ddr0 ctrl wb1}
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_we_f_edge
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_stb_f_edge
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_cyc_r_edge
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_cyc_f_edge
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_stall_o
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_data_o
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_data_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_addr_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/wb_addr_d
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_underrun_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_mask_o
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_mask
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_full_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_en
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_empty_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_data
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_wr_count_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_rd_overflow_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_rd_full_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_rd_error_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_rd_en
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_rd_empty_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_rd_data_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_rd_count_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_cmd_instr
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_cmd_full_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_cmd_en_r_edge
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_cmd_en
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_cmd_empty_i
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_cmd_byte_addr
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_cmd_bl
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/ddr_burst_cnt
add wave -noupdate -radix hexadecimal /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wb_1/addr_shift
add wave -noupdate /main/DUT/cmp_ddr_ctrl_bank4/cmp_ddr3_ctrl_wrapper/gen_svec_bank4_64b_32b/cmp_ddr3_ctrl/memc4_wrapper_inst/memc4_mcb_raw_wrapper_inst/MCB_SYSRST
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29753000 ps} 0}
configure wave -namecolwidth 454
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {29677041 ps} {30055236 ps}
