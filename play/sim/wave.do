onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/s_clk
add wave -noupdate /testbench/s_rst
add wave -noupdate -radix unsigned /testbench/s_wb_dat
add wave -noupdate /testbench/s_wb_we
add wave -noupdate -radix unsigned /testbench/s_irq
add wave -noupdate /testbench/s_irq_p
add wave -noupdate /testbench/s_leds_irq
add wave -noupdate /testbench/s_wb_stb
add wave -noupdate /testbench/s_wb_cyc
add wave -noupdate /testbench/s_ack
add wave -noupdate /testbench/s_leds
add wave -noupdate -height 16 /testbench/s_state
add wave -noupdate -radix hexadecimal /testbench/s_fsm_data
add wave -noupdate /testbench/s_fsm_ctrl
add wave -noupdate /testbench/s_fsm_act
add wave -noupdate -radix hexadecimal /testbench/s_wb_dat_i
add wave -noupdate -radix hexadecimal /testbench/s_wb_dat_o
add wave -noupdate -radix hexadecimal -childformat {{/testbench/s_wb_adr(31) -radix hexadecimal} {/testbench/s_wb_adr(30) -radix hexadecimal} {/testbench/s_wb_adr(29) -radix hexadecimal} {/testbench/s_wb_adr(28) -radix hexadecimal} {/testbench/s_wb_adr(27) -radix hexadecimal} {/testbench/s_wb_adr(26) -radix hexadecimal} {/testbench/s_wb_adr(25) -radix hexadecimal} {/testbench/s_wb_adr(24) -radix hexadecimal} {/testbench/s_wb_adr(23) -radix hexadecimal} {/testbench/s_wb_adr(22) -radix hexadecimal} {/testbench/s_wb_adr(21) -radix hexadecimal} {/testbench/s_wb_adr(20) -radix hexadecimal} {/testbench/s_wb_adr(19) -radix hexadecimal} {/testbench/s_wb_adr(18) -radix hexadecimal} {/testbench/s_wb_adr(17) -radix hexadecimal} {/testbench/s_wb_adr(16) -radix hexadecimal} {/testbench/s_wb_adr(15) -radix hexadecimal} {/testbench/s_wb_adr(14) -radix hexadecimal} {/testbench/s_wb_adr(13) -radix hexadecimal} {/testbench/s_wb_adr(12) -radix hexadecimal} {/testbench/s_wb_adr(11) -radix hexadecimal} {/testbench/s_wb_adr(10) -radix hexadecimal} {/testbench/s_wb_adr(9) -radix hexadecimal} {/testbench/s_wb_adr(8) -radix hexadecimal} {/testbench/s_wb_adr(7) -radix hexadecimal} {/testbench/s_wb_adr(6) -radix hexadecimal} {/testbench/s_wb_adr(5) -radix hexadecimal} {/testbench/s_wb_adr(4) -radix hexadecimal} {/testbench/s_wb_adr(3) -radix hexadecimal} {/testbench/s_wb_adr(2) -radix hexadecimal} {/testbench/s_wb_adr(1) -radix hexadecimal} {/testbench/s_wb_adr(0) -radix hexadecimal}} -subitemconfig {/testbench/s_wb_adr(31) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(30) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(29) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(28) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(27) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(26) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(25) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(24) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(23) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(22) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(21) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(20) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(19) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(18) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(17) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(16) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(15) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(14) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(13) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(12) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(11) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(10) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(9) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(8) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(7) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(6) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(5) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(4) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(3) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(2) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(1) {-height 13 -radix hexadecimal} /testbench/s_wb_adr(0) {-height 13 -radix hexadecimal}} /testbench/s_wb_adr
add wave -noupdate -divider {ADDRESS DECODER}
add wave -noupdate /testbench/cmp_addr_dec/cyc_i
add wave -noupdate /testbench/cmp_addr_dec/adr_i
add wave -noupdate -radix hexadecimal /testbench/cmp_addr_dec/dat_i
add wave -noupdate /testbench/cmp_addr_dec/ack_i
add wave -noupdate /testbench/cmp_addr_dec/cyc_o
add wave -noupdate /testbench/cmp_addr_dec/ack_o
add wave -noupdate -radix hexadecimal /testbench/cmp_addr_dec/dat_o
add wave -noupdate -divider LEDs
add wave -noupdate /testbench/uut/wb_cyc_i
add wave -noupdate /testbench/uut/wb_ack_o
add wave -noupdate /testbench/uut/irq_o
add wave -noupdate /testbench/uut/leds_o
add wave -noupdate /testbench/uut/s_ctrl_reg
add wave -noupdate /testbench/uut/s_dat
add wave -noupdate /testbench/uut/s_irq
add wave -noupdate -divider IRQ
add wave -noupdate -radix hexadecimal /testbench/cmp_irq_ctrl/irq_src_p_i
add wave -noupdate /testbench/cmp_irq_ctrl/irq_p_o
add wave -noupdate /testbench/cmp_irq_ctrl/wb_cyc_i
add wave -noupdate /testbench/cmp_irq_ctrl/wb_stb_i
add wave -noupdate /testbench/cmp_irq_ctrl/wb_we_i
add wave -noupdate /testbench/cmp_irq_ctrl/cmp_irq_controller_regs/rwaddr_reg
add wave -noupdate /testbench/cmp_irq_ctrl/wb_ack_o
add wave -noupdate -radix hexadecimal /testbench/cmp_irq_ctrl/irq_pending
add wave -noupdate -radix hexadecimal /testbench/cmp_irq_ctrl/irq_en_mask
add wave -noupdate -radix hexadecimal /testbench/cmp_irq_ctrl/irq_src_rst
add wave -noupdate /testbench/cmp_irq_ctrl/irq_src_rst_en
add wave -noupdate -radix hexadecimal /testbench/cmp_irq_ctrl/cmp_irq_controller_regs/irq_ctrl_src_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2394 ns} 0}
configure wave -namecolwidth 268
configure wave -valuecolwidth 116
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
WaveRestoreZoom {1007 ns} {3005 ns}
