--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- FMC ADC mezzanine
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: fmc_adc_mezzanine (fmc_adc_mezzanine.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 07-05-2013
--
-- description: The FMC ADC mezzanine is wrapper around the fmc-adc-100ms core and
--              the other wishbone slaves connected to a FMC ADC mezzanine.
--
-- dependencies:
--
-- references:
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


library work;
use work.fmc_adc_100Ms_core_pkg.all;
use work.wishbone_pkg.all;


entity fmc_adc_mezzanine is
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
    ext_trigger_p_i : in std_logic;     -- External trigger
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

    spi_din_i       : in  std_logic;    -- SPI data from FMC
    spi_dout_o      : out std_logic;    -- SPI data to FMC
    spi_sck_o       : out std_logic;    -- SPI clock
    spi_cs_adc_n_o  : out std_logic;    -- SPI ADC chip select (active low)
    spi_cs_dac1_n_o : out std_logic;    -- SPI channel 1 offset DAC chip select (active low)
    spi_cs_dac2_n_o : out std_logic;    -- SPI channel 2 offset DAC chip select (active low)
    spi_cs_dac3_n_o : out std_logic;    -- SPI channel 3 offset DAC chip select (active low)
    spi_cs_dac4_n_o : out std_logic;    -- SPI channel 4 offset DAC chip select (active low)

    si570_scl_b : inout std_logic;      -- I2C bus clock (Si570)
    si570_sda_b : inout std_logic;      -- I2C bus data (Si570)

    mezz_one_wire_b : inout std_logic;  -- Mezzanine 1-wire interface (DS18B20 thermometer + unique ID)

    sys_scl_b : inout std_logic;        -- Mezzanine system I2C clock (EEPROM)
    sys_sda_b : inout std_logic         -- Mezzanine system I2C data (EEPROM)
    );
end fmc_adc_mezzanine;


architecture rtl of fmc_adc_mezzanine is

  ------------------------------------------------------------------------------
  -- SDB crossbar constants declaration
  --
  -- WARNING: All address in sdb and crossbar are BYTE addresses!
  ------------------------------------------------------------------------------

  -- Number of master port(s) on the wishbone crossbar
  constant c_NUM_WB_MASTERS : integer := 5;

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_SLAVES : integer := 1;

  -- Wishbone master(s)
  constant c_WB_MASTER : integer := 0;

  -- Wishbone slave(s)
  constant c_WB_SLAVE_FMC_SYS_I2C : integer := 0;  -- Mezzanine system I2C interface (EEPROM)
  constant c_WB_SLAVE_FMC_SPI     : integer := 1;  -- Mezzanine SPI interface
  constant c_WB_SLAVE_FMC_I2C     : integer := 2;  -- Mezzanine I2C controller
  constant c_WB_SLAVE_FMC_ADC     : integer := 3;  -- Mezzanine ADC core
  constant c_WB_SLAVE_FMC_ONEWIRE : integer := 4;  -- Mezzanine onewire interface

  -- Devices sdb description
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

  constant c_I2C_SDB_DEVICE : t_sdb_device := (
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
      addr_last   => x"000000000000001F",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000607",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-SPI.Control     ")));

  constant c_ADC_CSR_SDB_DEVICE : t_sdb_device := (
    abi_class     => x"0000",              -- undocumented device
    abi_ver_major => x"01",
    abi_ver_minor => x"01",
    wbd_endian    => c_sdb_endian_big,
    wbd_width     => x"4",                 -- 32-bit port granularity
    sdb_component => (
      addr_first  => x"0000000000000000",
      addr_last   => x"000000000000007F",
      product     => (
        vendor_id => x"000000000000CE42",  -- CERN
        device_id => x"00000608",
        version   => x"00000001",
        date      => x"20121116",
        name      => "WB-FMC-ADC-Core    ")));

  -- sdb header address
  constant c_SDB_ADDRESS : t_wishbone_address := x"00000000";

  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(4 downto 0) :=
    (
      0 => f_sdb_embed_device(c_I2C_SDB_DEVICE, x"00001000"),
      1 => f_sdb_embed_device(c_SPI_SDB_DEVICE, x"00001100"),
      2 => f_sdb_embed_device(c_I2C_SDB_DEVICE, x"00001200"),
      3 => f_sdb_embed_device(c_ADC_CSR_SDB_DEVICE, x"00001300"),
      4 => f_sdb_embed_device(c_ONEWIRE_SDB_DEVICE, x"00001400")
      );


  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------

  -- Wishbone buse(s) from crossbar master port(s)
  signal cnx_master_out : t_wishbone_master_out_array(c_NUM_WB_MASTERS-1 downto 0);
  signal cnx_master_in  : t_wishbone_master_in_array(c_NUM_WB_MASTERS-1 downto 0);

  -- Wishbone buse(s) to crossbar slave port(s)
  signal cnx_slave_out : t_wishbone_slave_out_array(c_NUM_WB_SLAVES-1 downto 0);
  signal cnx_slave_in  : t_wishbone_slave_in_array(c_NUM_WB_SLAVES-1 downto 0);

  -- Mezzanine system I2C for EEPROM
  signal sys_scl_in   : std_logic;
  signal sys_scl_out  : std_logic;
  signal sys_scl_oe_n : std_logic;
  signal sys_sda_in   : std_logic;
  signal sys_sda_out  : std_logic;
  signal sys_sda_oe_n : std_logic;

  -- Mezzanine SPI
  signal spi_din_t : std_logic_vector(3 downto 0);
  signal spi_ss_t  : std_logic_vector(7 downto 0);

  -- Mezzanine I2C for Si570
  signal si570_scl_in   : std_logic;
  signal si570_scl_out  : std_logic;
  signal si570_scl_oe_n : std_logic;
  signal si570_sda_in   : std_logic;
  signal si570_sda_out  : std_logic;
  signal si570_sda_oe_n : std_logic;

  -- Mezzanine 1-wire
  signal mezz_owr_en    : std_logic_vector(0 downto 0);
  signal mezz_owr_i     : std_logic_vector(0 downto 0);


