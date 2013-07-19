vsim -novopt -t 1ps main
log -r /*
set StdArithNoWarnings 1
set NumericStdNoWarnings 1

#view wave
#view transcript
do wave.do
radix -hexadecimal

run 40 us



