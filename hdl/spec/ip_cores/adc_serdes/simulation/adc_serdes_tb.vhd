
-- file: adc_serdes_tb.vhd
-- (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

------------------------------------------------------------------------------
-- SelectIO wizard demonstration testbench
------------------------------------------------------------------------------
-- This demonstration testbench instantiates the example design for the 
--   SelectIO wizard. 
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

library work;
use work.all;

entity adc_serdes_tb is
end adc_serdes_tb;

architecture test of adc_serdes_tb is

component adc_serdes_exdes
generic (
  -- Clock -> q modeling delay
  TCQ        : time    := 100 ps;
  -- width of the data for the system
  sys_w      : integer := 9;
  -- width of the data for the device
  dev_w      : integer := 72;
  -- width of the address for the memory
  add_w      : integer := 10;
  -- depth of the memory
  add_l      : integer := 1024);
port (
  -- Memory interface
  ADDRESS_USER             : in    std_logic_vector(add_w-1 downto 0);
  DATA_IN_USER             : in    std_logic_vector(dev_w-1 downto 0);
  DATA_OUT_USER            : out   std_logic_vector(dev_w-1 downto 0);
  ENABLE_USER              : in    std_logic;
  WRITE_USER               : in    std_logic;
  ENABLE_DEVICE            : in    std_logic;
  -- From the system into the device
  DATA_IN_FROM_PINS_P      : in    std_logic_vector(sys_w-1 downto 0);
  DATA_IN_FROM_PINS_N      : in    std_logic_vector(sys_w-1 downto 0);
  CLK_IN                   : in    std_logic;
  BITSLIP                  : in    std_logic;
  CLK_RESET                : in    std_logic;
  IO_RESET                 : in    std_logic);
end component;
  constant TCQ             : time    := 100 ps;
  constant clk_per         : time    :=  10 ns; -- 100 MHz clk
  constant sys_w           : integer := 9;
  constant dev_w           : integer := 72;
  constant add_w           : integer := 10;
  constant num_serial_bits : integer := dev_w/sys_w;
  constant data_rate       : integer := 1;
  signal   ADDRESS_USER    : std_logic_vector(add_w-1 downto 0) := (others => '0');
  signal   DATA_IN_USER    : std_logic_vector(dev_w-1 downto 0) := (others => '0');
  signal   DATA_OUT_USER   : std_logic_vector(dev_w-1 downto 0);
  signal   ENABLE_USER     : std_logic;
  signal   WRITE_USER      : std_logic;
  signal   ENABLE_DEVICE   : std_logic;
  -- From the system into the device
  signal   DATA_IN_FROM_PINS   : std_logic_vector(sys_w-1 downto 0);
  signal   DATA_IN_FROM_PINS_P : std_logic_vector(sys_w-1 downto 0);
  signal   DATA_IN_FROM_PINS_N : std_logic_vector(sys_w-1 downto 0);
  signal   CLK_IN             : std_logic := '0';
  signal   BITSLIP            : std_logic := '0';
  signal   CLK_RESET          : std_logic;
  signal   IO_RESET           : std_logic;


begin

  -- Any aliases

   DATA_IN_FROM_PINS_P <=  DATA_IN_FROM_PINS;
   DATA_IN_FROM_PINS_N <=  not (DATA_IN_FROM_PINS);

  -- clock generator- 100 MHz simulation clock
  --------------------------------------------
  process begin
    wait for (clk_per/2);
    CLK_IN <= not CLK_IN;
  end process;

  -- Test sequence
  process begin
    DATA_IN_FROM_PINS <= (others => '0');
    -- reset the logic
    CLK_RESET   <= '1';
    IO_RESET    <= '1';
    CLK_RESET   <= '0';
    wait for (18*clk_per);
    WRITE_USER    <= '0';
    ENABLE_USER   <= '0';
    -- start up the io
    IO_RESET      <= '0';
    wait for (8*clk_per);
    ENABLE_DEVICE <= '1';
    -- Drive data onto the pins
    DATA_IN_FROM_PINS <= (others => '0');
    for ii in 0 to 255 loop
      ADDRESS_USER <= conv_std_logic_vector(ii, add_w);
      wait for 0 ns;
      DATA_IN_FROM_PINS <= conv_std_logic_vector(ii, sys_w) ;
      wait for (clk_per/data_rate);
    end loop;
    report "Simulation Stopped." severity failure;
    wait;
  end process;

  -- Instantiation of the example design

  dut : adc_serdes_exdes
  generic map
  (TCQ   => 100 ps,
   sys_w => 9,
   dev_w => 72,
   add_w => 10)
  port map
  (--Memory interface
   ADDRESS_USER              => ADDRESS_USER,
   DATA_IN_USER              => DATA_IN_USER,
   DATA_OUT_USER             => DATA_OUT_USER,
   ENABLE_USER               => ENABLE_USER,
   WRITE_USER                => WRITE_USER,
   ENABLE_DEVICE             => ENABLE_DEVICE,
   -- From the system into the device
   DATA_IN_FROM_PINS_P       => DATA_IN_FROM_PINS_P,
   DATA_IN_FROM_PINS_N       => DATA_IN_FROM_PINS_N,
   CLK_IN                    => CLK_IN,
   BITSLIP                   => BITSLIP,
   CLK_RESET                 => CLK_RESET,
   IO_RESET                  => IO_RESET);
end test;



