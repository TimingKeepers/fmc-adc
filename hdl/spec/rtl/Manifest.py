files = [
    "spec_top_fmc_adc_100Ms.vhd",
    "carrier_csr.vhd",
    "utc_core_regs.vhd",
    "utc_core.vhd",
    "irq_controller_regs.vhd",
    "irq_controller.vhd"];

modules = {
    "local" : "../../adc/rtl",
    "svn" : [ "http://svn.ohwr.org/ddr3-sp6-core/trunk/hdl",
              "http://svn.ohwr.org/gn4124-core/trunk/hdl/gn4124core/rtl",
              "http://svn.ohwr.org/gn4124-core/trunk/hdl/common/rtl"],
    "git" : "git://ohwr.org/hdl-core-lib/general-cores.git"}

fetchto="../ip_cores"
