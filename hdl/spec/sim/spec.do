vsim -novopt -t 1ps tb_spec
log -r /*
##do wave_serdes.do
do wave_wb_buses.do
##do wave_datapath.do
##do wave_multishot.do
##do wave_onewire.do
##do wave_adc_core.do
##do wave_gnum.do
##do wave_end_acq_irq.do

view wave
view transcript

run 50 us
##run 15000 ns
##run 25057 ns
##force -freeze sim:/tb_lambo/l2p_rdy 0 0 -cancel {80 ns}
##run 1 us


