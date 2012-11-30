--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Top level entity for Simple PCIe FMC Carrier
-- http://www.ohwr.org/projects/spec
--------------------------------------------------------------------------------
--
-- unit name: spec_top_fmc_adc_100Ms (spec_top_fmc_adc_100Ms.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 24-02-2011
--
-- version: 1.0
--
-- description: Top entity of FMC ADC 100Ms/s design for SPEC board.
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

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.gn4124_core_pkg.all;
use work.ddr3_ctrl_pkg.all;
use work.gencores_pkg.all;
use work.wishbone_pkg.all;
use work.fmc_adc_100Ms_core_pkg.all;


entity spec_top_fmc_adc_100Ms is
  generic(
    g_SIMULATION    : string := "FALSE";
    g_CALIB_SOFT_IP : string := "TRUE");
  port
    (
      -- Local oscillator
      clk20_vcxo_i : in std_logic;      -- 20MHz VCXO clock

      -- Carrier font panel LEDs
      led_red_o   : out std_logic;
      led_green_o : out std_logic;

      -- Auxiliary pins
      aux_leds_o    : out std_logic_vector(3 downto 0);
      aux_buttons_i : in  std_logic_vector(1 downto 0);

      -- PCB version
      pcb_ver_i : in std_logic_vector(3 downto 0);

      -- Carrier 1-wire interface (DS18B20 thermometer + unique ID)
      carrier_one_wire_b : inout std_logic;

      -- GN4124 interface
      L_CLKp       : in    std_logic;                      -- Local bus clock (frequency set in GN4124 config registers)
      L_CLKn       : in    std_logic;                      -- Local bus clock (frequency set in GN4124 config registers)
      L_RST_N      : in    std_logic;                      -- Reset from GN4124 (RSTOUT18_N)
      P2L_RDY      : out   std_logic;                      -- Rx Buffer Full Flag
      P2L_CLKn     : in    std_logic;                      -- Receiver Source Synchronous Clock-
      P2L_CLKp     : in    std_logic;                      -- Receiver Source Synchronous Clock+
      P2L_DATA     : in    std_logic_vector(15 downto 0);  -- Parallel receive data
      P2L_DFRAME   : in    std_logic;                      -- Receive Frame
      P2L_VALID    : in    std_logic;                      -- Receive Data Valid
      P_WR_REQ     : in    std_logic_vector(1 downto 0);   -- PCIe Write Request
      P_WR_RDY     : out   std_logic_vector(1 downto 0);   -- PCIe Write Ready
      RX_ERROR     : out   std_logic;                      -- Receive Error
      L2P_DATA     : out   std_logic_vector(15 downto 0);  -- Parallel transmit data
      L2P_DFRAME   : out   std_logic;                      -- Transmit Data Frame
      L2P_VALID    : out   std_logic;                      -- Transmit Data Valid
      L2P_CLKn     : out   std_logic;                      -- Transmitter Source Synchronous Clock-
      L2P_CLKp     : out   std_logic;                      -- Transmitter Source Synchronous Clock+
      L2P_EDB      : out   std_logic;                      -- Packet termination and discard
      L2P_RDY      : in    std_logic;                      -- Tx Buffer Full Flag
      L_WR_RDY     : in    std_logic_vector(1 downto 0);   -- Local-to-PCIe Write
      P_RD_D_RDY   : in    std_logic_vector(1 downto 0);   -- PCIe-to-Local Read Response Data Ready
      TX_ERROR     : in    std_logic;                      -- Transmit Error
      VC_RDY       : in    std_logic_vector(1 downto 0);   -- Channel ready
      GPIO         : inout std_logic_vector(1 downto 0);   -- GPIO[0] -> GN4124 GPIO8
                                                           -- GPIO[1] -> GN4124 GPIO9
      -- DDR3 interface
      DDR3_CAS_N   : out   std_logic;
      DDR3_CK_N    : out   std_logic;
      DDR3_CK_P    : out   std_logic;
      DDR3_CKE     : out   std_logic;
      DDR3_LDM     : out   std_logic;
      DDR3_LDQS_N  : inout std_logic;
      DDR3_LDQS_P  : inout std_logic;
      DDR3_ODT     : out   std_logic;
      DDR3_RAS_N   : out   std_logic;
      DDR3_RESET_N : out   std_logic;
      DDR3_UDM     : out   std_logic;
      DDR3_UDQS_N  : inout std_logic;
      DDR3_UDQS_P  : inout std_logic;
      DDR3_WE_N    : out   std_logic;
      DDR3_DQ      : inout std_logic_vector(15 downto 0);
      DDR3_A       : out   std_logic_vector(13 downto 0);
      DDR3_BA      : out   std_logic_vector(2 downto 0);
      DDR3_ZIO     : inout std_logic;
      DDR3_RZQ     : inout std_logic;

      -- FMC slot
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

      spi_din_i       : in  std_logic;  -- SPI data from FMC
      spi_dout_o      : out std_logic;  -- SPI data to FMC
      spi_sck_o       : out std_logic;  -- SPI clock
      spi_cs_adc_n_o  : out std_logic;  -- SPI ADC chip select (active low)
      spi_cs_dac1_n_o : out std_logic;  -- SPI channel 1 offset DAC chip select (active low)
      spi_cs_dac2_n_o : out std_logic;  -- SPI channel 2 offset DAC chip select (active low)
      spi_cs_dac3_n_o : out std_logic;  -- SPI channel 3 offset DAC chip select (active low)
      spi_cs_dac4_n_o : out std_logic;  -- SPI channel 4 offset DAC chip select (active low)

      gpio_dac_clr_n_o   : out std_logic;                     -- offset DACs clear (active low)
      gpio_led_power_o   : out std_logic;                     -- Mezzanine front panel power LED (PWR)
      gpio_led_trigger_o : out std_logic;                     -- Mezzanine front panel trigger LED (TRIG)
      gpio_ssr_ch1_o     : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
      gpio_ssr_ch2_o     : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
      gpio_ssr_ch3_o     : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
      gpio_ssr_ch4_o     : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
      gpio_si570_oe_o    : out std_logic;                     -- Si570 (programmable oscillator) output enable

      si570_scl_b : inout std_logic;    -- I2C bus clock (Si570)
      si570_sda_b : inout std_logic;    -- I2C bus data (Si570)

      mezz_one_wire_b : inout std_logic;  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

      prsnt_m2c_n_i : in std_logic;     -- Mezzanine present (active low)

      sys_scl_b : inout std_logic;      -- Mezzanine system I2C clock (EEPROM)
      sys_sda_b : inout std_logic       -- Mezzanine system I2C data (EEPROM)
      );
end spec_top_fmc_adc_100Ms;


architecture rtl of spec_top_fmc_adc_100Ms is

  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component carrier_csr
    port (
      rst_n_i                          : in  std_logic;
      wb_clk_i                         : in  std_logic;
      wb_addr_i                        : in  std_logic_vector(2 downto 0);
      wb_data_i                        : in  std_logic_vector(31 downto 0);
      wb_data_o                        : out std_logic_vector(31 downto 0);
      wb_cyc_i                         : in  std_logic;
      wb_sel_i                         : in  std_logic_vector(3 downto 0);
      wb_stb_i                         : in  std_logic;
      wb_we_i                          : in  std_logic;
      wb_ack_o                         : out std_logic;
      carrier_csr_carrier_pcb_rev_i    : in  std_logic_vector(3 downto 0);
      carrier_csr_carrier_reserved_i   : in  std_logic_vector(11 downto 0);
      carrier_csr_carrier_type_i       : in  std_logic_vector(15 downto 0);
      carrier_csr_bitstream_type_i     : in  std_logic_vector(31 downto 0);
      carrier_csr_bitstream_date_i     : in  std_logic_vector(31 downto 0);
      carrier_csr_stat_fmc_pres_i      : in  std_logic;
      carrier_csr_stat_p2l_pll_lck_i   : in  std_logic;
      carrier_csr_stat_sys_pll_lck_i   : in  std_logic;
      carrier_csr_stat_ddr3_cal_done_i : in  std_logic;
      carrier_csr_stat_reserved_i      : in  std_logic_vector(27 downto 0);
      carrier_csr_ctrl_led_green_o     : out std_logic;
      carrier_csr_ctrl_led_red_o       : out std_logic;
      carrier_csr_ctrl_dac_clr_n_o     : out std_logic;
      carrier_csr_ctrl_reserved_o      : out std_logic_vector(28 downto 0)
      );
  end component carrier_csr;

  component utc_core
    port (
      clk_i         : in  std_logic;
      rst_n_i       : in  std_logic;
      trigger_p_i   : in  std_logic;
      acq_start_p_i : in  std_logic;
      acq_stop_p_i  : in  std_logic;
      acq_end_p_i   : in  std_logic;
      wb_adr_i      : in  std_logic_vector(4 downto 0);
      wb_dat_i      : in  std_logic_vector(31 downto 0);
      wb_dat_o      : out std_logic_vector(31 downto 0);
      wb_cyc_i      : in  std_logic;
      wb_sel_i      : in  std_logic_vector(3 downto 0);
      wb_stb_i      : in  std_logic;
      wb_we_i       : in  std_logic;
      wb_ack_o      : out std_logic
      );
  end component utc_core;

  component irq_controller
    port (
      clk_i       : in  std_logic;
      rst_n_i     : in  std_logic;
      irq_src_p_i : in  std_logic_vector(31 downto 0);
      irq_p_o     : out std_logic;
      wb_adr_i    : in  std_logic_vector(1 downto 0);
      wb_dat_i    : in  std_logic_vector(31 downto 0);
      wb_dat_o    : out std_logic_vector(31 downto 0);
      wb_cyc_i    : in  std_logic;
      wb_sel_i    : in  std_logic_vector(3 downto 0);
      wb_stb_i    : in  std_logic;
      wb_we_i     : in  std_logic;
      wb_ack_o    : out std_logic
      );
  end component irq_controller;


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
  constant c_MASTER_GENNUM : integer := 0;

  -- Wishbone slave(s)
  constant c_SLAVE_DMA         : integer := 0;  -- DMA controller in the Gennum core
  constant c_SLAVE_ONEWIRE     : integer := 1;  -- Carrier onewire interface
  constant c_SLAVE_SPEC_CSR    : integer := 2;  -- SPEC control and status registers
  constant c_SLAVE_UTC         : integer := 3;  -- UTC core for time-tagging
  constant c_SLAVE_INT         : integer := 4;  -- Interrupt controller
  constant c_SLAVE_FMC_SYS_I2C : integer := 5;  -- Mezzanine system I2C interface (EEPROM)
  constant c_SLAVE_FMC_SPI     : integer := 6;  -- Mezzanine SPI interface
  constant c_SLAVE_FMC_I2C     : integer := 7;  -- Mezzanine I2C controller
  constant c_SLAVE_FMC_ADC     : integer := 8;  -- Mezzanine ADC core
  constant c_SLAVE_FMC_ONEWIRE : integer := 9;  -- Mezzanine onewire interface

  -- Devices sdb description
  constant c_DMA_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"0000000000000023",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000601",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-DMA.Control     ")));

  constant c_ONEWIRE_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"0000000000000007",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000602",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-Onewire.Control ")));

  constant c_SPEC_CSR_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"0000000000000013",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000603",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-SPEC-CSR        ")));

  constant c_UTC_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"0000000000000043",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000604",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-UTC-Core        ")));

  constant c_INT_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000000B",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000605",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-Int.Control     ")));

  constant c_I2C_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000001B",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000606",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-I2C.Control     ")));

  constant c_SPI_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000001B",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000607",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-SPI.Control     ")));

  constant c_ADC_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"0000000000000067",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000608",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-FMC-ADC-Core    ")));

  -- sdb header address
  constant c_SDB_ADDRESS : t_wishbone_address := x"00000000";

  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_NUM_WB_MASTERS-1 downto 0) :=
    (
      c_SLAVE_DMA         => f_sdb_embed_device(c_DMA_SDB_DEVICE, x"00001000"),
      c_SLAVE_ONEWIRE     => f_sdb_embed_device(c_ONEWIRE_SDB_DEVICE, x"00001200"),
      c_SLAVE_SPEC_CSR    => f_sdb_embed_device(c_SPEC_CSR_SDB_DEVICE, x"00001300"),
      c_SLAVE_UTC         => f_sdb_embed_device(c_UTC_SDB_DEVICE, x"00001400"),
      c_SLAVE_INT         => f_sdb_embed_device(c_INT_SDB_DEVICE, x"00001500"),
      c_SLAVE_FMC_SYS_I2C => f_sdb_embed_device(c_I2C_SDB_DEVICE, x"00001600"),
      c_SLAVE_FMC_SPI     => f_sdb_embed_device(c_SPI_SDB_DEVICE, x"00001700"),
      c_SLAVE_FMC_I2C     => f_sdb_embed_device(c_I2C_SDB_DEVICE, x"00001800"),
      c_SLAVE_FMC_ADC     => f_sdb_embed_device(c_ADC_SDB_DEVICE, x"00001900"),
      c_SLAVE_FMC_ONEWIRE => f_sdb_embed_device(c_ONEWIRE_SDB_DEVICE, x"00001A00")
      );

  ------------------------------------------------------------------------------
  -- Other constants declaration
  ------------------------------------------------------------------------------

  -- SPEC carrier CSR constants
  constant c_CARRIER_TYPE   : std_logic_vector(15 downto 0) := X"0001";
  constant c_BITSTREAM_TYPE : std_logic_vector(31 downto 0) := X"00000001";
  constant c_BITSTREAM_DATE : std_logic_vector(31 downto 0) := X"50AA5124";  -- UTC time

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------

  -- System clock
  signal sys_clk_in         : std_logic;
  signal sys_clk_125_buf    : std_logic;
  signal sys_clk_250_buf    : std_logic;
  signal sys_clk_125        : std_logic;
  signal sys_clk_250        : std_logic;
  signal sys_clk_fb         : std_logic;
  signal sys_clk_pll_locked : std_logic;

  -- DDR3 clock
  signal ddr_clk     : std_logic;
  signal ddr_clk_buf : std_logic;

  -- LCLK from GN4124
  signal l_clk : std_logic;

  -- Reset
  signal rst       : std_logic;
  signal sys_rst   : std_logic;
  signal sys_rst_n : std_logic;

  -- Wishbone buse(s) from crossbar master port(s)
  signal cnx_master_out : t_wishbone_master_out_array(c_NUM_WB_MASTERS-1 downto 0);
  signal cnx_master_in  : t_wishbone_master_in_array(c_NUM_WB_MASTERS-1 downto 0);

  -- Wishbone buse(s) to crossbar slave port(s)
  signal cnx_slave_out : t_wishbone_slave_out_array(c_NUM_WB_SLAVES-1 downto 0);
  signal cnx_slave_in  : t_wishbone_slave_in_array(c_NUM_WB_SLAVES-1 downto 0);

  -- Wishbone address from GN4124 core (32-bit word address)
  signal gn_wb_adr : std_logic_vector(31 downto 0);

  -- Wishbone address from to DMA controller (32-bit word address)
  signal dma_ctrl_wb_adr : std_logic_vector(31 downto 0);

  -- GN4124 core DMA port to DDR wishbone bus
  signal wb_dma_adr   : std_logic_vector(31 downto 0);
  signal wb_dma_dat_i : std_logic_vector(31 downto 0);
  signal wb_dma_dat_o : std_logic_vector(31 downto 0);
  signal wb_dma_sel   : std_logic_vector(3 downto 0);
  signal wb_dma_cyc   : std_logic;
  signal wb_dma_stb   : std_logic;
  signal wb_dma_we    : std_logic;
  signal wb_dma_ack   : std_logic;
  signal wb_dma_stall : std_logic;

  -- FMC ADC core to DDR wishbone bus
  signal wb_ddr_adr   : std_logic_vector(31 downto 0);
  signal wb_ddr_dat_o : std_logic_vector(63 downto 0);
  signal wb_ddr_sel   : std_logic_vector(7 downto 0);
  signal wb_ddr_cyc   : std_logic;
  signal wb_ddr_stb   : std_logic;
  signal wb_ddr_we    : std_logic;
  signal wb_ddr_ack   : std_logic;
  signal wb_ddr_stall : std_logic;

  -- Interrupts stuff
  signal dma_irq             : std_logic_vector(1 downto 0);
  signal dma_irq_p           : std_logic_vector(1 downto 0);
  signal irq_sources         : std_logic_vector(31 downto 0);
  signal irq_to_gn4124       : std_logic;
  signal irq_sources_2_led   : std_logic_vector(1 downto 0);
  signal ddr_wr_fifo_empty   : std_logic;
  signal ddr_wr_fifo_empty_d : std_logic;
  signal ddr_wr_fifo_empty_p : std_logic;
  signal acq_end_irq_p       : std_logic;
  signal acq_end             : std_logic;

  -- Mezzanine I2C for Si570
  signal si570_scl_in   : std_logic;
  signal si570_scl_out  : std_logic;
  signal si570_scl_oe_n : std_logic;
  signal si570_sda_in   : std_logic;
  signal si570_sda_out  : std_logic;
  signal si570_sda_oe_n : std_logic;

  -- Mezzanine system I2C for EEPROM
  signal sys_scl_in   : std_logic;
  signal sys_scl_out  : std_logic;
  signal sys_scl_oe_n : std_logic;
  signal sys_sda_in   : std_logic;
  signal sys_sda_out  : std_logic;
  signal sys_sda_oe_n : std_logic;

  -- LED control from carrier CSR register
  signal led_red   : std_logic;
  signal led_green : std_logic;

  -- CSR whisbone slaves for test
  signal gpio_stat     : std_logic_vector(31 downto 0);
  signal gpio_ctrl_1   : std_logic_vector(31 downto 0);
  signal gpio_ctrl_2   : std_logic_vector(31 downto 0);
  signal gpio_ctrl_3   : std_logic_vector(31 downto 0);
  signal gpio_led_ctrl : std_logic_vector(31 downto 0);

  -- GN4124
  signal gn4124_status  : std_logic_vector(31 downto 0);
  signal p2l_pll_locked : std_logic;

  -- DDR3
  signal ddr3_status     : std_logic_vector(31 downto 0);
  signal ddr3_calib_done : std_logic;

  -- SPI
  signal spi_din_t : std_logic_vector(3 downto 0);
  signal spi_ss_t  : std_logic_vector(7 downto 0);

  -- Mezzanine 1-wire
  signal mezz_owr_pwren : std_logic_vector(0 downto 0);
  signal mezz_owr_en    : std_logic_vector(0 downto 0);
  signal mezz_owr_i     : std_logic_vector(0 downto 0);

  -- Carrier 1-wire
  signal carrier_owr_pwren : std_logic_vector(0 downto 0);
  signal carrier_owr_en    : std_logic_vector(0 downto 0);
  signal carrier_owr_i     : std_logic_vector(0 downto 0);

  -- UTC core
  signal trigger_p   : std_logic;
  signal acq_start_p : std_logic;
  signal acq_stop_p  : std_logic;
  signal acq_end_p   : std_logic;

  -- Tests
  signal led_cnt       : unsigned(26 downto 0);
  signal led_pps       : std_logic;


