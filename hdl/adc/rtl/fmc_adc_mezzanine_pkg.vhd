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

package fmc_adc_mezzanine_pkg is

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component fmc_adc_mezzanine
    generic(
      g_multishot_ram_size : natural := 2048;
      g_carrier_type : string := "SPEC"
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

      -- Events output pulses (for interrupt and time-stamping)
      trigger_p_o   : out std_logic;
      acq_start_p_o : out std_logic;
      acq_stop_p_o  : out std_logic;
      acq_end_p_o   : out std_logic;

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

      sys_scl_b : inout std_logic;      -- Mezzanine system I2C clock (EEPROM)
      sys_sda_b : inout std_logic       -- Mezzanine system I2C data (EEPROM)
      );
  end component fmc_adc_mezzanine;

end fmc_adc_mezzanine_pkg;

package body fmc_adc_mezzanine_pkg is



end fmc_adc_mezzanine_pkg;
