onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_ack
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_adr
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_cyc
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_dat_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_dat_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_sel
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_stall
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_stb
add wave -noupdate -radix hexadecimal /tb_spec/u1/wbm_we
add wave -noupdate -divider {Wishbone CSR interface}
add wave -noupdate /tb_spec/u1/sys_clk_125
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_adr
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dat_o
add wave -noupdate /tb_spec/u1/wb_dat_i
add wave -noupdate /tb_spec/u1/wb_stb
add wave -noupdate /tb_spec/u1/wb_we
add wave -noupdate /tb_spec/u1/wb_sel
add wave -noupdate /tb_spec/u1/wb_cyc(10)
add wave -noupdate /tb_spec/u1/wb_stall(10)
add wave -noupdate /tb_spec/u1/wb_ack(10)
add wave -noupdate -divider onewire
add wave -noupdate -radix unsigned -subitemconfig {{/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[7]} {-radix unsigned} {/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[6]} {-radix unsigned} {/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[5]} {-radix unsigned} {/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[4]} {-radix unsigned} {/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[3]} {-radix unsigned} {/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[2]} {-radix unsigned} {/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[1]} {-radix unsigned} {/tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst[0]} {-radix unsigned}} /tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/t_rst
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/cnt
add wave -noupdate /tb_spec/u1/one_wire_b
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/owr_pwren_o(0)
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/owr_en_o(0)
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/owr_i(0)
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/clk_sys_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/rst_n_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_cyc_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_sel_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_stb_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_we_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_adr_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_dat_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_dat_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_ack_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/wb_int_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/bus_wen
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/bus_ren
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_onewire/rst
add wave -noupdate /tb_spec/u1/cmp_fmc_onewire/wrapped_1wire/pls
add wave -noupdate -divider l2p
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/wb_ack_cnt
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/wb_read_cnt
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/dma_ctrl_start_l2p_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/dma_ctrl_len_i
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_last_packet
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_data_cnt
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_len_header
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_len_cnt
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_current_state
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/cmp_l2p_dma_master/dma_ctrl_done_o
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl_current_state
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/ldm_arb_data
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/ldm_arb_dframe
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/ldm_arb_req
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/ldm_arb_valid
add wave -noupdate -divider p2l
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/cmp_p2l_dma_master/p2l_dma_current_state
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_p2l_dma_master/l2p_len_cnt
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/cmp_p2l_dma_master/to_wb_fifo_din
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/cmp_p2l_dma_master/to_wb_fifo_wr
add wave -noupdate -divider {GN4124 LOCAL BUS}
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/l2p_data_o
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/l2p_dframe_o
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/l2p_valid_o
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/l2p_edb_o
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/l_wr_rdy_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_gn4124_core/p2l_data_i
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/p2l_dframe_i
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/p2l_rdy_o
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/p2l_valid_i
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/p_rd_d_rdy_i
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/p_wr_rdy_o
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/p_wr_req_i
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/tx_error_i
add wave -noupdate /tb_spec/u1/cmp_gn4124_core/vc_rdy_i
add wave -noupdate -divider {gennum global}
add wave -noupdate -expand /tb_spec/u1/irq_sources
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15313175 ps} 0} {{Cursor 2} {25032000 ps} 0}
configure wave -namecolwidth 496
configure wave -valuecolwidth 172
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
configure wave -timelineunits ns
update
WaveRestoreZoom {13598596 ps} {13854503 ps}
