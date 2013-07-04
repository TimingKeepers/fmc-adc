target = "xilinx"
action = "synthesis"

syn_device = "xc6slx45t"
syn_grade = "-3"
syn_package = "fgg484"
syn_top = "spec_top_fmc_adc_100Ms"
syn_project = "spec_fmc_adc_100Ms.xise"

files = [
    "../spec_top_fmc_adc_100Ms.ucf",
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
            "git" : ["git://ohwr.org/hdl-core-lib/general-cores.git::sdb_extension",
                     "git://ohwr.org/hdl-core-lib/ddr3-sp6-core.git::spec_bank3_64b_32b",
                     "git://ohwr.org/hdl-core-lib/gn4124-core.git::master"]}

fetchto="../../ip_cores"
