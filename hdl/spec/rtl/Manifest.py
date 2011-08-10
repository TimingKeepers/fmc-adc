files = [
    "spec_top_fmc_adc_100Ms.vhd",
    "fmc_adc_100Ms_csr.vhd"];

modules = {
    "local" : "../../adc/rtl",
    "svn" : [ "http://svn.ohwr.org/ddr3-sp6-core/trunk/hdl/rtl",
              "http://svn.ohwr.org/gn4124-core/trunk/hdl/gn4124core/rtl",
              "http://svn.ohwr.org/gn4124-core/trunk/hdl/common/rtl"],
    "git" : "git://ohwr.org/hdl-core-lib/general-cores.git"}

fetchto="../ip_cores"
