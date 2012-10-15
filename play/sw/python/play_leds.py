#!/usr/bin/env python

# Copyright CERN, 2011
# Author: Theodor Stana <t.stana@cern.ch>
# Licence: GPL v2 or later.

# Import system modules
import sys
import time
import os

# Add common modules and libraries location to path
#sys.path.append('../')
sys.path.append('../../../../')
sys.path.append('../../../../gnurabbit/python/')
sys.path.append('../../../../common/')

# Import common modules
from ptsexcept import *
import rr
from csr import *
import gn4124

'''
PLAY project

Playing with the connection-panel LEDs on the FmcAdc100m14b4cha board.
'''

#def wr()
#reg = int(sys.argv[1])
#val = int(sys.argv[2])

#regs.wr_reg(reg,val)


def main():
  
  # Define register constants
  IRQ_MULTI   = 0x0
  IRQ_SRC     = 0x4
  IRQ_EN_MASK = 0x8

  # Create a SPEC object using RawRabbit driver
  spec = rr.Gennum()
  spec.irqena()

  # Define the registers' base addresses
  irq_regs = CCSR(spec, 0)
  led_regs = CCSR(spec, 16)
  
  # Enable interrupt on LED write
  irq_regs.wr_reg(IRQ_EN_MASK, 0x3)
  msk = irq_regs.rd_reg(IRQ_EN_MASK)

  print "Mask: 0x%x" % msk
  
  act = ''
  while (act != "q"):
    act = raw_input("(w)rite/(r)ead/(q)uit? ")
    act = act.lower()

    if (act == "w"):
      print "WRITE"
      reg = input("reg? ")
      val = input("val? ")
      led_regs.wr_reg(reg,val)
      time.sleep(0.002)      
      spec.irqwait()
      print "interrupt!"
#      multi = irq_regs.rd_reg(IRQ_MULTI)
#      print "multi: 0x%x" % multi
#      msk = irq_regs.rd_reg(IRQ_EN_MASK)
#      print "Mask: 0x%x" % msk
      src = irq_regs.rd_reg(IRQ_SRC)
      print "src : 0x%x" % src
      
      print "wrote to LED %d" % src
      val = led_regs.rd_reg(reg)
      print "value 0x%x" % val
      
      irq_regs.wr_reg(IRQ_SRC, src)
      
    elif (act == "r"):
      print "READ"
      reg = input("reg? ")
      val = led_regs.rd_reg(reg)
      # print "register: 0x%1x" % reg
      print "value: 0x%1x" % val
    
    elif (act == "q"):
      print "quitting"
    
    else:
      print "Wrong input!!"
    
if __name__ == "__main__": 
  main()
  
