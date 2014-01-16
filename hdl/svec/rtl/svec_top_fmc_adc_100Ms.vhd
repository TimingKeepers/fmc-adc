--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Top level entity for Simple VME FMC Carrier
-- http://www.ohwr.org/projects/svec
--------------------------------------------------------------------------------
--
-- unit name: svec_top_fmc_adc_100Ms (svec_top_fmc_adc_100Ms.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 04-07-2013
--
-- version: see sdb_meta_pkg.vhd
--
-- description: Top entity of FMC ADC 100Ms/s design for SVEC board.
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
-- last changes: see git log.
--------------------------------------------------------------------------------
-- TODO: - 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;

use work.ddr3_ctrl_pkg.all;
use work.gencores_pkg.all;
use work.wishbone_pkg.all;
use work.fmc_adc_mezzanine_pkg.all;
use work.sdb_meta_pkg.all;
use work.xvme64x_core_pkg.all;
use work.timetag_core_pkg.all;
use work.bicolor_led_ctrl_pkg.all;


entity svec_top_fmc_adc_100Ms is
  generic(
    g_SIMULATION    : string := "FALSE";
    g_CALIB_SOFT_IP : string := "TRUE");
  port
    (
      -- Local 20MHz VCXO oscillator
      clk_20m_vcxo_i : in std_logic;

      -- Reset from system fpga
      rst_n_i : in std_logic;

      -- Carrier font panel LEDs
      fp_led_line_oen_o : out std_logic_vector(1 downto 0);
      fp_led_line_o     : out std_logic_vector(1 downto 0);
      fp_led_column_o   : out std_logic_vector(3 downto 0);

      -- Carrier I2C eeprom
      carrier_scl_b : inout std_logic;
      carrier_sda_b : inout std_logic;

      -- PCB revision
      pcbrev_i : in std_logic_vector(4 downto 0);

      -- Carrier 1-wire interface (DS18B20 thermometer + unique ID)
      carrier_one_wire_b : inout std_logic;

      ------------------------------------------
      -- VME interface
      ------------------------------------------
      vme_write_n_i    : in    std_logic;
      vme_sysreset_n_i : in    std_logic;
      --vme_sysclk_i     : in    std_logic;
      vme_retry_oe_o   : out   std_logic;
      vme_retry_n_o    : out   std_logic;
      vme_lword_n_b    : inout std_logic;
      vme_iackout_n_o  : out   std_logic;
      vme_iackin_n_i   : in    std_logic;
      vme_iack_n_i     : in    std_logic;
      vme_gap_i        : in    std_logic;
      vme_dtack_oe_o   : out   std_logic;
      vme_dtack_n_o    : out   std_logic;
      vme_ds_n_i       : in    std_logic_vector(1 downto 0);
      vme_data_oe_n_o  : out   std_logic;
      vme_data_dir_o   : out   std_logic;
      vme_berr_o       : out   std_logic;
      vme_as_n_i       : in    std_logic;
      vme_addr_oe_n_o  : out   std_logic;
      vme_addr_dir_o   : out   std_logic;
      vme_irq_n_o      : out   std_logic_vector(7 downto 1);
      vme_ga_i         : in    std_logic_vector(5 downto 0);
      vme_data_b       : inout std_logic_vector(31 downto 0);
      vme_am_i         : in    std_logic_vector(5 downto 0);
      vme_addr_b       : inout std_logic_vector(31 downto 1);

      ------------------------------------------
      -- DDR0 (bank 4)
      ------------------------------------------
      ddr0_we_n_o    : out   std_logic;
      ddr0_udqs_p_b  : inout std_logic;
      ddr0_udqs_n_b  : inout std_logic;
      ddr0_udm_o     : out   std_logic;
      ddr0_reset_n_o : out   std_logic;
      ddr0_ras_n_o   : out   std_logic;
      ddr0_odt_o     : out   std_logic;
      ddr0_ldqs_p_b  : inout std_logic;
      ddr0_ldqs_n_b  : inout std_logic;
      ddr0_ldm_o     : out   std_logic;
      ddr0_cke_o     : out   std_logic;
      ddr0_ck_p_o    : out   std_logic;
      ddr0_ck_n_o    : out   std_logic;
      ddr0_cas_n_o   : out   std_logic;
      ddr0_dq_b      : inout std_logic_vector(15 downto 0);
      ddr0_ba_o      : out   std_logic_vector(2 downto 0);
      ddr0_a_o       : out   std_logic_vector(13 downto 0);
      ddr0_zio_b     : inout std_logic;
      ddr0_rzq_b     : inout std_logic;

      ------------------------------------------
      -- DDR1 (bank 5)
      ------------------------------------------
      ddr1_we_n_o    : out   std_logic;
      ddr1_udqs_p_b  : inout std_logic;
      ddr1_udqs_n_b  : inout std_logic;
      ddr1_udm_o     : out   std_logic;
      ddr1_reset_n_o : out   std_logic;
      ddr1_ras_n_o   : out   std_logic;
      ddr1_odt_o     : out   std_logic;
      ddr1_ldqs_p_b  : inout std_logic;
      ddr1_ldqs_n_b  : inout std_logic;
      ddr1_ldm_o     : out   std_logic;
      ddr1_cke_o     : out   std_logic;
      ddr1_ck_p_o    : out   std_logic;
      ddr1_ck_n_o    : out   std_logic;
      ddr1_cas_n_o   : out   std_logic;
      ddr1_dq_b      : inout std_logic_vector(15 downto 0);
      ddr1_ba_o      : out   std_logic_vector(2 downto 0);
      ddr1_a_o       : out   std_logic_vector(13 downto 0);
      ddr1_zio_b     : inout std_logic;
      ddr1_rzq_b     : inout std_logic;

      ------------------------------------------
      -- FMC slot 0
      ------------------------------------------
      adc0_ext_trigger_p_i : in std_logic;  -- External trigger
      adc0_ext_trigger_n_i : in std_logic;

      adc0_dco_p_i  : in std_logic;                     -- ADC data clock
      adc0_dco_n_i  : in std_logic;
      adc0_fr_p_i   : in std_logic;                     -- ADC frame start
      adc0_fr_n_i   : in std_logic;
      adc0_outa_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (odd bits)
      adc0_outa_n_i : in std_logic_vector(3 downto 0);
      adc0_outb_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (even bits)
      adc0_outb_n_i : in std_logic_vector(3 downto 0);

      adc0_spi_din_i       : in  std_logic;  -- SPI data from FMC
      adc0_spi_dout_o      : out std_logic;  -- SPI data to FMC
      adc0_spi_sck_o       : out std_logic;  -- SPI clock
      adc0_spi_cs_adc_n_o  : out std_logic;  -- SPI ADC chip select (active low)
      adc0_spi_cs_dac1_n_o : out std_logic;  -- SPI channel 1 offset DAC chip select (active low)
      adc0_spi_cs_dac2_n_o : out std_logic;  -- SPI channel 2 offset DAC chip select (active low)
      adc0_spi_cs_dac3_n_o : out std_logic;  -- SPI channel 3 offset DAC chip select (active low)
      adc0_spi_cs_dac4_n_o : out std_logic;  -- SPI channel 4 offset DAC chip select (active low)

      adc0_gpio_dac_clr_n_o : out std_logic;                     -- offset DACs clear (active low)
      adc0_gpio_led_acq_o   : out std_logic;                     -- Mezzanine front panel power LED (PWR)
      adc0_gpio_led_trig_o  : out std_logic;                     -- Mezzanine front panel trigger LED (TRIG)
      adc0_gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
      adc0_gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
      adc0_gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
      adc0_gpio_ssr_ch4_o   : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
      adc0_gpio_si570_oe_o  : out std_logic;                     -- Si570 (programmable oscillator) output enable

      adc0_si570_scl_b : inout std_logic;  -- I2C bus clock (Si570)
      adc0_si570_sda_b : inout std_logic;  -- I2C bus data (Si570)

      adc0_one_wire_b : inout std_logic;  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

      ------------------------------------------
      -- FMC slot 1
      ------------------------------------------
      adc1_ext_trigger_p_i : in std_logic;  -- External trigger
      adc1_ext_trigger_n_i : in std_logic;

      adc1_dco_p_i  : in std_logic;                     -- ADC data clock
      adc1_dco_n_i  : in std_logic;
      adc1_fr_p_i   : in std_logic;                     -- ADC frame start
      adc1_fr_n_i   : in std_logic;
      adc1_outa_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (odd bits)
      adc1_outa_n_i : in std_logic_vector(3 downto 0);
      adc1_outb_p_i : in std_logic_vector(3 downto 0);  -- ADC serial data (even bits)
      adc1_outb_n_i : in std_logic_vector(3 downto 0);

      adc1_spi_din_i       : in  std_logic;  -- SPI data from FMC
      adc1_spi_dout_o      : out std_logic;  -- SPI data to FMC
      adc1_spi_sck_o       : out std_logic;  -- SPI clock
      adc1_spi_cs_adc_n_o  : out std_logic;  -- SPI ADC chip select (active low)
      adc1_spi_cs_dac1_n_o : out std_logic;  -- SPI channel 1 offset DAC chip select (active low)
      adc1_spi_cs_dac2_n_o : out std_logic;  -- SPI channel 2 offset DAC chip select (active low)
      adc1_spi_cs_dac3_n_o : out std_logic;  -- SPI channel 3 offset DAC chip select (active low)
      adc1_spi_cs_dac4_n_o : out std_logic;  -- SPI channel 4 offset DAC chip select (active low)

      adc1_gpio_dac_clr_n_o : out std_logic;                     -- offset DACs clear (active low)
      adc1_gpio_led_acq_o   : out std_logic;                     -- Mezzanine front panel power LED (PWR)
      adc1_gpio_led_trig_o  : out std_logic;                     -- Mezzanine front panel trigger LED (TRIG)
      adc1_gpio_ssr_ch1_o   : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
      adc1_gpio_ssr_ch2_o   : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
      adc1_gpio_ssr_ch3_o   : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
      adc1_gpio_ssr_ch4_o   : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
      adc1_gpio_si570_oe_o  : out std_logic;                     -- Si570 (programmable oscillator) output enable

      adc1_si570_scl_b : inout std_logic;  -- I2C bus clock (Si570)
      adc1_si570_sda_b : inout std_logic;  -- I2C bus data (Si570)

      adc1_one_wire_b : inout std_logic;  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

      ------------------------------------------
      -- FMC slot management
      ------------------------------------------
      fmc0_prsnt_m2c_n_i : in    std_logic;  -- Mezzanine present (active low)
      fmc0_scl_b         : inout std_logic;  -- Mezzanine system I2C clock (EEPROM)
      fmc0_sda_b         : inout std_logic;  -- Mezzanine system I2C data (EEPROM)

      fmc1_prsnt_m2c_n_i : in    std_logic;  -- Mezzanine present (active low)
      fmc1_scl_b         : inout std_logic;  -- Mezzanine system I2C clock (EEPROM)
      fmc1_sda_b         : inout std_logic   -- Mezzanine system I2C data (EEPROM)
      );
end svec_top_fmc_adc_100Ms;


architecture rtl of svec_top_fmc_adc_100Ms is

  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component carrier_csr
    port (
      rst_n_i                          : in  std_logic;
      clk_sys_i                        : in  std_logic;
      wb_adr_i                         : in  std_logic_vector(1 downto 0);
      wb_dat_i                         : in  std_logic_vector(31 downto 0);
      wb_dat_o                         : out std_logic_vector(31 downto 0);
      wb_cyc_i                         : in  std_logic;
      wb_sel_i                         : in  std_logic_vector(3 downto 0);
      wb_stb_i                         : in  std_logic;
      wb_we_i                          : in  std_logic;
      wb_ack_o                         : out std_logic;
      wb_stall_o                       : out std_logic;
      carrier_csr_carrier_pcb_rev_i    : in  std_logic_vector(4 downto 0);
      carrier_csr_carrier_reserved_i   : in  std_logic_vector(10 downto 0);
      carrier_csr_carrier_type_i       : in  std_logic_vector(15 downto 0);
      carrier_csr_stat_fmc0_pres_i     : in  std_logic;
      carrier_csr_stat_fmc1_pres_i     : in  std_logic;
      carrier_csr_stat_sys_pll_lck_i   : in  std_logic;
      carrier_csr_stat_ddr0_cal_done_i : in  std_logic;
      carrier_csr_stat_ddr1_cal_done_i : in  std_logic;
      carrier_csr_stat_reserved_i      : in  std_logic_vector(26 downto 0);
      carrier_csr_ctrl_fp_leds_man_o   : out std_logic_vector(15 downto 0);
      carrier_csr_ctrl_reserved_o      : out std_logic_vector(15 downto 0);
      carrier_csr_rst_fmc0_n_o         : out std_logic;
      carrier_csr_rst_fmc0_n_i         : in  std_logic;
      carrier_csr_rst_fmc0_n_load_o    : out std_logic;
      carrier_csr_rst_fmc1_n_o         : out std_logic;
      carrier_csr_rst_fmc1_n_i         : in  std_logic;
      carrier_csr_rst_fmc1_n_load_o    : out std_logic;
      carrier_csr_rst_reserved_o       : out std_logic_vector(29 downto 0)
      );
  end component carrier_csr;

  component fmc_adc_eic
    port (
      rst_n_i       : in  std_logic;
      clk_sys_i     : in  std_logic;
      wb_adr_i      : in  std_logic_vector(1 downto 0);
      wb_dat_i      : in  std_logic_vector(31 downto 0);
      wb_dat_o      : out std_logic_vector(31 downto 0);
      wb_cyc_i      : in  std_logic;
      wb_sel_i      : in  std_logic_vector(3 downto 0);
      wb_stb_i      : in  std_logic;
      wb_we_i       : in  std_logic;
      wb_ack_o      : out std_logic;
      wb_stall_o    : out std_logic;
      wb_int_o      : out std_logic;
      irq_trig_i    : in  std_logic;
      irq_acq_end_i : in  std_logic
      );
  end component fmc_adc_eic;


  ------------------------------------------------------------------------------
  -- SDB crossbar constants declaration
  --
  -- WARNING: All address in sdb and crossbar are BYTE addresses!
  ------------------------------------------------------------------------------

  -- Number of master port(s) on the wishbone crossbar
  constant c_NUM_WB_MASTERS : integer := 10;

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_SLAVES : integer := 1;

  -- Wishbone master(s)
  constant c_WB_MASTER_VME : integer := 0;

  -- Wishbone slave(s)
  constant c_WB_SLAVE_I2C          : integer := 0;  -- Carrier I2C master
  constant c_WB_SLAVE_ONEWIRE      : integer := 1;  -- Carrier onewire interface
  constant c_WB_SLAVE_SVEC_CSR     : integer := 2;  -- SVEC control and status registers
  constant c_WB_SLAVE_VIC          : integer := 3;  -- Vectored interrupt controller
  constant c_WB_SLAVE_FMC0_ADC     : integer := 4;  -- FMC slot 1 ADC mezzanine
  constant c_WB_SLAVE_FMC0_DDR_ADR : integer := 5;  -- FMC slot 1 DDR address
  constant c_WB_SLAVE_FMC0_DDR_DAT : integer := 6;  -- FMC slot 1 DDR data
  constant c_WB_SLAVE_FMC1_ADC     : integer := 7;  -- FMC slot 2 ADC mezzanine
  constant c_WB_SLAVE_FMC1_DDR_ADR : integer := 8;  -- FMC slot 2 DDR address
  constant c_WB_SLAVE_FMC1_DDR_DAT : integer := 9;  -- FMC slot 2 DDR data


  -- Devices sdb description
  constant c_wb_svec_csr_sdb : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000001F",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00006603",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-SVEC-CSR        ")));

  constant c_wb_ddr_dat_sdb : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"0000000000000FFF",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"10006610",
        version   => x"00000001",
        date      => x"20130704",
        name      => "WB-DDR-Data-Access ")));

  constant c_wb_ddr_adr_sdb : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"0000000000000003",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"10006611",
        version   => x"00000001",
        date      => x"20130704",
        name      => "WB-DDR-Addr-Access ")));

  -- f_xwb_bridge_manual_sdb(size, sdb_addr)
  -- Note: sdb_addr is the sdb records address relative to the bridge base address
  constant c_fmc0_bridge_sdb : t_sdb_bridge := f_xwb_bridge_manual_sdb(x"00001fff", x"00000000");
  constant c_fmc1_bridge_sdb : t_sdb_bridge := f_xwb_bridge_manual_sdb(x"00001fff", x"00000000");

  -- sdb header address
  constant c_SDB_ADDRESS : t_wishbone_address := x"00000000";

  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(12 downto 0) :=
    (
      0  => f_sdb_embed_device(c_xwb_i2c_master_sdb, x"00001000"),
      1  => f_sdb_embed_device(c_xwb_onewire_master_sdb, x"00001100"),
      2  => f_sdb_embed_device(c_wb_svec_csr_sdb, x"00001200"),
      3  => f_sdb_embed_device(c_xwb_vic_sdb, x"00001300"),
      4  => f_sdb_embed_bridge(c_fmc0_bridge_sdb, x"00002000"),
      5  => f_sdb_embed_device(c_wb_ddr_adr_sdb, x"00004000"),
      6  => f_sdb_embed_device(c_wb_ddr_dat_sdb, x"00005000"),
      7  => f_sdb_embed_bridge(c_fmc1_bridge_sdb, x"00006000"),
      8  => f_sdb_embed_device(c_wb_ddr_adr_sdb, x"00008000"),
      9  => f_sdb_embed_device(c_wb_ddr_dat_sdb, x"00009000"),
      10 => f_sdb_embed_repo_url(c_repo_url_sdb),
      11 => f_sdb_embed_synthesis(c_synthesis_sdb),
      12 => f_sdb_embed_integration(c_integration_sdb)
      );

  -- VIC default vector setting
  constant c_VIC_VECTOR_TABLE : t_wishbone_address_array(0 to 1) :=
    (0 => x"00003500",
     1 => x"00007500");

  ------------------------------------------------------------------------------
  -- Other constants declaration
  ------------------------------------------------------------------------------

  -- SVEC carrier CSR constants
  constant c_CARRIER_TYPE : std_logic_vector(15 downto 0) := X"0002";

  -- Number of FMC slots
  constant c_NB_FMC_SLOTS : natural := 2;

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------

  -- System clock
  signal sys_clk_in         : std_logic;
  signal sys_clk_62_5_buf   : std_logic;
  signal sys_clk_62_5       : std_logic;
  signal sys_clk_125_buf    : std_logic;
  signal sys_clk_125        : std_logic;
  signal sys_clk_fb         : std_logic;
  signal sys_clk_pll_locked : std_logic;

  -- DDR3 clock
  signal ddr_clk     : std_logic;
  signal ddr_clk_buf : std_logic;

  -- Reset
  signal powerup_reset_cnt  : unsigned(7 downto 0) := "00000000";
  signal powerup_rst_n      : std_logic            := '0';
  signal sys_rst_n          : std_logic;
  signal ddr_rst_n          : std_logic;
  signal sw_rst_fmc0_n      : std_logic            := '1';
  signal sw_rst_fmc0_n_o    : std_logic;
  signal sw_rst_fmc0_n_i    : std_logic;
  signal sw_rst_fmc0_n_load : std_logic;
  signal sw_rst_fmc1_n      : std_logic            := '1';
  signal sw_rst_fmc1_n_o    : std_logic;
  signal sw_rst_fmc1_n_i    : std_logic;
  signal sw_rst_fmc1_n_load : std_logic;
  signal ddr_sw_rst_fmc0_n  : std_logic;
  signal ddr_sw_rst_fmc1_n  : std_logic;
  signal fmc0_rst_n         : std_logic;
  signal fmc1_rst_n         : std_logic;
  signal fmc0_ddr_rst_n     : std_logic;
  signal fmc1_ddr_rst_n     : std_logic;

  -- VME
  signal vme_data_b_out    : std_logic_vector(31 downto 0);
  signal vme_addr_b_out    : std_logic_vector(31 downto 1);
  signal vme_lword_n_b_out : std_logic;
  signal Vme_data_dir_int  : std_logic;
  signal vme_addr_dir_int  : std_logic;

  signal vme_access : std_logic;

  -- Wishbone buses from vme core master
  signal vme_master_out : t_wishbone_master_out;
  signal vme_master_in  : t_wishbone_master_in;

  -- Wishbone buses from vme core master (synchronised to 125MHz system clock)
  signal vme_sync_master_out : t_wishbone_master_out;
  signal vme_sync_master_in  : t_wishbone_master_in;

  -- Wishbone buse(s) from crossbar master port(s)
  signal cnx_master_out : t_wishbone_master_out_array(c_NUM_WB_MASTERS-1 downto 0);
  signal cnx_master_in  : t_wishbone_master_in_array(c_NUM_WB_MASTERS-1 downto 0);

  -- Wishbone buse(s) to crossbar slave port(s)
  signal cnx_slave_out : t_wishbone_slave_out_array(c_NUM_WB_SLAVES-1 downto 0);
  signal cnx_slave_in  : t_wishbone_slave_in_array(c_NUM_WB_SLAVES-1 downto 0);

  -- Wishbone buses from FMC ADC cores to DDR controller
  signal wb_ddr0_adc_adr   : std_logic_vector(31 downto 0);
  signal wb_ddr0_adc_dat_o : std_logic_vector(63 downto 0);
  signal wb_ddr0_adc_sel   : std_logic_vector(7 downto 0);
  signal wb_ddr0_adc_cyc   : std_logic;
  signal wb_ddr0_adc_stb   : std_logic;
  signal wb_ddr0_adc_we    : std_logic;
  signal wb_ddr0_adc_ack   : std_logic;
  signal wb_ddr0_adc_stall : std_logic;

  signal wb_ddr1_adc_adr   : std_logic_vector(31 downto 0);
  signal wb_ddr1_adc_dat_o : std_logic_vector(63 downto 0);
  signal wb_ddr1_adc_sel   : std_logic_vector(7 downto 0);
  signal wb_ddr1_adc_cyc   : std_logic;
  signal wb_ddr1_adc_stb   : std_logic;
  signal wb_ddr1_adc_we    : std_logic;
  signal wb_ddr1_adc_ack   : std_logic;
  signal wb_ddr1_adc_stall : std_logic;

  -- Interrupts stuff
  signal ddr_wr_fifo_empty    : std_logic_vector(c_NB_FMC_SLOTS-1 downto 0);
  signal acq_end_irq_p        : std_logic_vector(c_NB_FMC_SLOTS-1 downto 0);
  signal trig_irq_p           : std_logic_vector(c_NB_FMC_SLOTS-1 downto 0);
  signal fmc0_trig_irq_led    : std_logic;
  signal fmc0_acq_end_irq_led : std_logic;
  signal irq_to_vme           : std_logic;
  signal irq_to_vme_t         : std_logic;
  signal irq_to_vme_sync      : std_logic;
  signal fmc_irq              : std_logic_vector(c_NB_FMC_SLOTS-1 downto 0);

  -- Front panel LED control
  signal led_state     : std_logic_vector(15 downto 0);
  signal led_state_man : std_logic_vector(15 downto 0);

  -- DDR0 (bank 4)
  signal ddr0_status      : std_logic_vector(31 downto 0);
  signal ddr0_calib_done  : std_logic;
  signal ddr0_addr_cnt    : unsigned(31 downto 0);
  signal ddr0_dat_cyc_d   : std_logic;
  signal ddr0_addr_cnt_en : std_logic;

  -- DDR1 (bank 5)
  signal ddr1_status      : std_logic_vector(31 downto 0);
  signal ddr1_calib_done  : std_logic;
  signal ddr1_addr_cnt    : unsigned(31 downto 0);
  signal ddr1_dat_cyc_d   : std_logic;
  signal ddr1_addr_cnt_en : std_logic;

  -- Carrier 1-wire
  signal carrier_owr_en : std_logic_vector(0 downto 0);
  signal carrier_owr_i  : std_logic_vector(0 downto 0);

  -- Carrier I2C for EEPROM
  signal carrier_scl_in   : std_logic;
  signal carrier_scl_out  : std_logic;
  signal carrier_scl_oe_n : std_logic;
  signal carrier_sda_in   : std_logic;
  signal carrier_sda_out  : std_logic;
  signal carrier_sda_oe_n : std_logic;

  -- led pwm
  signal led_pwm_update_cnt : unsigned(9 downto 0);
  signal led_pwm_update     : std_logic;
  signal led_pwm_val        : unsigned(16 downto 0);
  signal led_pwm_val_down   : std_logic;
  signal led_pwm_cnt        : unsigned(16 downto 0);
  signal led_pwm            : std_logic;


