target = "xilinx"
action = "simulation"

files = ["testbench/gn412x_bfm.vhd",
         "testbench/cmd_router.vhd",
         "testbench/textutil.vhd",
         "testbench/util.vhd",
         "testbench/tb_spec.vhd",
         "testbench/cmd_router1.vhd",
         "../ip_cores/adc_sync_fifo.vhd",
         "../ip_cores/multishot_dpram.vhd",
         "../ip_cores/wb_ddr_fifo.vhd",
         "../ip_cores/adc_serdes.vhd",
         "../../../../monostable/monostable_rtl.vhd",
         "../../../../ext_pulse_sync/ext_pulse_sync_rtl.vhd",
         "../../../../utils/utils_pkg.vhd"]

modules = { "local" : ["../rtl",
                       "testbench",
                       "sim_models/2048Mb_ddr3"]}
