files = [
    "spec_top_fmc_adc_100Ms.vhd",
    "carrier_csr.vhd",
    "timetag_core_regs.vhd",
    "timetag_core.vhd",
    "irq_controller_regs.vhd",
    "irq_controller.vhd",
    "sdb_meta_pkg.vhd"];

modules = {
    "local" : "../../adc/rtl",
    "git" : ["git://ohwr.org/hdl-core-lib/general-cores.git::sdb_extension",
             "git://ohwr.org/hdl-core-lib/ddr3-sp6-core.git::spec_bank3_64b_32b",
             "git://ohwr.org/hdl-core-lib/gn4124-core.git::master"]}

fetchto="../ip_cores"
