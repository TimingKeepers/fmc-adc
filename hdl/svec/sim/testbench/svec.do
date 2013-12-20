vsim -novopt -t 1ps main
log -r /*
set StdArithNoWarnings 1
set NumericStdNoWarnings 1

#view wave
#view transcript
#do wave_interrupt.do
do wave_ddr.do
radix -hexadecimal

run 50 us



