onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {ACQ FSM}
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_fsm_current_state
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_start
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_trig
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_in_pre_trig
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_in_post_trig
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_end
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/acq_stop
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/samples_wr_en
add wave -noupdate -divider {SYNC FIFO}
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_dout
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/sync_fifo_valid
add wave -noupdate -divider {PRE-TRIG COUNTER}
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/pre_trig_cnt
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/pre_trig_done
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/pre_trig_value
add wave -noupdate -divider {POST-TRIG COUNTER}
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/post_trig_cnt
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/post_trig_done
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/post_trig_value
add wave -noupdate -divider {SHOT COUNTER}
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_value
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/single_shot
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_decr
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_cnt
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/multishot_buffer_sel
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/shots_done
add wave -noupdate -divider MULTISHOT
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram_addra_cnt
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram0_addra
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram0_wea
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram0_dina
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram1_addra
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram1_wea
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram1_dina
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram_addra_post_done
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram_addra_trig
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram0_addrb
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram0_doutb
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram1_addrb
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram1_doutb
add wave -noupdate -radix unsigned /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram_addrb_cnt
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram_dout
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram_valid
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/dpram_valid_t
add wave -noupdate -divider {WB FIFO}
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_wr_en
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_wr
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_din
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_full
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_stall_t
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_rd
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_dout
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_valid
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_fifo_empty
add wave -noupdate -divider {WB BUS}
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_clk_i
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_cyc_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_stb_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_we_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_adr_o
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_dat_o
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_ack_i
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/wb_ddr_stall_i
add wave -noupdate -divider {DDR CTRL}
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_bl
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_byte_addr
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_en
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_cmd_full
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_ddr_ctrl/p0_wr_data
add wave -noupdate /tb_spec/u1/cmp_ddr_ctrl/p0_wr_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13739679 ps} 0}
configure wave -namecolwidth 422
configure wave -valuecolwidth 156
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
WaveRestoreZoom {13313948 ps} {14199900 ps}
