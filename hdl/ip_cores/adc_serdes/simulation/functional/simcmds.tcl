
# file: simcmds.tcl

# create the simulation script
vcd dumpfile isim.vcd
vcd dumpvars -m /adc_serdes_tb -l 0
run 50000ns
quit

