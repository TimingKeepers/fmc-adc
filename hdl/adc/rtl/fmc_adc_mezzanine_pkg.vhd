--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- FMC ADC mezzanine package
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: fmc_adc_mezzanine_pkg (fmc_adc_mezzanine_pkg.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 03-07-2013
--
-- version: 1.0
--
-- description: Package for FMC ADC mezzanine
--
-- dependencies:
--
--------------------------------------------------------------------------------
-- GNU LESSER GENERAL PUBLIC LICENSE
--------------------------------------------------------------------------------
-- This source file is free software; you can redistribute it and/or modify it
-- under the terms of the GNU Lesser General Public License as published by the
-- Free Software Foundation; either version 2.1 of the License, or (at your
-- option) any later version. This source is distributed in the hope that it
-- will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
-- of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-- See the GNU Lesser General Public License for more details. You should have
-- received a copy of the GNU Lesser General Public License along with this
-- source; if not, download it from http://www.gnu.org/licenses/lgpl-2.1.html
--------------------------------------------------------------------------------
-- last changes: see svn log.
--------------------------------------------------------------------------------
-- TODO: - 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.timetag_core_pkg.all;
use work.wishbone_pkg.all;



package fmc_adc_mezzanine_pkg is

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  -- Devices sdb description
  constant c_wb_adc_csr_sdb : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"7",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"00000000000000FF",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000608",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-FMC-ADC-Core    ")));

  constant c_wb_timetag_sdb : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"7",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000007F",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000604",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-Timetag-Core    ")));

  constant c_wb_fmc_adc_eic_sdb : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"7",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000000F",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"26ec6086",          -- "WB-FMC-ADC.EIC     " | md5sum | cut -c1-8
        version   => x"00000001",
        date      => x"20131204",
        name      => "WB-FMC-ADC.EIC     "))); 

  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component fmc_adc_mezzanine
    generic(
      g_multishot_ram_size : natural := 2048;
      g_carrier_type       : string  := "SPEC"
      );
    port (
      -- Clock, reset
      sys_clk_i   : in std_logic;
      sys_rst_n_i : in std_logic;

      -- CSR wishbone interface
      wb_csr_adr_i   : in  std_logic_vector(31 downto 0);
      wb_csr_dat_i   : in  std_logic_vector(31 downto 0);
      wb_csr_dat_o   : out std_logic_vector(31 downto 0);
      wb_csr_cyc_i   : in  std_logic;
      wb_csr_sel_i   : in  std_logic_vector(3 downto 0);
      wb_csr_stb_i   : in  std_logic;
      wb_csr_we_i    : in  std_logic;
      wb_csr_ack_o   : out std_logic;
      wb_csr_stall_o : out std_logic;

      -- DDR wishbone interface
      wb_ddr_clk_i   : in  std_logic;
      wb_ddr_adr_o   : out std_logic_vector(31 downto 0);
      wb_ddr_dat_o   : out std_logic_vector(63 downto 0);
      wb_ddr_sel_o   : out std_logic_vector(7 downto 0);
      wb_ddr_stb_o   : out std_logic;
      wb_ddr_we_o    : out std_logic;
      wb_ddr_cyc_o   : out std_logic;
      wb_ddr_ack_i   : in  std_logic;
      wb_ddr_stall_i : in  std_logic;

      -- Interrupt
      ddr_wr_fifo_empty_i : in  std_logic;
      trig_irq_o          : out std_logic;
      acq_end_irq_o       : out std_logic;
      eic_irq_o           : out std_logic;
      ext_acq_end_i       : in  std_logic;

      -- FMC interface
      ext_trigger_p_i : in std_logic;   -- External trigger
      ext_trigger_n_i : in std_logic;

      adc_dco_p_i  : in std_logic;                     -- ADC data clock
      adc_dco_n_i  : in std_logic;
      adc_fr_p_i   : in std_logic;                     -- ADC frame start
      adc_fr_n_i   : in std_logic;
      adc_outa_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (odd bits)
      adc_outa_n_i : in std_logic_vector(3 downto 0);
      adc_outb_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (even bits)
      adc_outb_n_i : in std_logic_vector(3 downto 0);
      
      adc_acq_count_o : out std_logic_vector(31 downto 0);

      gpio_dac_clr_n_o : out std_logic;                     -- offset DACs clear (active low)
      gpio_led_acq_o   : out std_logic;                     -- Mezzanine front panel power LED (PWR)
      gpio_led_trig_o  : out std_logic;                     -- Mezzanine front panel trigger LED (TRIG)
      gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
      gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
      gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
      gpio_ssr_ch4_o   : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
      gpio_si570_oe_o  : out std_logic;                     -- Si570 (programmable oscillator) output enable

      spi_din_i       : in  std_logic;  -- SPI data from FMC
      spi_dout_o      : out std_logic;  -- SPI data to FMC
      spi_sck_o       : out std_logic;  -- SPI clock
      spi_cs_adc_n_o  : out std_logic;  -- SPI ADC chip select (active low)
      spi_cs_dac1_n_o : out std_logic;  -- SPI channel 1 offset DAC chip select (active low)
      spi_cs_dac2_n_o : out std_logic;  -- SPI channel 2 offset DAC chip select (active low)
      spi_cs_dac3_n_o : out std_logic;  -- SPI channel 3 offset DAC chip select (active low)
      spi_cs_dac4_n_o : out std_logic;  -- SPI channel 4 offset DAC chip select (active low)

      si570_scl_b : inout std_logic;    -- I2C bus clock (Si570)
      si570_sda_b : inout std_logic;    -- I2C bus data (Si570)

      mezz_one_wire_b : inout std_logic;  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

      sys_scl_i      : in    std_logic;  
      sys_scl_o      : out   std_logic;   
      sys_scl_oe_n_o : out   std_logic;
      sys_sda_i      : in    std_logic;  
      sys_sda_o      : out   std_logic;   
      sys_sda_oe_n_o : out   std_logic;
      
      tm_tai_i       : in    std_logic_vector(39 downto 0);
      tm_cycles_i    : in    std_logic_vector(27 downto 0)
      );
  end component fmc_adc_mezzanine;
  
 

end fmc_adc_mezzanine_pkg;

package body fmc_adc_mezzanine_pkg is



end fmc_adc_mezzanine_pkg;
