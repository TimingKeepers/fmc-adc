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
add wave -noupdate -divider Interrupt
add wave -noupdate /main/DUT/trig_p(0)
add wave -noupdate /main/DUT/acq_end_irq_p(0)
add wave -noupdate /main/DUT/irq_to_vme
add wave -noupdate /main/DUT/irq_to_vme_t
add wave -noupdate /main/DUT/irq_to_vme_sync
add wave -noupdate -expand /main/DUT/vme_irq_n_o
add wave -noupdate -divider {fmc 0}
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/fs_clk
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/locked_out
add wave -noupdate /main/adc0_dco_n
add wave -noupdate /main/adc0_dco_p
add wave -noupdate /main/adc0_fr_n
add wave -noupdate /main/adc0_fr_p
add wave -noupdate /main/adc0_outa_n
add wave -noupdate /main/adc0_outa_p
add wave -noupdate /main/adc0_outb_n
add wave -noupdate /main/adc0_outb_p
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/serdes_synced
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/acq_fsm_current_state
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/fsm_cmd
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/acq_start
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/acq_stop
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/acq_trig
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/shots_cnt
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/pre_trig_cnt
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/pre_trig_done
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/post_trig_cnt
add wave -noupdate /main/DUT/cmp_fmc_adc_mezzanine_0/cmp_fmc_adc_100Ms_core/post_trig_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30800835 ps} 0}
configure wave -namecolwidth 557
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
WaveRestoreZoom {30305454 ps} {31619616 ps}
