target = "xilinx"
action = "synthesis"

syn_device = "xc6slx150t"
syn_grade = "-3"
syn_package = "fgg900"
syn_top = "spexi_top_fmc_adc_100Ms"
syn_project = "spexi_fmc_adc_100Ms.xise"

files = ["../spexi_v0_1.ucf",
         "../../ip_cores/adc_sync_fifo.ngc",
         "../../ip_cores/multishot_dpram.ngc",
         "../../ip_cores/wb_ddr_fifo.ngc",
         "../../ip_cores/adc_serdes.vhd",
         "../../ip_cores/monostable/monostable_rtl.vhd",
         "../../ip_cores/ext_pulse_sync/ext_pulse_sync_rtl.vhd",
         "../../ip_cores/utils/utils_pkg.vhd"]

modules = { "local" : ["../rtl",
                       "../../adc/rtl",
                       "../../ip_cores/timetag_core/rtl"],
            "git" : ["git://ohwr.org/hdl-core-lib/general-cores.git::proposed_master",
                     "git://ohwr.org/hdl-core-lib/ddr3-sp6-core.git::spec_bank3_64b_32b",
                     "git://ohwr.org/hdl-core-lib/gn4124-core.git::master"]}

fetchto="../../ip_cores"