begin


  ------------------------------------------------------------------------------
  -- Clocks distribution from 20MHz TCXO
  -- 125.000 MHz system clock
  -- 250.000 MHz fast system clock
  -- 333.333 MHz DDR3 clock
  ------------------------------------------------------------------------------
  cmp_sys_clk_buf : IBUFG
    port map (
      I => clk20_vcxo_i,
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
      CLKOUT1_DIVIDE     => 4,
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
      CLKOUT1  => sys_clk_250_buf,
      CLKOUT2  => ddr_clk_buf,
      CLKOUT3  => open,
      CLKOUT4  => open,
      CLKOUT5  => open,
      LOCKED   => sys_clk_pll_locked,
      RST      => '0',
      CLKFBIN  => sys_clk_fb,
      CLKIN    => sys_clk_in);

  cmp_clk_125_buf : BUFG
    port map (
      O => sys_clk_125,
      I => sys_clk_125_buf);

  cmp_clk_250_buf : BUFG
    port map (
      O => sys_clk_250,
      I => sys_clk_250_buf);

  cmp_ddr_clk_buf : BUFG
    port map (
      O => ddr_clk,
      I => ddr_clk_buf);

  ------------------------------------------------------------------------------
  -- Local clock from gennum LCLK
  ------------------------------------------------------------------------------
  cmp_l_clk_buf : IBUFDS
    generic map (
      DIFF_TERM    => false,            -- Differential Termination
      IBUF_LOW_PWR => true,             -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD   => "DEFAULT")
    port map (
      O  => l_clk,                      -- Buffer output
      I  => L_CLKp,                     -- Diff_p buffer input (connect directly to top-level port)
      IB => L_CLKn                      -- Diff_n buffer input (connect directly to top-level port)
      );

  ------------------------------------------------------------------------------
  -- System reset
  ------------------------------------------------------------------------------
  sys_rst_n <= L_RST_N and sys_clk_pll_locked;
  sys_rst   <= not(sys_rst_n);

  ------------------------------------------------------------------------------
  -- GN4124 interface
  ------------------------------------------------------------------------------
  cmp_gn4124_core : gn4124_core
    port map(
      rst_n_a_i       => L_RST_N,
      status_o        => gn4124_status,
      -- P2L Direction Source Sync DDR related signals
      p2l_clk_p_i     => P2L_CLKp,
      p2l_clk_n_i     => P2L_CLKn,
      p2l_data_i      => P2L_DATA,
      p2l_dframe_i    => P2L_DFRAME,
      p2l_valid_i     => P2L_VALID,
      -- P2L Control
      p2l_rdy_o       => P2L_RDY,
      p_wr_req_i      => P_WR_REQ,
      p_wr_rdy_o      => P_WR_RDY,
      rx_error_o      => RX_ERROR,
      -- L2P Direction Source Sync DDR related signals
      l2p_clk_p_o     => L2P_CLKp,
      l2p_clk_n_o     => L2P_CLKn,
      l2p_data_o      => L2P_DATA,
      l2p_dframe_o    => L2P_DFRAME,
      l2p_valid_o     => L2P_VALID,
      l2p_edb_o       => L2P_EDB,
      -- L2P Control
      l2p_rdy_i       => L2P_RDY,
      l_wr_rdy_i      => L_WR_RDY,
      p_rd_d_rdy_i    => P_RD_D_RDY,
      tx_error_i      => TX_ERROR,
      vc_rdy_i        => VC_RDY,
      -- Interrupt interface
      dma_irq_o       => dma_irq,
      irq_p_i         => irq_to_gn4124,
      irq_p_o         => GPIO(0),
      -- DMA registers wishbone interface (slave classic)
      dma_reg_clk_i   => sys_clk_125,
      dma_reg_adr_i   => dma_ctrl_wb_adr,
      dma_reg_dat_i   => cnx_master_out(c_SLAVE_DMA).dat,
      dma_reg_sel_i   => cnx_master_out(c_SLAVE_DMA).sel,
      dma_reg_stb_i   => cnx_master_out(c_SLAVE_DMA).stb,
      dma_reg_we_i    => cnx_master_out(c_SLAVE_DMA).we,
      dma_reg_cyc_i   => cnx_master_out(c_SLAVE_DMA).cyc,
      dma_reg_dat_o   => cnx_master_in(c_SLAVE_DMA).dat,
      dma_reg_ack_o   => cnx_master_in(c_SLAVE_DMA).ack,
      dma_reg_stall_o => cnx_master_in(c_SLAVE_DMA).stall,
      -- CSR wishbone interface (master pipelined)
      csr_clk_i       => sys_clk_125,
      csr_adr_o       => gn_wb_adr,
      csr_dat_o       => cnx_slave_in(c_MASTER_GENNUM).dat,
      csr_sel_o       => cnx_slave_in(c_MASTER_GENNUM).sel,
      csr_stb_o       => cnx_slave_in(c_MASTER_GENNUM).stb,
      csr_we_o        => cnx_slave_in(c_MASTER_GENNUM).we,
      csr_cyc_o       => cnx_slave_in(c_MASTER_GENNUM).cyc,
      csr_dat_i       => cnx_slave_out(c_MASTER_GENNUM).dat,
      csr_ack_i       => cnx_slave_out(c_MASTER_GENNUM).ack,
      csr_stall_i     => cnx_slave_out(c_MASTER_GENNUM).stall,
      -- DMA wishbone interface (pipelined)
      dma_clk_i       => sys_clk_125,
      dma_adr_o       => wb_dma_adr,
      dma_dat_o       => wb_dma_dat_o,
      dma_sel_o       => wb_dma_sel,
      dma_stb_o       => wb_dma_stb,
      dma_we_o        => wb_dma_we,
      dma_cyc_o       => wb_dma_cyc,
      dma_dat_i       => wb_dma_dat_i,
      dma_ack_i       => wb_dma_ack,
      dma_stall_i     => wb_dma_stall
      );

  p2l_pll_locked <= gn4124_status(0);

  -- Convert 32-bit word address into byte address for crossbar
  cnx_slave_in(c_MASTER_GENNUM).adr <= gn_wb_adr(29 downto 0) & "00";

  -- Convert 32-bit byte address into word address for DMA controller
  dma_ctrl_wb_adr <= "00" & cnx_master_out(c_SLAVE_DMA).adr(31 downto 2);

  -- Unused wishbone signals
  cnx_master_in(c_SLAVE_DMA).err <= '0';
  cnx_master_in(c_SLAVE_DMA).rty <= '0';
  cnx_master_in(c_SLAVE_DMA).int <= '0';

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
  -- Carrier SPI master
  --    VCXO DAC control
  ------------------------------------------------------------------------------


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

      slave_i => cnx_master_out(c_SLAVE_ONEWIRE),
      slave_o => cnx_master_in(c_SLAVE_ONEWIRE),
      desc_o  => open,

      owr_pwren_o => carrier_owr_pwren,
      owr_en_o    => carrier_owr_en,
      owr_i       => carrier_owr_i
      );

  carrier_one_wire_b <= '0' when carrier_owr_en(0) = '1' else 'Z';
  carrier_owr_i(0)   <= carrier_one_wire_b;

  ------------------------------------------------------------------------------
  -- Carrier CSR
  --    Carrier type and PCB version
  --    Bitstream (firmware) type and date
  --    Release tag
  --    VCXO DAC control (CLR_N)
  ------------------------------------------------------------------------------
  cmp_carrier_csr : carrier_csr
    port map(
      rst_n_i                          => sys_rst_n,
      wb_clk_i                         => sys_clk_125,
      wb_addr_i                        => cnx_master_out(c_SLAVE_SPEC_CSR).adr(4 downto 2),  -- cnx_master_out.adr is byte address
      wb_data_i                        => cnx_master_out(c_SLAVE_SPEC_CSR).dat,
      wb_data_o                        => cnx_master_in(c_SLAVE_SPEC_CSR).dat,
      wb_cyc_i                         => cnx_master_out(c_SLAVE_SPEC_CSR).cyc,
      wb_sel_i                         => cnx_master_out(c_SLAVE_SPEC_CSR).sel,
      wb_stb_i                         => cnx_master_out(c_SLAVE_SPEC_CSR).stb,
      wb_we_i                          => cnx_master_out(c_SLAVE_SPEC_CSR).we,
      wb_ack_o                         => cnx_master_in(c_SLAVE_SPEC_CSR).ack,
      carrier_csr_carrier_pcb_rev_i    => pcb_ver_i,
      carrier_csr_carrier_reserved_i   => X"000",
      carrier_csr_carrier_type_i       => c_CARRIER_TYPE,
      carrier_csr_bitstream_type_i     => c_BITSTREAM_TYPE,
      carrier_csr_bitstream_date_i     => c_BITSTREAM_DATE,
      carrier_csr_stat_fmc_pres_i      => prsnt_m2c_n_i,
      carrier_csr_stat_p2l_pll_lck_i   => p2l_pll_locked,
      carrier_csr_stat_sys_pll_lck_i   => sys_clk_pll_locked,
      carrier_csr_stat_ddr3_cal_done_i => ddr3_calib_done,
      carrier_csr_stat_reserved_i      => (others => '0'),
      carrier_csr_ctrl_led_green_o     => led_green,
      carrier_csr_ctrl_led_red_o       => led_red,
      carrier_csr_ctrl_dac_clr_n_o     => open,
      carrier_csr_ctrl_reserved_o      => open
      );

  -- Unused wishbone signals
  cnx_master_in(c_SLAVE_SPEC_CSR).err   <= '0';
  cnx_master_in(c_SLAVE_SPEC_CSR).rty   <= '0';
  cnx_master_in(c_SLAVE_SPEC_CSR).stall <= '0';
  cnx_master_in(c_SLAVE_SPEC_CSR).int   <= '0';

  gen_irq_led : for I in 0 to 1 generate
    cmp_irq_led : gc_extend_pulse
      generic map (
        g_width => 5000000)
      port map (
        clk_i      => sys_clk_125,
        rst_n_i    => sys_rst_n,
        pulse_i    => irq_sources(I),
        extended_o => irq_sources_2_led(I));
  end generate gen_irq_led;

  led_red_o   <= led_red or irq_sources_2_led(0);
  led_green_o <= led_green or irq_sources_2_led(1);

  ------------------------------------------------------------------------------
  -- UTC core
  ------------------------------------------------------------------------------
  cmp_utc_core : utc_core
    port map(
      clk_i   => sys_clk_125,
      rst_n_i => sys_rst_n,

      trigger_p_i   => trigger_p,
      acq_start_p_i => acq_start_p,
      acq_stop_p_i  => acq_stop_p,
      acq_end_p_i   => acq_end_p,

      wb_adr_i => cnx_master_out(c_SLAVE_UTC).adr(6 downto 2),  -- cnx_master_out.adr is byte address
      wb_dat_i => cnx_master_out(c_SLAVE_UTC).dat,
      wb_dat_o => cnx_master_in(c_SLAVE_UTC).dat,
      wb_cyc_i => cnx_master_out(c_SLAVE_UTC).cyc,
      wb_sel_i => cnx_master_out(c_SLAVE_UTC).sel,
      wb_stb_i => cnx_master_out(c_SLAVE_UTC).stb,
      wb_we_i  => cnx_master_out(c_SLAVE_UTC).we,
      wb_ack_o => cnx_master_in(c_SLAVE_UTC).ack
      );

  -- Unused wishbone signals
  cnx_master_in(c_SLAVE_UTC).err   <= '0';
  cnx_master_in(c_SLAVE_UTC).rty   <= '0';
  cnx_master_in(c_SLAVE_UTC).stall <= '0';
  cnx_master_in(c_SLAVE_UTC).int   <= '0';

  ------------------------------------------------------------------------------
  -- Interrupt controller
  ------------------------------------------------------------------------------
  cmp_irq_controller : irq_controller
    port map(
      clk_i   => sys_clk_125,
      rst_n_i => sys_rst_n,

      irq_src_p_i => irq_sources,

      irq_p_o => irq_to_gn4124,

      wb_adr_i => cnx_master_out(c_SLAVE_INT).adr(3 downto 2),  -- cnx_master_out.adr is byte address
      wb_dat_i => cnx_master_out(c_SLAVE_INT).dat,
      wb_dat_o => cnx_master_in(c_SLAVE_INT).dat,
      wb_cyc_i => cnx_master_out(c_SLAVE_INT).cyc,
      wb_sel_i => cnx_master_out(c_SLAVE_INT).sel,
      wb_stb_i => cnx_master_out(c_SLAVE_INT).stb,
      wb_we_i  => cnx_master_out(c_SLAVE_INT).we,
      wb_ack_o => cnx_master_in(c_SLAVE_INT).ack
      );

  -- Unused wishbone signals
  cnx_master_in(c_SLAVE_INT).err   <= '0';
  cnx_master_in(c_SLAVE_INT).rty   <= '0';
  cnx_master_in(c_SLAVE_INT).stall <= '0';
  cnx_master_in(c_SLAVE_INT).int   <= '0';

  -- IRQ sources
  --   0    -> End of DMA transfer
  --   1    -> DMA transfer error
  --   2    -> Trigger
  --   3    -> End of acquisition (data written to DDR)
  --   4-31 -> Unused
  irq_sources(1 downto 0)  <= dma_irq;
  irq_sources(2)           <= trigger_p;
  irq_sources(3)           <= acq_end_irq_p;
  irq_sources(31 downto 4) <= (others => '0');

  -- End of acquisition interrupt generation
  p_ddr_wr_fifo_empty : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      ddr_wr_fifo_empty_d <= ddr_wr_fifo_empty;
    end if;
  end process p_ddr_wr_fifo_empty;

  ddr_wr_fifo_empty_p <= ddr_wr_fifo_empty and not(ddr_wr_fifo_empty_d);

  p_acq_end : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if sys_rst_n = '0' then
        acq_end <= '0';
      elsif acq_end_p = '1' then
        acq_end <= '1';
      elsif ddr_wr_fifo_empty_p = '1' then
        acq_end <= '0';
      end if;
    end if;
  end process p_acq_end;

  acq_end_irq_p <= ddr_wr_fifo_empty_p and acq_end;

  ------------------------------------------------------------------------------
  -- Mezzanine system managment I2C master
  --    Access to mezzanine EEPROM
  ------------------------------------------------------------------------------
  cmp_fmc_sys_i2c : xwb_i2c_master
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE
      )
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      slave_i => cnx_master_out(c_SLAVE_FMC_SYS_I2C),
      slave_o => cnx_master_in(c_SLAVE_FMC_SYS_I2C),
      desc_o  => open,

      scl_pad_i    => sys_scl_in,
      scl_pad_o    => sys_scl_out,
      scl_padoen_o => sys_scl_oe_n,
      sda_pad_i    => sys_sda_in,
      sda_pad_o    => sys_sda_out,
      sda_padoen_o => sys_sda_oe_n
      );

  -- Tri-state buffer for SDA and SCL
  sys_scl_b  <= sys_scl_out when sys_scl_oe_n = '0' else 'Z';
  sys_scl_in <= sys_scl_b;

  sys_sda_b  <= sys_sda_out when sys_sda_oe_n = '0' else 'Z';
  sys_sda_in <= sys_sda_b;

  ------------------------------------------------------------------------------
  -- Mezzanine SPI master
  --    Offset DACs control
  --    ADC control
  ------------------------------------------------------------------------------
  cmp_fmc_spi : xwb_spi
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE
      )
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      slave_i => cnx_master_out(c_SLAVE_FMC_SPI),
      slave_o => cnx_master_in(c_SLAVE_FMC_SPI),
      desc_o  => open,

      pad_cs_o   => spi_ss_t,
      pad_sclk_o => spi_sck_o,
      pad_mosi_o => spi_dout_o,
      pad_miso_i => spi_din_t(spi_din_t'left)
      );

  -- Assign slave select lines
  spi_cs_adc_n_o  <= spi_ss_t(0);
  spi_cs_dac1_n_o <= spi_ss_t(1);
  spi_cs_dac2_n_o <= spi_ss_t(2);
  spi_cs_dac3_n_o <= spi_ss_t(3);
  spi_cs_dac4_n_o <= spi_ss_t(4);

  -- Add some FF after the input pin to solve timing problem
  p_fmc_spi : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if sys_rst_n = '0' then
        spi_din_t <= (others => '0');
      else
        spi_din_t <= spi_din_t(spi_din_t'left-1 downto 0) & spi_din_i;
      end if;
    end if;
  end process p_fmc_spi;

  ------------------------------------------------------------------------------
  -- Mezzanine I2C
  --    Si570 control
  --
  -- Note: I2C registers are 8-bit wide, but accessed as 32-bit registers
  ------------------------------------------------------------------------------
  cmp_fmc_i2c : xwb_i2c_master
    generic map(
      g_interface_mode      => CLASSIC,
      g_address_granularity => BYTE
      )
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      slave_i => cnx_master_out(c_SLAVE_FMC_I2C),
      slave_o => cnx_master_in(c_SLAVE_FMC_I2C),
      desc_o  => open,

      scl_pad_i    => si570_scl_in,
      scl_pad_o    => si570_scl_out,
      scl_padoen_o => si570_scl_oe_n,
      sda_pad_i    => si570_sda_in,
      sda_pad_o    => si570_sda_out,
      sda_padoen_o => si570_sda_oe_n
      );

  -- Tri-state buffer for SDA and SCL
  si570_scl_b  <= si570_scl_out when si570_scl_oe_n = '0' else 'Z';
  si570_scl_in <= si570_scl_b;

  si570_sda_b  <= si570_sda_out when si570_sda_oe_n = '0' else 'Z';
  si570_sda_in <= si570_sda_b;

  ------------------------------------------------------------------------------
  -- ADC core
  --    Solid State Relays control
  --    Si570 output enable
  --    Offset DACs control (CLR_N)
  --    ADC core control and status
  ------------------------------------------------------------------------------
  cmp_fmc_adc_100Ms_core : fmc_adc_100Ms_core
    port map(
      sys_clk_i   => sys_clk_125,
      sys_rst_n_i => sys_rst_n,

      wb_csr_adr_i => cnx_master_out(c_SLAVE_FMC_ADC).adr(6 downto 2),  -- cnx_master_out.adr is byte address
      wb_csr_dat_i => cnx_master_out(c_SLAVE_FMC_ADC).dat,
      wb_csr_dat_o => cnx_master_in(c_SLAVE_FMC_ADC).dat,
      wb_csr_cyc_i => cnx_master_out(c_SLAVE_FMC_ADC).cyc,
      wb_csr_sel_i => cnx_master_out(c_SLAVE_FMC_ADC).sel,
      wb_csr_stb_i => cnx_master_out(c_SLAVE_FMC_ADC).stb,
      wb_csr_we_i  => cnx_master_out(c_SLAVE_FMC_ADC).we,
      wb_csr_ack_o => cnx_master_in(c_SLAVE_FMC_ADC).ack,

      wb_ddr_clk_i   => sys_clk_125,
      wb_ddr_adr_o   => wb_ddr_adr,
      wb_ddr_dat_o   => wb_ddr_dat_o,
      wb_ddr_sel_o   => wb_ddr_sel,
      wb_ddr_stb_o   => wb_ddr_stb,
      wb_ddr_we_o    => wb_ddr_we,
      wb_ddr_cyc_o   => wb_ddr_cyc,
      wb_ddr_ack_i   => wb_ddr_ack,
      wb_ddr_stall_i => wb_ddr_stall,

      trigger_p_o   => trigger_p,
      acq_start_p_o => acq_start_p,
      acq_stop_p_o  => acq_stop_p,
      acq_end_p_o   => acq_end_p,

      ext_trigger_p_i => ext_trigger_p_i,
      ext_trigger_n_i => ext_trigger_n_i,

      adc_dco_p_i  => adc_dco_p_i,
      adc_dco_n_i  => adc_dco_n_i,
      adc_fr_p_i   => adc_fr_p_i,
      adc_fr_n_i   => adc_fr_n_i,
      adc_outa_p_i => adc_outa_p_i,
      adc_outa_n_i => adc_outa_n_i,
      adc_outb_p_i => adc_outb_p_i,
      adc_outb_n_i => adc_outb_n_i,

      gpio_dac_clr_n_o => gpio_dac_clr_n_o,
      gpio_led_acq_o   => gpio_led_power_o,
      gpio_led_trig_o  => gpio_led_trigger_o,
      gpio_ssr_ch1_o   => gpio_ssr_ch1_o,
      gpio_ssr_ch2_o   => gpio_ssr_ch2_o,
      gpio_ssr_ch3_o   => gpio_ssr_ch3_o,
      gpio_ssr_ch4_o   => gpio_ssr_ch4_o,
      gpio_si570_oe_o  => gpio_si570_oe_o
      );

  -- Unused wishbone signals
  cnx_master_in(c_SLAVE_FMC_ADC).err   <= '0';
  cnx_master_in(c_SLAVE_FMC_ADC).rty   <= '0';
  cnx_master_in(c_SLAVE_FMC_ADC).stall <= '0';
  cnx_master_in(c_SLAVE_FMC_ADC).int   <= '0';

  ------------------------------------------------------------------------------
  -- Mezzanine 1-wire master
  --    DS18B20 (thermometer + unique ID)
  ------------------------------------------------------------------------------
  cmp_fmc_onewire : xwb_onewire_master
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

      slave_i => cnx_master_out(c_SLAVE_FMC_ONEWIRE),
      slave_o => cnx_master_in(c_SLAVE_FMC_ONEWIRE),
      desc_o  => open,

      owr_pwren_o => mezz_owr_pwren,
      owr_en_o    => mezz_owr_en,
      owr_i       => mezz_owr_i
      );

  mezz_one_wire_b <= '0' when mezz_owr_en(0) = '1' else 'Z';
  mezz_owr_i(0)   <= mezz_one_wire_b;

  ------------------------------------------------------------------------------
  -- DMA wishbone bus slaves
  --  -> DDR3 controller
  ------------------------------------------------------------------------------
  cmp_ddr_ctrl : ddr3_ctrl
    generic map(
      g_BANK_PORT_SELECT   => "SPEC_BANK3_64B_32B",
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
      rst_n_i => sys_rst_n,

      status_o => ddr3_status,

      ddr3_dq_b     => DDR3_DQ,
      ddr3_a_o      => DDR3_A,
      ddr3_ba_o     => DDR3_BA,
      ddr3_ras_n_o  => DDR3_RAS_N,
      ddr3_cas_n_o  => DDR3_CAS_N,
      ddr3_we_n_o   => DDR3_WE_N,
      ddr3_odt_o    => DDR3_ODT,
      ddr3_rst_n_o  => DDR3_RESET_N,
      ddr3_cke_o    => DDR3_CKE,
      ddr3_dm_o     => DDR3_LDM,
      ddr3_udm_o    => DDR3_UDM,
      ddr3_dqs_p_b  => DDR3_LDQS_P,
      ddr3_dqs_n_b  => DDR3_LDQS_N,
      ddr3_udqs_p_b => DDR3_UDQS_P,
      ddr3_udqs_n_b => DDR3_UDQS_N,
      ddr3_clk_p_o  => DDR3_CK_P,
      ddr3_clk_n_o  => DDR3_CK_N,
      ddr3_rzq_b    => DDR3_RZQ,
      ddr3_zio_b    => DDR3_ZIO,

      wb0_clk_i   => sys_clk_125,
      wb0_sel_i   => wb_ddr_sel,
      wb0_cyc_i   => wb_ddr_cyc,
      wb0_stb_i   => wb_ddr_stb,
      wb0_we_i    => wb_ddr_we,
      wb0_addr_i  => wb_ddr_adr,
      wb0_data_i  => wb_ddr_dat_o,
      wb0_data_o  => open,
      wb0_ack_o   => wb_ddr_ack,
      wb0_stall_o => wb_ddr_stall,

      p0_cmd_empty_o   => open,
      p0_cmd_full_o    => open,
      p0_rd_full_o     => open,
      p0_rd_empty_o    => open,
      p0_rd_count_o    => open,
      p0_rd_overflow_o => open,
      p0_rd_error_o    => open,
      p0_wr_full_o     => open,
      p0_wr_empty_o    => ddr_wr_fifo_empty,
      p0_wr_count_o    => open,
      p0_wr_underrun_o => open,
      p0_wr_error_o    => open,

      wb1_clk_i   => sys_clk_125,
      wb1_sel_i   => wb_dma_sel,
      wb1_cyc_i   => wb_dma_cyc,
      wb1_stb_i   => wb_dma_stb,
      wb1_we_i    => wb_dma_we,
      wb1_addr_i  => wb_dma_adr,
      wb1_data_i  => wb_dma_dat_o,
      wb1_data_o  => wb_dma_dat_i,
      wb1_ack_o   => wb_dma_ack,
      wb1_stall_o => wb_dma_stall,

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

  ddr3_calib_done <= ddr3_status(0);

  ------------------------------------------------------------------------------
  -- Assign unused outputs
  ------------------------------------------------------------------------------
  GPIO(1) <= '0';

  ------------------------------------------------------------------------------
  -- Blink auxiliary LEDs
  ------------------------------------------------------------------------------
  p_led_cnt : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if (sys_rst_n = '0') then
        led_cnt <= (others => '0');
        led_pps <= '0';
      elsif (led_cnt = X"773593F") then
        led_cnt <= (others => '0');
        led_pps <= not(led_pps);
      else
        led_cnt <= led_cnt + 1;
      end if;
    end if;
  end process p_led_cnt;

  p_led_blink : process (sys_clk_125)
  begin
    if rising_edge(sys_clk_125) then
      if sys_rst_n = '0' then
        aux_leds_o <= X"5";
      elsif led_pps = '1' then
        aux_leds_o <= X"A";
      else
        aux_leds_o <= X"5";
      end if;
    end if;
  end process p_led_blink;


end rtl;
