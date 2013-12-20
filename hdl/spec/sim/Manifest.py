target = "xilinx"
action = "simulation"

files = ["testbench/gn412x_bfm.vhd",
         "testbench/cmd_router.vhd",
         "testbench/textutil.vhd",
         "testbench/util.vhd",
         "testbench/tb_spec.vhd",
         "testbench/cmd_router1.vhd",
         "../../ip_cores/adc_sync_fifo.vhd",
         "../../ip_cores/multishot_dpram.vhd",
         "../../ip_cores/wb_ddr_fifo.vhd",
         "../../ip_cores/adc_serdes.vhd",
         "../../ip_cores/monostable/monostable_rtl.vhd",
         "../../ip_cores/ext_pulse_sync/ext_pulse_sync_rtl.vhd",
         "../../ip_cores/utils/utils_pkg.vhd"]

modules = { "local" : ["../rtl",
                       "../../adc/rtl",
                       "../../ip_cores/timetag_core/rtl",
                       "testbench",
                       "sim_models/2048Mb_ddr3"],
            "git" : ["git://ohwr.org/hdl-core-lib/general-cores.git::proposed_master",
                     "git://ohwr.org/hdl-core-lib/ddr3-sp6-core.git::spec_bank3_64b_32b",
                     "git://ohwr.org/hdl-core-lib/gn4124-core.git::master"]}

fetchto="../../ip_cores"