begin


  ------------------------------------------------------------------------------
  -- Clocks distribution from 20MHz TCXO
  --  62.500 MHz system clock
  -- 125.000 MHz system clock
  -- 333.333 MHz DDR3 clock
  ------------------------------------------------------------------------------
  cmp_sys_clk_buf : IBUFG
    port map (
      I => clk_20m_vcxo_i,
      O => sys_clk_in);

  cmp_sys_clk_pll : PLL_BASE
    generic map (
      BANDWIDTH          => "OPTIMIZED",
      CLK_FEEDBACK       => "CLKFBOUT",
      COMPENSATION       => "INTERNAL",
      DIVCLK_DIVIDE      => 1,
      CLKFBOUT_MULT      => 50,
      CLKFBOUT_PHASE     => 0.000,
      CLKOUT0_DIVIDE     => 8,
      CLKOUT0_PHASE      => 0.000,
      CLKOUT0_DUTY_CYCLE => 0.500,
      CLKOUT1_DIVIDE     => 16,
      CLKOUT1_PHASE      => 0.000,
      CLKOUT1_DUTY_CYCLE => 0.500,
      CLKOUT2_DIVIDE     => 3,
      CLKOUT2_PHASE      => 0.000,
      CLKOUT2_DUTY_CYCLE => 0.500,
      CLKIN_PERIOD       => 50.0,
      REF_JITTER         => 0.016)
    port map (
      CLKFBOUT => sys_clk_fb,
      CLKOUT0  => sys_clk_125_buf,
      CLKOUT1  => sys_clk_62_5_buf,
      CLKOUT2  => ddr_clk_buf,
      CLKOUT3  => open,
      CLKOUT4  => open,
      CLKOUT5  => open,
      LOCKED   => sys_clk_pll_locked,
      RST      => '0',
      CLKFBIN  => sys_clk_fb,
      CLKIN    => sys_clk_in);

  cmp_clk_62_5_buf : BUFG
    port map (
      O => sys_clk_62_5,
      I => sys_clk_62_5_buf);

  cmp_clk_125_buf : BUFG
    port map (
      O => sys_clk_125,
      I => sys_clk_125_buf);

  cmp_ddr_clk_buf : BUFG
    port map (
      O => ddr_clk,
      I => ddr_clk_buf);

  ------------------------------------------------------------------------------
  -- System reset
  ------------------------------------------------------------------------------
  p_powerup_reset : process(sys_clk_62_5)
  begin
    if rising_edge(sys_clk_62_5) then
      if(vme_sysreset_n_i = '0' or rst_n_i = '0') then
        powerup_rst_n <= '0';
      elsif sys_clk_pll_locked = '1' then
        if(powerup_reset_cnt = "11111111") then
          powerup_rst_n <= '1';
        else
          powerup_rst_n     <= '0';
          powerup_reset_cnt <= powerup_reset_cnt + 1;
        end if;
      else
        powerup_rst_n     <= '0';
        powerup_reset_cnt <= "00000000";
      end if;
    end if;
  end process;

  --System reset synchronisation to 125MHz system clock domain
  cmp_sync_rst : gc_sync_ffs
    port map (
      clk_i    => sys_clk_125,
      rst_n_i  => '1',
      data_i   => powerup_rst_n,
      synced_o => sys_rst_n
      );

  -- System reset synchronisation to DDR clock domain
  cmp_sync_ddr_rst : gc_sync_ffs
    port map (
      clk_i    => ddr_clk,
      rst_n_i  => '1',
      data_i   => powerup_rst_n,
      synced_o => ddr_rst_n
      );

  -- FMC 0 reset synchronisation to DDR clock domain
  cmp_sync_fmc0_rst : gc_sync_ffs
    port map (
      clk_i    => ddr_clk,
      rst_n_i  => '1',
      data_i   => sw_rst_fmc0_n,
      synced_o => ddr_sw_rst_fmc0_n
      );

  -- FMC 1 reset synchronisation to DDR clock domain
  cmp_sync_fmc1_rst : gc_sync_ffs
    port map (
      clk_i    => ddr_clk,
      rst_n_i  => '1',
      data_i   => sw_rst_fmc1_n,
      synced_o => ddr_sw_rst_fmc1_n
      );

  fmc0_rst_n     <= sys_rst_n and sw_rst_fmc0_n;
  fmc1_rst_n     <= sys_rst_n and sw_rst_fmc1_n;
  fmc0_ddr_rst_n <= ddr_rst_n and ddr_sw_rst_fmc0_n;
  fmc1_ddr_rst_n <= ddr_rst_n and ddr_sw_rst_fmc1_n;

  ------------------------------------------------------------------------------
  -- VME interface
  ------------------------------------------------------------------------------
  cmp_vme_core : xvme64x_core
    port map (
      clk_i           => sys_clk_62_5,
      rst_n_i         => powerup_rst_n,
      VME_AS_n_i      => vme_as_n_i,
      VME_RST_n_i     => powerup_rst_n,
      VME_WRITE_n_i   => vme_write_n_i,
      VME_AM_i        => vme_am_i,
      VME_DS_n_i      => vme_ds_n_i,
      VME_GA_i        => vme_ga_i,
      VME_BERR_o      => vme_berr_o,
      VME_DTACK_n_o   => vme_dtack_n_o,
      VME_RETRY_n_o   => vme_retry_n_o,
      VME_RETRY_OE_o  => vme_retry_oe_o,
      VME_LWORD_n_b_i => vme_lword_n_b,
      VME_LWORD_n_b_o => vme_lword_n_b_out,
      VME_ADDR_b_i    => vme_addr_b,
      VME_DATA_b_o    => vme_data_b_out,
      VME_ADDR_b_o    => vme_addr_b_out,
      VME_DATA_b_i    => vme_data_b,
      VME_IRQ_n_o     => vme_irq_n_o,
      VME_IACK_n_i    => vme_iack_n_i,
      VME_IACKIN_n_i  => vme_iackin_n_i,
      VME_IACKOUT_n_o => vme_iackout_n_o,
      VME_DTACK_OE_o  => vme_dtack_oe_o,
      VME_DATA_DIR_o  => vme_data_dir_int,
      VME_DATA_OE_N_o => vme_data_oe_n_o,
      VME_ADDR_DIR_o  => vme_addr_dir_int,
      VME_ADDR_OE_N_o => vme_addr_oe_n_o,
      master_o        => vme_master_out,
      master_i        => vme_master_in,
      irq_i           => irq_to_vme_sync
      );

  -- VME tri-state buffers
  vme_data_b    <= vme_data_b_out    when vme_data_dir_int = '1' else (others => 'Z');
  vme_addr_b    <= vme_addr_b_out    when vme_addr_dir_int = '1' else (others => 'Z');
  vme_lword_n_b <= vme_lword_n_b_out when vme_addr_dir_int = '1' else 'Z';

  vme_addr_dir_o <= vme_addr_dir_int;
  vme_data_dir_o <= vme_data_dir_int;

  -- Wishbone bus synchronisation from vme 62.5MHz clock to 125MHz system clock
  cmp_xwb_clock_crossing : xwb_clock_crossing
    generic map(
      g_size => 16
      )
    port map(
      slave_clk_i    => sys_clk_62_5,
      slave_rst_n_i  => sys_rst_n,
      slave_i        => vme_master_out,
      slave_o        => vme_master_in,
      master_clk_i   => sys_clk_125,
      master_rst_n_i => sys_rst_n,
      master_i       => vme_sync_master_in,
      master_o       => vme_sync_master_out
      );

  cnx_slave_in(c_WB_MASTER_VME) <= vme_sync_master_out;
  vme_sync_master_in            <= cnx_slave_out(c_WB_MASTER_VME);

  -- Interrupt line synchronisation to vme 62.5MHz
  p_irq_to_vme_sync : process (sys_clk_62_5, powerup_rst_n)
  begin
    if powerup_rst_n = '0' then
      irq_to_vme_t    <= '0';
      irq_to_vme_sync <= '0';
    elsif rising_edge(sys_clk_62_5) then
      irq_to_vme_t    <= irq_to_vme;
      irq_to_vme_sync <= irq_to_vme_t;
    end if;
  end process p_irq_to_vme_sync;


  ------------------------------------------------------------------------------
  -- CSR wishbone crossbar
  ------------------------------------------------------------------------------
  cmp_sdb_crossbar : xwb_sdb_crossbar
    generic map (
      g_num_masters => c_NUM_WB_SLAVES,
      g_num_slaves  => c_NUM_WB_MASTERS,
      g_registered  => true,
      g_wraparound  => true,
      g_layout      => c_INTERCONNECT_LAYOUT,
      g_sdb_addr    => c_SDB_ADDRESS)
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,
      slave_i   => cnx_slave_in,
      slave_o   => cnx_slave_out,
      master_i  => cnx_master_in,
      master_o  => cnx_master_out);

  ------------------------------------------------------------------------------
  -- Carrier 1-wire master
  --    DS18B20 (thermometer + unique ID)
  ------------------------------------------------------------------------------
  cmp_carrier_onewire : xwb_onewire_master
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE,
      g_num_ports           => 1,
      g_ow_btp_normal       => "5.0",
      g_ow_btp_overdrive    => "1.0"
      )
    port map(
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      slave_i => cnx_master_out(c_WB_SLAVE_ONEWIRE),
      slave_o => cnx_master_in(c_WB_SLAVE_ONEWIRE),
      desc_o  => open,

      owr_pwren_o => open,
      owr_en_o    => carrier_owr_en,
      owr_i       => carrier_owr_i
      );

  carrier_one_wire_b <= '0' when carrier_owr_en(0) = '1' else 'Z';
  carrier_owr_i(0)   <= carrier_one_wire_b;

  ------------------------------------------------------------------------------
  -- I2C master
  --    Carrier EEPROM
  ------------------------------------------------------------------------------
  cmp_carrier_i2c : xwb_i2c_master
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE
      )
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      slave_i => cnx_master_out(c_WB_SLAVE_I2C),
      slave_o => cnx_master_in(c_WB_SLAVE_I2C),
      desc_o  => open,

      scl_pad_i    => carrier_scl_in,
      scl_pad_o    => carrier_scl_out,
      scl_padoen_o => carrier_scl_oe_n,
      sda_pad_i    => carrier_sda_in,
      sda_pad_o    => carrier_sda_out,
      sda_padoen_o => carrier_sda_oe_n
      );

  -- Tri-state buffer for SDA and SCL
  carrier_scl_b  <= carrier_scl_out when carrier_scl_oe_n = '0' else 'Z';
  carrier_scl_in <= carrier_scl_b;

  carrier_sda_b  <= carrier_sda_out when carrier_sda_oe_n = '0' else 'Z';
  carrier_sda_in <= carrier_sda_b;

  ------------------------------------------------------------------------------
  -- Carrier CSR
  --    Carrier type and PCB version
  --    Carrier status (PLL, FMC presence)
  --    Front panel LED manual control
  ------------------------------------------------------------------------------
  cmp_carrier_csr : carrier_csr
    port map(
      rst_n_i                          => sys_rst_n,
      clk_sys_i                        => sys_clk_125,
      wb_adr_i                         => cnx_master_out(c_WB_SLAVE_SVEC_CSR).adr(3 downto 2),  -- cnx_master_out.adr is byte address
      wb_dat_i                         => cnx_master_out(c_WB_SLAVE_SVEC_CSR).dat,
      wb_dat_o                         => cnx_master_in(c_WB_SLAVE_SVEC_CSR).dat,
      wb_cyc_i                         => cnx_master_out(c_WB_SLAVE_SVEC_CSR).cyc,
      wb_sel_i                         => cnx_master_out(c_WB_SLAVE_SVEC_CSR).sel,
      wb_stb_i                         => cnx_master_out(c_WB_SLAVE_SVEC_CSR).stb,
      wb_we_i                          => cnx_master_out(c_WB_SLAVE_SVEC_CSR).we,
      wb_ack_o                         => cnx_master_in(c_WB_SLAVE_SVEC_CSR).ack,
      wb_stall_o                       => open,
      carrier_csr_carrier_pcb_rev_i    => pcbrev_i,
      carrier_csr_carrier_reserved_i   => (others => '0'),
      carrier_csr_carrier_type_i       => c_CARRIER_TYPE,
      carrier_csr_stat_fmc0_pres_i     => fmc0_prsnt_m2c_n_i,
      carrier_csr_stat_fmc1_pres_i     => fmc1_prsnt_m2c_n_i,
      carrier_csr_stat_sys_pll_lck_i   => sys_clk_pll_locked,
      carrier_csr_stat_ddr0_cal_done_i => ddr0_calib_done,
      carrier_csr_stat_ddr1_cal_done_i => ddr1_calib_done,
      carrier_csr_stat_reserved_i      => (others => '0'),
      carrier_csr_ctrl_fp_leds_man_o   => led_state_man,
      carrier_csr_ctrl_reserved_o      => open,
      carrier_csr_rst_fmc0_n_o         => sw_rst_fmc0_n_o,
      carrier_csr_rst_fmc0_n_i         => sw_rst_fmc0_n_i,
      carrier_csr_rst_fmc0_n_load_o    => sw_rst_fmc0_n_load,
      carrier_csr_rst_fmc1_n_o         => sw_rst_fmc1_n_o,
      carrier_csr_rst_fmc1_n_i         => sw_rst_fmc1_n_i,
      carrier_csr_rst_fmc1_n_load_o    => sw_rst_fmc1_n_load,
      carrier_csr_rst_reserved_o       => open
      );

  -- Unused wishbone signals
  cnx_master_in(c_WB_SLAVE_SVEC_CSR).err   <= '0';
  cnx_master_in(c_WB_SLAVE_SVEC_CSR).rty   <= '0';
  cnx_master_in(c_WB_SLAVE_SVEC_CSR).stall <= '0';
  cnx_master_in(c_WB_SLAVE_SVEC_CSR).int   <= '0';

  -- external software reset registers (to assign a non-zero default value)
  p_sw_rst_fmc0: process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if sys_rst_n = '0' then
        sw_rst_fmc0_n <= '1';
      elsif sw_rst_fmc0_n_load = '1' then
        sw_rst_fmc0_n <= sw_rst_fmc0_n_o;
      end if;
    end if;
  end process p_sw_rst_fmc0;

  sw_rst_fmc0_n_i <= sw_rst_fmc0_n;

  p_sw_rst_fmc1: process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if sys_rst_n = '0' then
        sw_rst_fmc1_n <= '1';
      elsif sw_rst_fmc1_n_load = '1' then
        sw_rst_fmc1_n <= sw_rst_fmc1_n_o;
      end if;
    end if;
  end process p_sw_rst_fmc1;

  sw_rst_fmc1_n_i <= sw_rst_fmc1_n;

  ------------------------------------------------------------------------------
  -- Vectored interrupt controller (VIC)
  ------------------------------------------------------------------------------
  cmp_vic : xwb_vic
    generic map (
      g_interface_mode      => PIPELINED,
      g_address_granularity => BYTE,
      g_num_interrupts      => 2,
      g_init_vectors        => c_VIC_VECTOR_TABLE)
    port map (
      clk_sys_i    => sys_clk_125,
      rst_n_i      => sys_rst_n,
      slave_i      => cnx_master_out(c_WB_SLAVE_VIC),
      slave_o      => cnx_master_in(c_WB_SLAVE_VIC),
      irqs_i(0)    => fmc_irq(0),
      irqs_i(1)    => fmc_irq(1),
      irq_master_o => irq_to_vme);

  ------------------------------------------------------------------------------
  -- Slot 1 : FMC ADC mezzanine (wb bridge)
  --    Mezzanine system managment I2C master
  --    Mezzanine SPI master
  --    Mezzanine I2C
  --    ADC core
  --    Mezzanine 1-wire master
  ------------------------------------------------------------------------------
  cmp_fmc_adc_mezzanine_0 : fmc_adc_mezzanine
    generic map(
      g_multishot_ram_size => 2048,
      g_carrier_type       => "SVEC"
      )
    port map(
      sys_clk_i   => sys_clk_125,
      sys_rst_n_i => fmc0_rst_n,

      wb_csr_adr_i   => cnx_master_out(c_WB_SLAVE_FMC0_ADC).adr,
      wb_csr_dat_i   => cnx_master_out(c_WB_SLAVE_FMC0_ADC).dat,
      wb_csr_dat_o   => cnx_master_in(c_WB_SLAVE_FMC0_ADC).dat,
      wb_csr_cyc_i   => cnx_master_out(c_WB_SLAVE_FMC0_ADC).cyc,
      wb_csr_sel_i   => cnx_master_out(c_WB_SLAVE_FMC0_ADC).sel,
      wb_csr_stb_i   => cnx_master_out(c_WB_SLAVE_FMC0_ADC).stb,
      wb_csr_we_i    => cnx_master_out(c_WB_SLAVE_FMC0_ADC).we,
      wb_csr_ack_o   => cnx_master_in(c_WB_SLAVE_FMC0_ADC).ack,
      wb_csr_stall_o => cnx_master_in(c_WB_SLAVE_FMC0_ADC).stall,

      wb_ddr_clk_i   => sys_clk_125,
      wb_ddr_adr_o   => wb_ddr0_adc_adr,
      wb_ddr_dat_o   => wb_ddr0_adc_dat_o,
      wb_ddr_sel_o   => wb_ddr0_adc_sel,
      wb_ddr_stb_o   => wb_ddr0_adc_stb,
      wb_ddr_we_o    => wb_ddr0_adc_we,
      wb_ddr_cyc_o   => wb_ddr0_adc_cyc,
      wb_ddr_ack_i   => wb_ddr0_adc_ack,
      wb_ddr_stall_i => wb_ddr0_adc_stall,

      ddr_wr_fifo_empty_i => ddr_wr_fifo_empty(0),
      trig_irq_o          => trig_irq_p(0),
      acq_end_irq_o       => acq_end_irq_p(0),
      eic_irq_o           => fmc_irq(0),

      ext_trigger_p_i => adc0_ext_trigger_p_i,
      ext_trigger_n_i => adc0_ext_trigger_n_i,

      adc_dco_p_i  => adc0_dco_p_i,
      adc_dco_n_i  => adc0_dco_n_i,
      adc_fr_p_i   => adc0_fr_p_i,
      adc_fr_n_i   => adc0_fr_n_i,
      adc_outa_p_i => adc0_outa_p_i,
      adc_outa_n_i => adc0_outa_n_i,
      adc_outb_p_i => adc0_outb_p_i,
      adc_outb_n_i => adc0_outb_n_i,

      gpio_dac_clr_n_o => adc0_gpio_dac_clr_n_o,
      gpio_led_acq_o   => adc0_gpio_led_acq_o,
      gpio_led_trig_o  => adc0_gpio_led_trig_o,
      gpio_ssr_ch1_o   => adc0_gpio_ssr_ch1_o,
      gpio_ssr_ch2_o   => adc0_gpio_ssr_ch2_o,
      gpio_ssr_ch3_o   => adc0_gpio_ssr_ch3_o,
      gpio_ssr_ch4_o   => adc0_gpio_ssr_ch4_o,
      gpio_si570_oe_o  => adc0_gpio_si570_oe_o,

      spi_din_i       => adc0_spi_din_i,
      spi_dout_o      => adc0_spi_dout_o,
      spi_sck_o       => adc0_spi_sck_o,
      spi_cs_adc_n_o  => adc0_spi_cs_adc_n_o,
      spi_cs_dac1_n_o => adc0_spi_cs_dac1_n_o,
      spi_cs_dac2_n_o => adc0_spi_cs_dac2_n_o,
      spi_cs_dac3_n_o => adc0_spi_cs_dac3_n_o,
      spi_cs_dac4_n_o => adc0_spi_cs_dac4_n_o,

      si570_scl_b => adc0_si570_scl_b,
      si570_sda_b => adc0_si570_sda_b,

      mezz_one_wire_b => adc0_one_wire_b,

      sys_scl_b => fmc0_scl_b,
      sys_sda_b => fmc0_sda_b
      );

  -- Unused wishbone signals
  cnx_master_in(c_WB_SLAVE_FMC0_ADC).err <= '0';
  cnx_master_in(c_WB_SLAVE_FMC0_ADC).rty <= '0';
  cnx_master_in(c_WB_SLAVE_FMC0_ADC).int <= '0';

  ------------------------------------------------------------------------------
  -- Slot 2 : FMC ADC mezzanine (wb bridge)
  --    Mezzanine system managment I2C master
  --    Mezzanine SPI master
  --    Mezzanine I2C
  --    ADC core
  --    Mezzanine 1-wire master
  ------------------------------------------------------------------------------
  cmp_fmc_adc_mezzanine_1 : fmc_adc_mezzanine
    generic map(
      g_multishot_ram_size => 2048,
      g_carrier_type       => "SVEC"
      )
    port map(
      sys_clk_i   => sys_clk_125,
      sys_rst_n_i => fmc1_rst_n,

      wb_csr_adr_i   => cnx_master_out(c_WB_SLAVE_FMC1_ADC).adr,
      wb_csr_dat_i   => cnx_master_out(c_WB_SLAVE_FMC1_ADC).dat,
      wb_csr_dat_o   => cnx_master_in(c_WB_SLAVE_FMC1_ADC).dat,
      wb_csr_cyc_i   => cnx_master_out(c_WB_SLAVE_FMC1_ADC).cyc,
      wb_csr_sel_i   => cnx_master_out(c_WB_SLAVE_FMC1_ADC).sel,
      wb_csr_stb_i   => cnx_master_out(c_WB_SLAVE_FMC1_ADC).stb,
      wb_csr_we_i    => cnx_master_out(c_WB_SLAVE_FMC1_ADC).we,
      wb_csr_ack_o   => cnx_master_in(c_WB_SLAVE_FMC1_ADC).ack,
      wb_csr_stall_o => cnx_master_in(c_WB_SLAVE_FMC1_ADC).stall,

      wb_ddr_clk_i   => sys_clk_125,
      wb_ddr_adr_o   => wb_ddr1_adc_adr,
      wb_ddr_dat_o   => wb_ddr1_adc_dat_o,
      wb_ddr_sel_o   => wb_ddr1_adc_sel,
      wb_ddr_stb_o   => wb_ddr1_adc_stb,
      wb_ddr_we_o    => wb_ddr1_adc_we,
      wb_ddr_cyc_o   => wb_ddr1_adc_cyc,
      wb_ddr_ack_i   => wb_ddr1_adc_ack,
      wb_ddr_stall_i => wb_ddr1_adc_stall,

      ddr_wr_fifo_empty_i => ddr_wr_fifo_empty(1),
      trig_irq_o          => trig_irq_p(1),
      acq_end_irq_o       => acq_end_irq_p(1),
      eic_irq_o           => fmc_irq(1),

      ext_trigger_p_i => adc1_ext_trigger_p_i,
      ext_trigger_n_i => adc1_ext_trigger_n_i,

      adc_dco_p_i  => adc1_dco_p_i,
      adc_dco_n_i  => adc1_dco_n_i,
      adc_fr_p_i   => adc1_fr_p_i,
      adc_fr_n_i   => adc1_fr_n_i,
      adc_outa_p_i => adc1_outa_p_i,
      adc_outa_n_i => adc1_outa_n_i,
      adc_outb_p_i => adc1_outb_p_i,
      adc_outb_n_i => adc1_outb_n_i,

      gpio_dac_clr_n_o => adc1_gpio_dac_clr_n_o,
      gpio_led_acq_o   => adc1_gpio_led_acq_o,
      gpio_led_trig_o  => adc1_gpio_led_trig_o,
      gpio_ssr_ch1_o   => adc1_gpio_ssr_ch1_o,
      gpio_ssr_ch2_o   => adc1_gpio_ssr_ch2_o,
      gpio_ssr_ch3_o   => adc1_gpio_ssr_ch3_o,
      gpio_ssr_ch4_o   => adc1_gpio_ssr_ch4_o,
      gpio_si570_oe_o  => adc1_gpio_si570_oe_o,

      spi_din_i       => adc1_spi_din_i,
      spi_dout_o      => adc1_spi_dout_o,
      spi_sck_o       => adc1_spi_sck_o,
      spi_cs_adc_n_o  => adc1_spi_cs_adc_n_o,
      spi_cs_dac1_n_o => adc1_spi_cs_dac1_n_o,
      spi_cs_dac2_n_o => adc1_spi_cs_dac2_n_o,
      spi_cs_dac3_n_o => adc1_spi_cs_dac3_n_o,
      spi_cs_dac4_n_o => adc1_spi_cs_dac4_n_o,

      si570_scl_b => adc1_si570_scl_b,
      si570_sda_b => adc1_si570_sda_b,

      mezz_one_wire_b => adc1_one_wire_b,

      sys_scl_b => fmc1_scl_b,
      sys_sda_b => fmc1_sda_b
      );

  -- Unused wishbone signals
  cnx_master_in(c_WB_SLAVE_FMC1_ADC).err <= '0';
  cnx_master_in(c_WB_SLAVE_FMC1_ADC).rty <= '0';
  cnx_master_in(c_WB_SLAVE_FMC1_ADC).int <= '0';

  ------------------------------------------------------------------------------
  -- DDR0 controller (bank 4)
  ------------------------------------------------------------------------------
  cmp_ddr_ctrl_bank4 : ddr3_ctrl
    generic map(
      g_BANK_PORT_SELECT   => "SVEC_BANK4_64B_32B",
      g_MEMCLK_PERIOD      => 3000,
      g_SIMULATION         => g_SIMULATION,
      g_CALIB_SOFT_IP      => g_CALIB_SOFT_IP,
      g_P0_MASK_SIZE       => 8,
      g_P0_DATA_PORT_SIZE  => 64,
      g_P0_BYTE_ADDR_WIDTH => 30,
      g_P1_MASK_SIZE       => 4,
      g_P1_DATA_PORT_SIZE  => 32,
      g_P1_BYTE_ADDR_WIDTH => 30)
    port map (
      clk_i   => ddr_clk,
      rst_n_i => fmc0_ddr_rst_n,

      status_o => ddr0_status,

      ddr3_dq_b     => ddr0_dq_b,
      ddr3_a_o      => ddr0_a_o,
      ddr3_ba_o     => ddr0_ba_o,
      ddr3_ras_n_o  => ddr0_ras_n_o,
      ddr3_cas_n_o  => ddr0_cas_n_o,
      ddr3_we_n_o   => ddr0_we_n_o,
      ddr3_odt_o    => ddr0_odt_o,
      ddr3_rst_n_o  => ddr0_reset_n_o,
      ddr3_cke_o    => ddr0_cke_o,
      ddr3_dm_o     => ddr0_ldm_o,
      ddr3_udm_o    => ddr0_udm_o,
      ddr3_dqs_p_b  => ddr0_ldqs_p_b,
      ddr3_dqs_n_b  => ddr0_ldqs_n_b,
      ddr3_udqs_p_b => ddr0_udqs_p_b,
      ddr3_udqs_n_b => ddr0_udqs_n_b,
      ddr3_clk_p_o  => ddr0_ck_p_o,
      ddr3_clk_n_o  => ddr0_ck_n_o,
      ddr3_rzq_b    => ddr0_rzq_b,
      ddr3_zio_b    => ddr0_zio_b,

      wb0_clk_i   => sys_clk_125,
      wb0_sel_i   => wb_ddr0_adc_sel,
      wb0_cyc_i   => wb_ddr0_adc_cyc,
      wb0_stb_i   => wb_ddr0_adc_stb,
      wb0_we_i    => wb_ddr0_adc_we,
      wb0_addr_i  => wb_ddr0_adc_adr,
      wb0_data_i  => wb_ddr0_adc_dat_o,
      wb0_data_o  => open,
      wb0_ack_o   => wb_ddr0_adc_ack,
      wb0_stall_o => wb_ddr0_adc_stall,

      p0_cmd_empty_o   => open,
      p0_cmd_full_o    => open,
      p0_rd_full_o     => open,
      p0_rd_empty_o    => open,
      p0_rd_count_o    => open,
      p0_rd_overflow_o => open,
      p0_rd_error_o    => open,
      p0_wr_full_o     => open,
      p0_wr_empty_o    => ddr_wr_fifo_empty(0),
      p0_wr_count_o    => open,
      p0_wr_underrun_o => open,
      p0_wr_error_o    => open,

      wb1_clk_i   => sys_clk_125,
      wb1_sel_i   => cnx_master_out(c_WB_SLAVE_FMC0_DDR_DAT).sel,
      wb1_cyc_i   => cnx_master_out(c_WB_SLAVE_FMC0_DDR_DAT).cyc,
      wb1_stb_i   => cnx_master_out(c_WB_SLAVE_FMC0_DDR_DAT).stb,
      wb1_we_i    => cnx_master_out(c_WB_SLAVE_FMC0_DDR_DAT).we,
      wb1_addr_i  => std_logic_vector(ddr0_addr_cnt),
      wb1_data_i  => cnx_master_out(c_WB_SLAVE_FMC0_DDR_DAT).dat,
      wb1_data_o  => cnx_master_in(c_WB_SLAVE_FMC0_DDR_DAT).dat,
      wb1_ack_o   => cnx_master_in(c_WB_SLAVE_FMC0_DDR_DAT).ack,
      wb1_stall_o => cnx_master_in(c_WB_SLAVE_FMC0_DDR_DAT).stall,

      p1_cmd_empty_o   => open,
      p1_cmd_full_o    => open,
      p1_rd_full_o     => open,
      p1_rd_empty_o    => open,
      p1_rd_count_o    => open,
      p1_rd_overflow_o => open,
      p1_rd_error_o    => open,
      p1_wr_full_o     => open,
      p1_wr_empty_o    => open,
      p1_wr_count_o    => open,
      p1_wr_underrun_o => open,
      p1_wr_error_o    => open

      );

  ddr0_calib_done <= ddr0_status(0);

  -- DDR0 (bank 4) address counter
  --  The address counter is set by writing to the c_WB_SLAVE_FMC0_DDR_ADR wishbone periph.
  --  Than the counter is incremented on every access to the c_WB_SLAVE_FMC0_DDR_DAT wishbone periph.
  --  The counter is incremented on the falling edge of cyc. This is because the ddr controller
  --  samples the address on (cyc_re and stb)+1

  p_ddr0_dat_cyc : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if fmc0_rst_n = '0' then
        ddr0_dat_cyc_d <= '0';
      else
        ddr0_dat_cyc_d <= cnx_master_out(c_WB_SLAVE_FMC0_DDR_DAT).cyc;
      end if;
    end if;
  end process p_ddr0_dat_cyc;

  ddr0_addr_cnt_en <= not(cnx_master_out(c_WB_SLAVE_FMC0_DDR_DAT).cyc) and ddr0_dat_cyc_d;

  -- address counter
  p_ddr0_addr_cnt : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (fmc0_rst_n = '0') then
        ddr0_addr_cnt <= (others => '0');
      elsif (cnx_master_out(c_WB_SLAVE_FMC0_DDR_ADR).we = '1' and
             cnx_master_out(c_WB_SLAVE_FMC0_DDR_ADR).stb = '1' and
             cnx_master_out(c_WB_SLAVE_FMC0_DDR_ADR).cyc = '1') then
        ddr0_addr_cnt <= unsigned(cnx_master_out(c_WB_SLAVE_FMC0_DDR_ADR).dat);
      elsif (ddr0_addr_cnt_en = '1') then
        ddr0_addr_cnt <= ddr0_addr_cnt + 1;
      end if;
    end if;
  end process p_ddr0_addr_cnt;

  -- ack generation
  p_ddr0_addr_ack : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (fmc0_rst_n = '0') then
        cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).ack <= '0';
      elsif (cnx_master_out(c_WB_SLAVE_FMC0_DDR_ADR).stb = '1' and
             cnx_master_out(c_WB_SLAVE_FMC0_DDR_ADR).cyc = '1') then
        cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).ack <= '1';
      else
        cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).ack <= '0';
      end if;
    end if;
  end process p_ddr0_addr_ack;

  -- Address counter read back
  cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).dat <= std_logic_vector(ddr0_addr_cnt);

  -- Unused wishbone signals
  cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).err   <= '0';
  cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).rty   <= '0';
  cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).stall <= '0';
  cnx_master_in(c_WB_SLAVE_FMC0_DDR_ADR).int   <= '0';

  ------------------------------------------------------------------------------
  -- DDR1 controller (bank 5)
  ------------------------------------------------------------------------------
  cmp_ddr_ctrl_bank5 : ddr3_ctrl
    generic map(
      g_BANK_PORT_SELECT   => "SVEC_BANK5_64B_32B",
      g_MEMCLK_PERIOD      => 3000,
      g_SIMULATION         => g_SIMULATION,
      g_CALIB_SOFT_IP      => g_CALIB_SOFT_IP,
      g_P0_MASK_SIZE       => 8,
      g_P0_DATA_PORT_SIZE  => 64,
      g_P0_BYTE_ADDR_WIDTH => 30,
      g_P1_MASK_SIZE       => 4,
      g_P1_DATA_PORT_SIZE  => 32,
      g_P1_BYTE_ADDR_WIDTH => 30)
    port map (
      clk_i   => ddr_clk,
      rst_n_i => fmc1_ddr_rst_n,

      status_o => ddr1_status,

      ddr3_dq_b     => ddr1_dq_b,
      ddr3_a_o      => ddr1_a_o,
      ddr3_ba_o     => ddr1_ba_o,
      ddr3_ras_n_o  => ddr1_ras_n_o,
      ddr3_cas_n_o  => ddr1_cas_n_o,
      ddr3_we_n_o   => ddr1_we_n_o,
      ddr3_odt_o    => ddr1_odt_o,
      ddr3_rst_n_o  => ddr1_reset_n_o,
      ddr3_cke_o    => ddr1_cke_o,
      ddr3_dm_o     => ddr1_ldm_o,
      ddr3_udm_o    => ddr1_udm_o,
      ddr3_dqs_p_b  => ddr1_ldqs_p_b,
      ddr3_dqs_n_b  => ddr1_ldqs_n_b,
      ddr3_udqs_p_b => ddr1_udqs_p_b,
      ddr3_udqs_n_b => ddr1_udqs_n_b,
      ddr3_clk_p_o  => ddr1_ck_p_o,
      ddr3_clk_n_o  => ddr1_ck_n_o,
      ddr3_rzq_b    => ddr1_rzq_b,
      ddr3_zio_b    => ddr1_zio_b,

      wb0_clk_i   => sys_clk_125,
      wb0_sel_i   => wb_ddr1_adc_sel,
      wb0_cyc_i   => wb_ddr1_adc_cyc,
      wb0_stb_i   => wb_ddr1_adc_stb,
      wb0_we_i    => wb_ddr1_adc_we,
      wb0_addr_i  => wb_ddr1_adc_adr,
      wb0_data_i  => wb_ddr1_adc_dat_o,
      wb0_data_o  => open,
      wb0_ack_o   => wb_ddr1_adc_ack,
      wb0_stall_o => wb_ddr1_adc_stall,

      p0_cmd_empty_o   => open,
      p0_cmd_full_o    => open,
      p0_rd_full_o     => open,
      p0_rd_empty_o    => open,
      p0_rd_count_o    => open,
      p0_rd_overflow_o => open,
      p0_rd_error_o    => open,
      p0_wr_full_o     => open,
      p0_wr_empty_o    => ddr_wr_fifo_empty(1),
      p0_wr_count_o    => open,
      p0_wr_underrun_o => open,
      p0_wr_error_o    => open,

      wb1_clk_i   => sys_clk_125,
      wb1_sel_i   => cnx_master_out(c_WB_SLAVE_FMC1_DDR_DAT).sel,
      wb1_cyc_i   => cnx_master_out(c_WB_SLAVE_FMC1_DDR_DAT).cyc,
      wb1_stb_i   => cnx_master_out(c_WB_SLAVE_FMC1_DDR_DAT).stb,
      wb1_we_i    => cnx_master_out(c_WB_SLAVE_FMC1_DDR_DAT).we,
      wb1_addr_i  => std_logic_vector(ddr1_addr_cnt),
      wb1_data_i  => cnx_master_out(c_WB_SLAVE_FMC1_DDR_DAT).dat,
      wb1_data_o  => cnx_master_in(c_WB_SLAVE_FMC1_DDR_DAT).dat,
      wb1_ack_o   => cnx_master_in(c_WB_SLAVE_FMC1_DDR_DAT).ack,
      wb1_stall_o => cnx_master_in(c_WB_SLAVE_FMC1_DDR_DAT).stall,

      p1_cmd_empty_o   => open,
      p1_cmd_full_o    => open,
      p1_rd_full_o     => open,
      p1_rd_empty_o    => open,
      p1_rd_count_o    => open,
      p1_rd_overflow_o => open,
      p1_rd_error_o    => open,
      p1_wr_full_o     => open,
      p1_wr_empty_o    => open,
      p1_wr_count_o    => open,
      p1_wr_underrun_o => open,
      p1_wr_error_o    => open

      );

  ddr1_calib_done <= ddr1_status(0);

  -- DDR1 (bank 5) address counter
  --  The address counter is set by writing to the c_WB_SLAVE_FMC1_DDR_ADR wishbone periph.
  --  Than the counter is incremented on every access to the c_WB_SLAVE_FMC1_DDR_DAT wishbone periph.
  --  The counter is incremented on the falling edge of cyc. This is because the ddr controller
  --  samples the address on (cyc_re and stb)+1

  p_ddr1_dat_cyc : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if fmc1_rst_n = '0' then
        ddr1_dat_cyc_d <= '0';
      else
        ddr1_dat_cyc_d <= cnx_master_out(c_WB_SLAVE_FMC1_DDR_DAT).cyc;
      end if;
    end if;
  end process p_ddr1_dat_cyc;

  ddr1_addr_cnt_en <= not(cnx_master_out(c_WB_SLAVE_FMC1_DDR_DAT).cyc) and ddr1_dat_cyc_d;

  -- address counter
  p_ddr1_addr_cnt : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (fmc1_rst_n = '0') then
        ddr1_addr_cnt <= (others => '0');
      elsif (cnx_master_out(c_WB_SLAVE_FMC1_DDR_ADR).we = '1' and
             cnx_master_out(c_WB_SLAVE_FMC1_DDR_ADR).stb = '1' and
             cnx_master_out(c_WB_SLAVE_FMC1_DDR_ADR).cyc = '1') then
        ddr1_addr_cnt <= unsigned(cnx_master_out(c_WB_SLAVE_FMC1_DDR_ADR).dat);
      elsif (ddr1_addr_cnt_en = '1') then
        ddr1_addr_cnt <= ddr1_addr_cnt + 1;
      end if;
    end if;
  end process p_ddr1_addr_cnt;

  -- ack generation
  p_ddr1_addr_ack : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (fmc1_rst_n = '0') then
        cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).ack <= '0';
      elsif (cnx_master_out(c_WB_SLAVE_FMC1_DDR_ADR).stb = '1' and
             cnx_master_out(c_WB_SLAVE_FMC1_DDR_ADR).cyc = '1') then
        cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).ack <= '1';
      else
        cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).ack <= '0';
      end if;
    end if;
  end process p_ddr1_addr_ack;

  -- Address counter read back
  cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).dat <= std_logic_vector(ddr1_addr_cnt);

  -- Unused wishbone signals
  cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).err   <= '0';
  cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).rty   <= '0';
  cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).stall <= '0';
  cnx_master_in(c_WB_SLAVE_FMC1_DDR_ADR).int   <= '0';

  ------------------------------------------------------------------------------
  -- Front panel LED control
  --  
  ------------------------------------------------------------------------------
  cmp_led_controller : bicolor_led_ctrl
    generic map(
      g_NB_COLUMN    => 4,
      g_NB_LINE      => 2,
      g_CLK_FREQ     => 125000000,      -- in Hz
      g_REFRESH_RATE => 250             -- in Hz
      )
    port map(
      rst_n_i => sys_rst_n,
      clk_i   => sys_clk_125,

      led_intensity_i => "1100100",     -- in %

      led_state_i => led_state,

      column_o   => fp_led_column_o,
      line_o     => fp_led_line_o,
      line_oen_o => fp_led_line_oen_o
      );

  cmp_vme_access_led : gc_extend_pulse
    generic map (
      g_width => 5000000)
    port map (
      clk_i      => sys_clk_125,
      rst_n_i    => sys_rst_n,
      pulse_i    => cnx_slave_in(c_WB_MASTER_VME).cyc,
      extended_o => vme_access
      );

  cmp_fmc0_trig_irq_led : gc_extend_pulse
    generic map (
      g_width => 5000000)
    port map (
      clk_i      => sys_clk_125,
      rst_n_i    => sys_rst_n,
      pulse_i    => trig_irq_p(0),
      extended_o => fmc0_trig_irq_led
      );

  cmp_fmc0_acq_end_irq_led : gc_extend_pulse
    generic map (
      g_width => 5000000)
    port map (
      clk_i      => sys_clk_125,
      rst_n_i    => sys_rst_n,
      pulse_i    => acq_end_irq_p(0),
      extended_o => fmc0_acq_end_irq_led
      );

  -- LED 1 : VME access
  led_state(1 downto 0) <= c_LED_GREEN when vme_access = '1' else c_LED_OFF;

  -- LED 2 : 
  led_state(3 downto 2) <= c_LED_RED;

  -- LED 3 : 
  led_state(5 downto 4) <= c_LED_RED_GREEN;

  -- LED 4 : 
  led_state(7 downto 6) <= '0' & led_pwm;

  -- LED 5 : 
  led_state(9 downto 8) <= fmc0_trig_irq_led & '0';

  -- LED 6 : 
  led_state(11 downto 10) <= fmc0_acq_end_irq_led & '0';

  -- LED 7 : 
  led_state(13 downto 12) <= '0' & fmc_irq(0);

  -- LED 8 : 
  led_state(15 downto 14) <= '0' & irq_to_vme_sync;

  --led_state(15 downto 12) <= led_state_man(15 downto 12);

  ------------------------------------------------------------------------------
  -- FPGA loaded led (heart beat)
  ------------------------------------------------------------------------------
  p_led_pwn_update_cnt : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (sys_rst_n = '0') then
        led_pwm_update_cnt <= (others => '0');
        led_pwm_update     <= '0';
      elsif (led_pwm_update_cnt = to_unsigned(954, 10)) then
        led_pwm_update_cnt <= (others => '0');
        led_pwm_update     <= '1';
      else
        led_pwm_update_cnt <= led_pwm_update_cnt + 1;
        led_pwm_update     <= '0';
      end if;
    end if;
  end process p_led_pwn_update_cnt;

  p_led_pwn_val : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (sys_rst_n = '0') then
        led_pwm_val      <= (others => '0');
        led_pwm_val_down <= '0';
      elsif (led_pwm_update = '1') then
        if led_pwm_val_down = '1' then
          if led_pwm_val = X"100" then
            led_pwm_val_down <= '0';
          end if;
          led_pwm_val <= led_pwm_val - 1;
        else
          if led_pwm_val = X"1FFFE" then
            led_pwm_val_down <= '1';
          end if;
          led_pwm_val <= led_pwm_val + 1;
        end if;
      end if;
    end if;
  end process p_led_pwn_val;

  p_led_pwn_cnt : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (sys_rst_n = '0') then
        led_pwm_cnt <= (others => '0');
      else
        led_pwm_cnt <= led_pwm_cnt + 1;
      end if;
    end if;
  end process p_led_pwn_cnt;

  p_led_pwn : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (sys_rst_n = '0') then
        led_pwm <= '0';
      elsif (led_pwm_cnt = 0) then
        led_pwm <= '1';
      elsif (led_pwm_cnt = led_pwm_val) then
        led_pwm <= '0';
      end if;
    end if;
  end process p_led_pwn;

  -- LED pwm ready to be used
  -- <= led_pwm;

  ------------------------------------------------------------------------------
  -- Assign unused outputs
  ------------------------------------------------------------------------------


end rtl;
