files = [
    "spec_top_fmc_adc_100Ms.vhd",
    "fmc_adc_100Ms_csr.vhd",
    "../spec_top_fmc_adc_100Ms.ucf"];

modules = {
    "local" : "../../adc/rtl",
    "svn" : [ "http://svn.ohwr.org/DDRCONTROLLER",
              "http://svn.ohwr.org/GENNUMCORE"],
    "git" : "git://ohwr.org/hdl-core-lib/general-cores.git"}

fetchto="../ip_cores"
