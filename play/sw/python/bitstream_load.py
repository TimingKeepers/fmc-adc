#!   /usr/bin/env   python
#    coding: utf8

# Copyright CERN, 2011
# Author: Matthieu Cattin <matthieu.cattin@cern.ch>
# Licence: GPL v2 or later.
# Website: http://www.ohwr.org
# Last modifications: 10/5/2012

# Import system modules
import sys
import time
import os

# Add common modules and libraries location to path
sys.path.append('../../../')
sys.path.append('../../../gnurabbit/python/')
sys.path.append('../../../common/')

# Import common modules
from ptsexcept import *
import rr

# Import specific modules
from fmc_adc_spec import *


"""
Load firmware
"""

def main (default_directory='.'):

    # Constants declaration
    TEST_NB = 0
    #FMC_ADC_ADDR = '1a39:0004/1a39:0004@000B:0000'
    #FMC_ADC_BITSTREAM = '../firmwares/spec_fmcadc100m14b4cha.bin'
    #FMC_ADC_BITSTREAM = os.path.join(default_directory, FMC_ADC_BITSTREAM)
    EXPECTED_BITSTREAM_TYPE = 0x1

    FMC_ADC_BITSTREAM = sys.argv[1]


    start_test_time = time.time()
    print "\n================================================================================"
    print "==> Test%02d start\n" % TEST_NB

    # SPEC object declaration
    print "Loading hardware access library and opening device.\n"
    spec = rr.Gennum()

    # Bind SPEC object to FMC ADC card
    #for name, value in spec.parse_addr(FMC_ADC_ADDR).iteritems():
    #    print "%9s:0x%04X"%(name, value)

    #spec.bind(FMC_ADC_ADDR)

    # Load FMC ADC firmware
    print "Loading FMC ADC firmware: %s\n" % FMC_ADC_BITSTREAM
    spec.load_firmware(FMC_ADC_BITSTREAM)
    time.sleep(2)

    print "==> End of test%02d" % TEST_NB
    print "================================================================================"
    end_test_time = time.time()
    print "Test%02d elapsed time: %.2f seconds\n" % (TEST_NB, end_test_time-start_test_time)


if __name__ == '__main__' :
    main()