begin

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
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,
      slave_i   => cnx_slave_in,
      slave_o   => cnx_slave_out,
      master_i  => cnx_master_in,
      master_o  => cnx_master_out);

  -- Connect crossbar slave port to entity port
  cnx_slave_in(c_WB_MASTER).adr <= wb_csr_adr_i;
  cnx_slave_in(c_WB_MASTER).dat <= wb_csr_dat_i;
  cnx_slave_in(c_WB_MASTER).sel <= wb_csr_sel_i;
  cnx_slave_in(c_WB_MASTER).stb <= wb_csr_stb_i;
  cnx_slave_in(c_WB_MASTER).we  <= wb_csr_we_i;
  cnx_slave_in(c_WB_MASTER).cyc <= wb_csr_cyc_i;

  wb_csr_dat_o   <= cnx_slave_out(c_WB_MASTER).dat;
  wb_csr_ack_o   <= cnx_slave_out(c_WB_MASTER).ack;
  wb_csr_stall_o <= cnx_slave_out(c_WB_MASTER).stall;

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
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_master_out(c_WB_SLAVE_FMC_SYS_I2C),
      slave_o => cnx_master_in(c_WB_SLAVE_FMC_SYS_I2C),
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
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_master_out(c_WB_SLAVE_FMC_SPI),
      slave_o => cnx_master_in(c_WB_SLAVE_FMC_SPI),
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
  p_fmc_spi : process (sys_clk_i)
  begin
    if rising_edge(sys_clk_i) then
      if sys_rst_n_i = '0' then
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
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_master_out(c_WB_SLAVE_FMC_I2C),
      slave_o => cnx_master_in(c_WB_SLAVE_FMC_I2C),
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
    generic map (
      g_multishot_ram_size => g_multishot_ram_size,
      g_carrier_type => g_carrier_type
      )
    port map(
      sys_clk_i   => sys_clk_i,
      sys_rst_n_i => sys_rst_n_i,

      wb_csr_adr_i => cnx_master_out(c_WB_SLAVE_FMC_ADC).adr(6 downto 2),  -- cnx_master_out.adr is byte address
      wb_csr_dat_i => cnx_master_out(c_WB_SLAVE_FMC_ADC).dat,
      wb_csr_dat_o => cnx_master_in(c_WB_SLAVE_FMC_ADC).dat,
      wb_csr_cyc_i => cnx_master_out(c_WB_SLAVE_FMC_ADC).cyc,
      wb_csr_sel_i => cnx_master_out(c_WB_SLAVE_FMC_ADC).sel,
      wb_csr_stb_i => cnx_master_out(c_WB_SLAVE_FMC_ADC).stb,
      wb_csr_we_i  => cnx_master_out(c_WB_SLAVE_FMC_ADC).we,
      wb_csr_ack_o => cnx_master_in(c_WB_SLAVE_FMC_ADC).ack,

      wb_ddr_clk_i   => sys_clk_i,
      wb_ddr_adr_o   => wb_ddr_adr_o,
      wb_ddr_dat_o   => wb_ddr_dat_o,
      wb_ddr_sel_o   => wb_ddr_sel_o,
      wb_ddr_stb_o   => wb_ddr_stb_o,
      wb_ddr_we_o    => wb_ddr_we_o,
      wb_ddr_cyc_o   => wb_ddr_cyc_o,
      wb_ddr_ack_i   => wb_ddr_ack_i,
      wb_ddr_stall_i => wb_ddr_stall_i,

      trigger_p_o   => trigger_p_o,
      acq_start_p_o => acq_start_p_o,
      acq_stop_p_o  => acq_stop_p_o,
      acq_end_p_o   => acq_end_p_o,

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
      gpio_led_acq_o   => gpio_led_acq_o,
      gpio_led_trig_o  => gpio_led_trig_o,
      gpio_ssr_ch1_o   => gpio_ssr_ch1_o,
      gpio_ssr_ch2_o   => gpio_ssr_ch2_o,
      gpio_ssr_ch3_o   => gpio_ssr_ch3_o,
      gpio_ssr_ch4_o   => gpio_ssr_ch4_o,
      gpio_si570_oe_o  => gpio_si570_oe_o
      );

  -- Unused wishbone signals
  cnx_master_in(c_WB_SLAVE_FMC_ADC).err   <= '0';
  cnx_master_in(c_WB_SLAVE_FMC_ADC).rty   <= '0';
  cnx_master_in(c_WB_SLAVE_FMC_ADC).stall <= '0';
  cnx_master_in(c_WB_SLAVE_FMC_ADC).int   <= '0';

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
      clk_sys_i => sys_clk_i,
      rst_n_i   => sys_rst_n_i,

      slave_i => cnx_master_out(c_WB_SLAVE_FMC_ONEWIRE),
      slave_o => cnx_master_in(c_WB_SLAVE_FMC_ONEWIRE),
      desc_o  => open,

      owr_pwren_o => open,
      owr_en_o    => mezz_owr_en,
      owr_i       => mezz_owr_i
      );

  mezz_one_wire_b <= '0' when mezz_owr_en(0) = '1' else 'Z';
  mezz_owr_i(0)   <= mezz_one_wire_b;

end rtl;
