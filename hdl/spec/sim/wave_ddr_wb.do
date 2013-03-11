onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Local Clock}
add wave -noupdate /tb_spec/U1/clk20_vcxo_i
add wave -noupdate -divider L2P
add wave -noupdate /tb_spec/L2P_CLKp
add wave -noupdate /tb_spec/L2P_CLKn
add wave -noupdate -radix hexadecimal /tb_spec/L2P_DATA
add wave -noupdate -radix hexadecimal /tb_spec/L2P_DATA_32
add wave -noupdate /tb_spec/L2P_DFRAME
add wave -noupdate /tb_spec/L2P_VALID
add wave -noupdate /tb_spec/L2P_EDB
add wave -noupdate /tb_spec/L_WR_RDY
add wave -noupdate /tb_spec/P_RD_D_RDY
add wave -noupdate /tb_spec/L2P_RDY
add wave -noupdate /tb_spec/TX_ERROR
add wave -noupdate -divider P2L
add wave -noupdate /tb_spec/P2L_CLKp
add wave -noupdate /tb_spec/P2L_CLKn
add wave -noupdate -radix hexadecimal /tb_spec/P2L_DATA
add wave -noupdate -radix hexadecimal /tb_spec/P2L_DATA_32
add wave -noupdate /tb_spec/P2L_DFRAME
add wave -noupdate /tb_spec/P2L_VALID
add wave -noupdate /tb_spec/P2L_RDY
add wave -noupdate /tb_spec/P_WR_REQ
add wave -noupdate /tb_spec/P_WR_RDY
add wave -noupdate /tb_spec/RX_ERROR
add wave -noupdate /tb_spec/VC_RDY
add wave -noupdate -divider IRQ
add wave -noupdate -radix hexadecimal /tb_spec/GPIO
add wave -noupdate -divider {Wishbone DMA Interface}
add wave -noupdate /tb_spec/U1/sys_clk_125
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_dma_adr
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_dma_dat_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_dma_dat_o
add wave -noupdate /tb_spec/U1/wb_dma_sel
add wave -noupdate /tb_spec/U1/wb_dma_cyc
add wave -noupdate /tb_spec/U1/wb_dma_stb
add wave -noupdate /tb_spec/U1/wb_dma_we
add wave -noupdate /tb_spec/U1/wb_dma_ack
add wave -noupdate /tb_spec/U1/wb_dma_stall
add wave -noupdate -divider {DDR interface (dma)}
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_underrun_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_mask
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_error_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_en
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_empty_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_data
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_count_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_wr_clk_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_overflow_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_error_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_en
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_empty_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_data_i
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_count_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_rd_clk_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_instr_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_instr
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_en_r_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_en_d
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_en
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_empty_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_clk_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_byte_addr
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_cmd_bl
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_1/ddr_burst_cnt
add wave -noupdate -divider {Wishbone ADC to DDR}
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_adr
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_dat_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_sel
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_cyc
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_stb
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_we
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_ack
add wave -noupdate -radix hexadecimal /tb_spec/U1/wb_ddr_stall
add wave -noupdate -divider {DDR interface (adc)}
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_underrun_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_mask_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_mask
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_error_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_en
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_empty_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_data
add wave -noupdate -radix decimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_count_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_clk_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_overflow_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_error_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_en
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_empty_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_data_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_count_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_clk_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_instr_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_instr
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_en_r_edge
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_en_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_en_d
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_en
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_empty_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_clk_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_byte_addr
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_bl_o
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_bl
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_burst_cnt
add wave -noupdate -divider {Wishbone CSR master}
add wave -noupdate -divider {Wishbone CSR slaves}
add wave -noupdate -radix hexadecimal /tb_spec/U1/sys_clk_125
add wave -noupdate -divider IOs
add wave -noupdate /tb_spec/LED_RED
add wave -noupdate /tb_spec/LED_GREEN
add wave -noupdate -divider {FMC SPI}
add wave -noupdate /tb_spec/spi_din_i
add wave -noupdate /tb_spec/spi_dout_o
add wave -noupdate /tb_spec/spi_sck_o
add wave -noupdate /tb_spec/spi_cs_adc_n_o
add wave -noupdate /tb_spec/spi_cs_dac1_n_o
add wave -noupdate /tb_spec/spi_cs_dac2_n_o
add wave -noupdate /tb_spec/spi_cs_dac3_n_o
add wave -noupdate /tb_spec/spi_cs_dac4_n_o
add wave -noupdate -divider {FMC I2C}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34162884 ps} 0}
configure wave -namecolwidth 464
configure wave -valuecolwidth 120
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
WaveRestoreZoom {24261691 ps} {49099641 ps}
