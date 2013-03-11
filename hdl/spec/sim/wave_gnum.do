onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spec/RSTOUT18n
add wave -noupdate /tb_spec/U1/ddr3_calib_done
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/des_pd_valid
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/des_pd_dframe
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/des_pd_data
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/arb_ser_valid
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/arb_ser_dframe
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/arb_ser_data
add wave -noupdate -divider {DDR ADC}
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_instr_o
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_bl_o
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_byte_addr_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_empty_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_en_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_data_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_cyc_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_stb_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_we_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_addr_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_data_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_data_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_ack_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_stall_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_cyc_f_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_cyc_r_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_stb_f_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/wb_we_f_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_burst_cnt
add wave -noupdate -divider {DDR GNUM}
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_burst_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_bl_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_byte_addr_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_instr_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_empty_i
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_count_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_data_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_empty_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_ack_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_addr_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_clk_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_cyc_f_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_cyc_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_cyc_r_edge
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_data_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_data_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_stall_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_stb_f_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_stb_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_we_f_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/wb_we_i
add wave -noupdate -divider {P2L DMA master}
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/p2l_dma_current_state
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_carrier_addr_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_done_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_done_t
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_error_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_host_addr_l_i
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_len_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_start_next_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/dma_ctrl_start_p2l_i
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/p2l_data_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/pd_pdm_data_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/pd_pdm_data_last_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/pd_pdm_data_valid_i
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/pd_pdm_hdr_length_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/pd_pdm_hdr_start_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/pd_pdm_master_cpld_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/pd_pdm_master_cpln_i
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/l2p_len_header
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/is_next_item
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_attrib_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_carrier_addr_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_host_addr_h_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_host_addr_l_o
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_len_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_next_h_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_next_l_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_p2l_dma_master/next_item_valid_o
add wave -noupdate -divider {L2P DMA master}
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_current_state
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/target_addr_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/dma_length_cnt
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/addr_fifo_wr
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/addr_fifo_full
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/addr_fifo_din
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/addr_fifo_valid
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/addr_fifo_rd
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/addr_fifo_empty
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/addr_fifo_dout
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_clk_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_cyc_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_adr_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_stb_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_stall_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_dat_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_dma_ack_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/data_fifo_wr
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/data_fifo_full
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/data_fifo_din
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/data_fifo_empty
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/data_fifo_rd
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/data_fifo_valid
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/data_fifo_dout
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/wb_ack_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/wb_read_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_len_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_data_cnt
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/l2p_last_packet
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/ldm_arb_dframe_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/ldm_arb_valid_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/ldm_arb_data_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/ldm_arb_req_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_l2p_dma_master/arb_ldm_gnt_i
add wave -noupdate -divider {DMA controller}
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl_current_state
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_cstart_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_hstartl_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_hstarth_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_len_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_nextl_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_nexth_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_attrib_reg
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_nextl_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_nexth_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_len_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_hstartl_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_hstarth_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_cstart_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_attrib_load
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_done_irq
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_error_irq
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl_start_l2p_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl_start_next_o
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_ctrl_start_p2l_o
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/dma_len_reg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_attrib_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_carrier_addr_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_host_addr_h_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_host_addr_l_i
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_len_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_next_h_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_next_l_i
add wave -noupdate /tb_spec/U1/cmp_gn4124_core/cmp_dma_controller/next_item_valid_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30090961 ps} 0} {{Cursor 2} {22107797 ps} 0}
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
WaveRestoreZoom {22026423 ps} {22191901 ps}
