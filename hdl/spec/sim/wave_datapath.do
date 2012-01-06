onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Wishbone CSR interface}
add wave -noupdate /tb_spec/u1/sys_clk_125
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_adr
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dat_o
add wave -noupdate /tb_spec/u1/wb_stb
add wave -noupdate /tb_spec/u1/wb_we
add wave -noupdate /tb_spec/u1/wb_sel
add wave -noupdate -divider trigger
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sw_trig_en
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sw_trig
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/trig
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/trig_d
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/trig_align
add wave -noupdate -divider {acq fsm}
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/post_trig_done
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_cnt
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_value
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_decr
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_done
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_fsm_current_state
add wave -noupdate -divider datapath
add wave -noupdate /tb_spec/u1/adc_dco_n_i
add wave -noupdate /tb_spec/u1/adc_dco_p_i
add wave -noupdate /tb_spec/u1/adc_fr_p_i
add wave -noupdate /tb_spec/u1/adc_outa_p_i(0)
add wave -noupdate /tb_spec/u1/adc_outb_p_i(0)
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_out_fr
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_out_data
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/locked_out
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/fs_clk
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/fs_rst_n
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_synced
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/decim_cnt
add wave -noupdate -radix decimal /tb_spec/u1/cmp_fmc_adc_100ms_core/decim_factor
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/decim_en
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_wr
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_din
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_full
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_dreq
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_dout
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_dout(48)
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_empty
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_rd
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_valid
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_out_data
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_wr
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_wr_en
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_din
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_full
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_dreq
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_rd
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_dout
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_empty
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_valid
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/ram_addr_cnt
add wave -noupdate -divider {adc to ddr WB}
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_ack_i
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_clk_i
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_cyc_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_dat_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_stb_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_we_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_adr_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_stall_i
add wave -noupdate -divider {ddr controller}
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/status_o(0)
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/wb0_clk_i
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/rst_n_i
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_wr_empty
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_ddr_ctrl/p0_wr_count
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_wr_full
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p0_wr_data
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_wr_en
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_bl
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_byte_addr
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_empty
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_full
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_en
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p1_cmd_bl
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p1_cmd_byte_addr
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_cmd_empty
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_cmd_en
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_cmd_full
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_rd_error
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_rd_overflow
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_rd_full
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p1_rd_count
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p1_rd_data
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_rd_empty
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_rd_en
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p1_wr_count
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p1_wr_data
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_wr_en
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p1_wr_full
add wave -noupdate -divider {ddr to gennum WB}
add wave -noupdate /tb_spec/u1/sys_clk_125
add wave -noupdate /tb_spec/u1/wb_dma_ack
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dma_adr
add wave -noupdate /tb_spec/u1/wb_dma_cyc
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dma_dat_i
add wave -noupdate -radix hexadecimal /tb_spec/u1/wb_dma_dat_o
add wave -noupdate /tb_spec/u1/wb_dma_stall
add wave -noupdate /tb_spec/u1/wb_dma_stb
add wave -noupdate /tb_spec/u1/wb_dma_we
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
WaveRestoreCursors {{Cursor 1} {1990664 ps} 0}
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
WaveRestoreZoom {0 ps} {34650 ns}
