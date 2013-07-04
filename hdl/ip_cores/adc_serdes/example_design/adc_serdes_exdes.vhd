
-- file: adc_serdes_exdes.vhd
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
-- SelectIO wizard example design
------------------------------------------------------------------------------
-- This example design instantiates the IO circuitry
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library unisim;
use unisim.vcomponents.all;

entity adc_serdes_exdes is
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
end adc_serdes_exdes;

architecture xilinx of adc_serdes_exdes is

component adc_serdes is
generic
 (-- width of the data for the system
  sys_w       : integer := 9;
  -- width of the data for the device
  dev_w       : integer := 72);
port
 (
  -- From the system into the device
  DATA_IN_FROM_PINS_P     : in    std_logic_vector(sys_w-1 downto 0);
  DATA_IN_FROM_PINS_N     : in    std_logic_vector(sys_w-1 downto 0);
  DATA_IN_TO_DEVICE       : out   std_logic_vector(dev_w-1 downto 0);

  BITSLIP                 : in    std_logic;
-- Clock and reset signals
  CLK_IN                  : in    std_logic;                    -- Fast clock from PLL/MMCM 
  CLK_DIV_IN              : in    std_logic;                    -- Slow clock from PLL/MMCM
  LOCKED_IN               : in    std_logic;
  LOCKED_OUT              : out   std_logic;
  CLK_RESET               : in    std_logic;                    -- Reset signal for Clock circuit
  IO_RESET                : in    std_logic);                   -- Reset signal for IO circuit
end component;

   constant num_serial_bits    : integer := dev_w/sys_w;
            -- connection between ram and io circuit
   signal DATA_IN_TO_DEVICE    : std_logic_vector(dev_w-1 downto 0);
   signal write_device         : std_logic :=  '1';
   signal address_device       : std_logic_vector(add_w-1 downto 0) := (others=>'0');
   type ram_type is array (0 to add_l-1) of std_logic_vector(dev_w-1 downto 0);
   shared variable ram_array   : ram_type;
   signal clkfbout             : std_logic;
   signal clk_in_pll           : std_logic;
   signal LOCKED_IN            : std_logic;
   signal LOCKED_OUT           : std_logic;
   signal clk_div_in_int       : std_logic;
   signal CLK_DIV_IN           : std_logic;
begin

   -- set up the fabric PLL_BASE to drive the BUFPLL
   pll_base_inst : PLL_BASE
    generic map (
      BANDWIDTH             => "OPTIMIZED",
      CLK_FEEDBACK          => "CLKFBOUT",
      COMPENSATION          => "SYSTEM_SYNCHRONOUS",
      DIVCLK_DIVIDE         => 1,
      CLKFBOUT_MULT         => 4,
      CLKFBOUT_PHASE        => 0.000,
      CLKOUT0_DIVIDE        => 4,
      CLKOUT0_PHASE         => 0.000,
      CLKOUT0_DUTY_CYCLE    => 0.500,
      CLKOUT1_DIVIDE        => 4*num_serial_bits,
      CLKOUT1_PHASE         => 0.000,
      CLKOUT1_DUTY_CYCLE    => 0.500,
      CLKIN_PERIOD          => 10.0,
      REF_JITTER            => 0.010)
   port map (
     -- Output clocks
      CLKFBOUT              => clkfbout,
      CLKOUT0               => clk_in_pll,
      CLKOUT1               => clk_div_in_int,
      CLKOUT2               => open,
      CLKOUT3               => open,
      CLKOUT4               => open,
      CLKOUT5               => open,
      -- Status and control signals
      LOCKED                => LOCKED_IN,
      RST                   => CLK_RESET,
      -- Input clock control
      CLKFBIN               => clkfbout,
      CLKIN                 => CLK_IN);

    clkd_buf : BUFG
      port map (
        O            => CLK_DIV_IN,
        I            => clk_div_in_int);

   -- Infer a dual port memory
   process (CLK_DIV_IN) begin
   if (CLK_DIV_IN = '1' and CLK_DIV_IN'event) then
     if (ENABLE_USER = '1') then
       if (WRITE_USER = '1') then
         ram_array(conv_integer(ADDRESS_USER)) := DATA_IN_USER;
       end if;
       DATA_OUT_USER <= ram_array(conv_integer(ADDRESS_USER))  after TCQ;
     end if;
   end if;
   end process;

   process (CLK_DIV_IN) begin
   if (CLK_DIV_IN = '1' and CLK_DIV_IN'event) then
     if (ENABLE_DEVICE = '1') then
       if (write_device = '1') then
         ram_array(conv_integer(address_device)) := DATA_IN_TO_DEVICE;
       end if;
     end if;
   end if;
   end process;

   -- auto-increment access into the RAM on the IO side
   process (CLK_DIV_IN) begin
   if (CLK_DIV_IN = '1' and CLK_DIV_IN'event) then
     if (IO_RESET = '1') then
       address_device <=  (others=>'0') after TCQ;
     elsif (ENABLE_DEVICE = '1') then
       address_device <= address_device + 1 after TCQ;
     end if;
   end if;
   end process;

   -- Instantiate the IO design
   io_inst : adc_serdes
   port map
   (
    -- From the system into the device
    DATA_IN_FROM_PINS_P     => DATA_IN_FROM_PINS_P,
    DATA_IN_FROM_PINS_N     => DATA_IN_FROM_PINS_N,
    DATA_IN_TO_DEVICE       => DATA_IN_TO_DEVICE,

    BITSLIP                 => BITSLIP,
    CLK_IN                  => clk_in_pll,
    CLK_DIV_IN              => CLK_DIV_IN,
    LOCKED_IN               => LOCKED_IN,
    LOCKED_OUT              => LOCKED_OUT,
    CLK_RESET               => CLK_RESET,
    IO_RESET                => IO_RESET);
end xilinx;



