onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_spec/u1/sys_clk_in
add wave -noupdate /tb_spec/u1/sys_clk_125
add wave -noupdate /tb_spec/u1/sys_clk_250
add wave -noupdate /tb_spec/u1/sys_clk_pll_locked
add wave -noupdate /tb_spec/u1/sys_rst
add wave -noupdate /tb_spec/u1/sys_rst_n
add wave -noupdate /tb_spec/u1/l_rst_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5600100 ps} 0}
configure wave -namecolwidth 389
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
WaveRestoreZoom {0 ps} {23100 ns}
