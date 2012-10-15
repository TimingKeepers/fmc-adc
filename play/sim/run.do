vlib work

vcom -explicit -93 "../hdl/design/led_ctrl.vhd"
vcom -explicit -93 "../hdl/design/irq_controller_regs.vhd"
vcom -explicit -93 "../hdl/design/irq_controller.vhd"
vcom -explicit -93 "../hdl/design/addr_dec.vhd"
vcom -explicit -93 "../hdl/tb/testbench.vhd"

vsim -voptargs="+acc" -debugdb -lib work work.testbench

log -r /*

# add wave *
do wave.do

run 4 us
