onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Local Clock}
add wave -noupdate /tb_spec/u1/clk20_vcxo_i
add wave -noupdate -divider adc
add wave -noupdate /tb_spec/adc_dco_p_i
add wave -noupdate /tb_spec/adc_fr_p_i
add wave -noupdate /tb_spec/adc_outa_p_i(0)
add wave -noupdate /tb_spec/adc_outb_p_i(0)
add wave -noupdate /tb_spec/adc_outa_p_i(2)
add wave -noupdate /tb_spec/adc_outb_p_i(2)
add wave -noupdate /tb_spec/adc_outa_p_i
add wave -noupdate /tb_spec/adc_outb_p_i
add wave -noupdate -divider serdes
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_in_p
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_clk
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/fs_clk
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_out_raw
add wave -noupdate -radix binary /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_out_fr
add wave -noupdate -radix hexadecimal /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_out_data
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/bitslip_sreg
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_bitslip
add wave -noupdate /tb_spec/u1/cmp_fmc_adc_100ms_core/serdes_synced
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {760625 ps} 0}
configure wave -namecolwidth 366
configure wave -valuecolwidth 86
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
WaveRestoreZoom {759921 ps} {760982 ps}
