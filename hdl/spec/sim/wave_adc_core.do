onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spec/RSTOUT18n
add wave -noupdate -radix hexadecimal -childformat {{/tb_spec/ADC_DATA(0) -radix hexadecimal} {/tb_spec/ADC_DATA(1) -radix hexadecimal} {/tb_spec/ADC_DATA(2) -radix hexadecimal} {/tb_spec/ADC_DATA(3) -radix hexadecimal}} -expand -subitemconfig {/tb_spec/ADC_DATA(0) {-height 17 -radix hexadecimal} /tb_spec/ADC_DATA(1) {-height 17 -radix hexadecimal} /tb_spec/ADC_DATA(2) {-height 17 -radix hexadecimal} /tb_spec/ADC_DATA(3) {-height 17 -radix hexadecimal}} /tb_spec/ADC_DATA
add wave -noupdate -divider {adc core}
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sys_clk_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sys_rst_n_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_adr_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_dat_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_dat_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_cyc_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_sel_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_stb_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_we_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_csr_ack_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_clk_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_adr_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_dat_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_sel_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_stb_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_we_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_cyc_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_ack_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_stall_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/ext_trigger_p_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/ext_trigger_n_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_dco_p_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_dco_n_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_fr_p_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_fr_n_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_outa_p_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_outa_n_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_outb_p_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/adc_outb_n_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_dac_clr_n_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_led_acq_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_led_trig_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_ssr_ch1_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_ssr_ch2_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_ssr_ch3_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_ssr_ch4_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gpio_si570_oe_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sys_rst
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fs_rst
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fs_rst_n
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dco_clk
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/clk_fb
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/locked_in
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/locked_out
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_clk
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fs_clk
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fs_clk_buf
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_in_p
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_in_n
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_out_raw
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_out_data
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_out_data_d
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/data_calibr_in
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/offset_calibr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gain_calibr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/data_calibr_out
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_out_fr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_auto_bitslip
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_man_bitslip
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_bitslip
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/serdes_synced
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/bitslip_sreg
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/ext_trig_a
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/ext_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/int_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/int_trig_sel
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/int_trig_thres
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/int_trig_data
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/int_trig_over_thres_d
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/int_trig_over_thres
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/hw_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/hw_trig_t
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/hw_trig_sel
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/hw_trig_en
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sw_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sw_trig_t
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sw_trig_en
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_delay
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_delay_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_d
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_align
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/decim_factor
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/decim_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/decim_en
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_din
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_dout
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_empty
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_full
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_wr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_rd
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_valid
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/sync_fifo_dreq
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/gain_calibr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/offset_calibr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_fsm_current_state
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_fsm_state
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fsm_cmd
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/fsm_cmd_wr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_start
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_stop
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_end
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_in_pre_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_in_post_trig
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/samples_wr_en
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/pre_trig_value
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/pre_trig_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/pre_trig_done
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/post_trig_value
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/post_trig_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/post_trig_done
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/samples_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_value
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_done
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/shots_decr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/single_shot
add wave -noupdate -divider {dpram wr}
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/multishot_buffer_sel
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_addra_cnt
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_addra_trig
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_addra_post_done
add wave -noupdate -divider {dpram 0}
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_dina
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_addra
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_wea
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_addrb
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram0_doutb
add wave -noupdate -divider {dpram 1}
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_dina
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_addra
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_wea
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_addrb
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram1_doutb
add wave -noupdate -divider {dpram rd}
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_dout
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_valid
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/dpram_valid_t
add wave -noupdate -divider {ddr fifo}
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_addr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_wr_en
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_wr
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_din
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_full
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_rd
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_dout
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_empty
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_valid
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_fifo_dreq
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/ram_addr_cnt
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/test_data_en
add wave -noupdate -divider {ddr wb}
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_cyc_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_stall_t
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_we_o
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_stb_o
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_dat_o
add wave -noupdate -radix unsigned /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_adr_o
add wave -noupdate /tb_spec/U1/cmp_fmc_adc_100Ms_core/wb_ddr_ack_i
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_led
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/trig_led_man
add wave -noupdate -radix hexadecimal /tb_spec/U1/cmp_fmc_adc_100Ms_core/acq_led_man
add wave -noupdate /tb_spec/RSTOUT18n
add wave -noupdate -radix hexadecimal -childformat {{/tb_spec/ADC_DATA(0) -radix hexadecimal} {/tb_spec/ADC_DATA(1) -radix hexadecimal} {/tb_spec/ADC_DATA(2) -radix hexadecimal} {/tb_spec/ADC_DATA(3) -radix hexadecimal}} -expand -subitemconfig {/tb_spec/ADC_DATA(0) {-radix hexadecimal} /tb_spec/ADC_DATA(1) {-radix hexadecimal} /tb_spec/ADC_DATA(2) {-radix hexadecimal} /tb_spec/ADC_DATA(3) {-radix hexadecimal}} /tb_spec/ADC_DATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20587606 ps} 0} {{Cursor 2} {47376100 ps} 0}
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
WaveRestoreZoom {20271883 ps} {20896118 ps}
