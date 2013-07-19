onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spec/RSTOUT18n
add wave -noupdate -radix hexadecimal -childformat {{/tb_spec/ADC_DATA(0) -radix hexadecimal} {/tb_spec/ADC_DATA(1) -radix hexadecimal} {/tb_spec/ADC_DATA(2) -radix hexadecimal} {/tb_spec/ADC_DATA(3) -radix hexadecimal}} -expand -subitemconfig {/tb_spec/ADC_DATA(0) {-height 17 -radix hexadecimal} /tb_spec/ADC_DATA(1) {-height 17 -radix hexadecimal} /tb_spec/ADC_DATA(2) {-height 17 -radix hexadecimal} /tb_spec/ADC_DATA(3) {-height 17 -radix hexadecimal}} /tb_spec/ADC_DATA
add wave -noupdate -divider {adc core}
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sys_clk_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sys_rst_n_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_clk_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_adr_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_dat_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_sel_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_stb_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_we_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_cyc_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_ack_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_stall_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_d
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_align
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/decim_factor
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/decim_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/decim_en
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_fsm_current_state
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_fsm_state
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fsm_cmd
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fsm_cmd_wr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_start
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_stop
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_in_pre_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_in_post_trig
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_end
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_end_p_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/samples_wr_en
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_value
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_done
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_decr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/single_shot
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_valid
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/pre_trig_done
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/pre_trig_cnt
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/post_trig_done
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/post_trig_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_addr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_din
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_dout
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_empty
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_full
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_wr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_rd
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_valid
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_dreq
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_wr_en
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/ram_addr_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_count_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_wr_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_rd_full_i
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/cmp_ddr3_ctrl_wb_0/ddr_cmd_full_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_stall_t
add wave -noupdate -divider Multi-shot
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/samples_wr_en
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/multishot_buffer_sel
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_addra_cnt
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_wea
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_addra
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_dina
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_wea
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_addra
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_dina
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_addra_trig
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_addra_post_done
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_addrb_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_addrb
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_doutb
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_addrb
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_doutb
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_valid_t
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_valid
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_dout
add wave -noupdate -divider {ddr core}
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/p0_wr_full
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/p0_wr_en
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/p0_wr_empty
add wave -noupdate /tb_spec/U1/cmp_ddr_ctrl/p0_wr_count
add wave -noupdate -divider irq
add wave -noupdate /tb_spec/U1/trigger_p
add wave -noupdate /tb_spec/U1/acq_end_p
add wave -noupdate /tb_spec/U1/acq_end_irq_p
add wave -noupdate /tb_spec/U1/acq_end
add wave -noupdate /tb_spec/U1/ddr_wr_fifo_empty_p
add wave -noupdate /tb_spec/U1/ddr_wr_fifo_empty_d
add wave -noupdate /tb_spec/U1/ddr_wr_fifo_empty
add wave -noupdate /tb_spec/U1/irq_sources(3)
add wave -noupdate /tb_spec/U1/irq_to_gn4124
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27568195 ps} 0} {{Cursor 2} {15922570 ps} 0}
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
WaveRestoreZoom {15798791 ps} {16099433 ps}
