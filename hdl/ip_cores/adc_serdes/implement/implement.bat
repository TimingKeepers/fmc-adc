
REM file: implement.bat

REM -----------------------------------------------------------------------------
REM  Script to synthesize and implement the RTL provided for the clocking wizard
REM -----------------------------------------------------------------------------

REM Clean up the results directory
rmdir /S /Q results
mkdir results

REM Copy unisim_comp.v file to results directory
copy %XILINX%\verilog\src\iSE\unisim_comp.v .\results\

REM Synthesize the Verilog Wrapper Files
echo 'Synthesizing SelectIO Wizard design with XST'
xst -ifn xst.scr
copy adc_serdes_exdes.ngc results\

REM  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
copy ..\..\adc_serdes.ucf results\

cd results

echo 'Running ngdbuild'
ngdbuild -uc adc_serdes.ucf adc_serdes_exdes

echo 'Running map'
map -timing adc_serdes_exdes -o mapped.ncd

echo 'Running par'
par -w mapped.ncd routed mapped.pcf

echo 'Running trce'
trce -e 10 routed -o routed mapped.pcf

echo 'Running design through bitgen'
bitgen -w routed.ncd routed.bit mapped.pcf

echo 'Running netgen to create gate level model for the clocking wizard example design'
netgen -ofmt vhdl -sim -tm adc_serdes_exdes -w routed.ncd routed.vhd
cd ..

