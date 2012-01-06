onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Local Clock}
add wave -noupdate /tb_spec/u1/clk20_vcxo_i
add wave -noupdate -divider adc
add wave -noupdate /tb_spec/adc_dco_n_i
add wave -noupdate /tb_spec/adc_dco_p_i
add wave -noupdate /tb_spec/adc_fr_n_i
add wave -noupdate /tb_spec/adc_fr_p_i
add wave -noupdate /tb_spec/adc_outa_n_i
add wave -noupdate /tb_spec/adc_outa_p_i
add wave -noupdate /tb_spec/adc_outb_n_i
add wave -noupdate /tb_spec/adc_outb_p_i
add wave -noupdate -divider serdes
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/bitslip_sreg
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_bitslip
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_synced
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_clk
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/fs_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {510000 ps} 0}
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
WaveRestoreZoom {489238 ps} {495765 ps}
