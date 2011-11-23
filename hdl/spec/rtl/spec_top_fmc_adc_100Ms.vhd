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
  component wb_addr_decoder
    generic
      (
        g_WINDOW_SIZE  : integer := 18;  -- Number of bits to address periph on the board (32-bit word address)
        g_WB_SLAVES_NB : integer := 2
        );
    port
      (
        ---------------------------------------------------------
        -- GN4124 core clock and reset
        clk_i   : in std_logic;
        rst_n_i : in std_logic;

        ---------------------------------------------------------
        -- wishbone master interface
        wbm_adr_i   : in  std_logic_vector(31 downto 0);  -- Address
        wbm_dat_i   : in  std_logic_vector(31 downto 0);  -- Data out
        wbm_sel_i   : in  std_logic_vector(3 downto 0);   -- Byte select
        wbm_stb_i   : in  std_logic;                      -- Strobe
        wbm_we_i    : in  std_logic;                      -- Write
        wbm_cyc_i   : in  std_logic;                      -- Cycle
        wbm_dat_o   : out std_logic_vector(31 downto 0);  -- Data in
        wbm_ack_o   : out std_logic;                      -- Acknowledge
        wbm_stall_o : out std_logic;                      -- Stall

        ---------------------------------------------------------
        -- wishbone slaves interface
        wb_adr_o   : out std_logic_vector(31 downto 0);                     -- Address
        wb_dat_o   : out std_logic_vector(31 downto 0);                     -- Data out
        wb_sel_o   : out std_logic_vector(3 downto 0);                      -- Byte select
        wb_stb_o   : out std_logic;                                         -- Strobe
        wb_we_o    : out std_logic;                                         -- Write
        wb_cyc_o   : out std_logic_vector(g_WB_SLAVES_NB-1 downto 0);       -- Cycle
        wb_dat_i   : in  std_logic_vector((32*g_WB_SLAVES_NB)-1 downto 0);  -- Data in
        wb_ack_i   : in  std_logic_vector(g_WB_SLAVES_NB-1 downto 0);       -- Acknowledge
        wb_stall_i : in  std_logic_vector(g_WB_SLAVES_NB-1 downto 0)        -- Stall
        );
  end component wb_addr_decoder;

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

  component fmc_adc_100Ms_core
    port (
      -- Clock, reset
      sys_clk_i   : in std_logic;
      sys_rst_n_i : in std_logic;

      -- CSR wishbone interface
      wb_csr_adr_i : in  std_logic_vector(4 downto 0);
      wb_csr_dat_i : in  std_logic_vector(31 downto 0);
      wb_csr_dat_o : out std_logic_vector(31 downto 0);
      wb_csr_cyc_i : in  std_logic;
      wb_csr_sel_i : in  std_logic_vector(3 downto 0);
      wb_csr_stb_i : in  std_logic;
      wb_csr_we_i  : in  std_logic;
      wb_csr_ack_o : out std_logic;

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

      -- Events output pulses
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
      gpio_si570_oe_o  : out std_logic                      -- Si570 (programmable oscillator) output enable
      );
  end component fmc_adc_100Ms_core;

  component test_dpram
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(9 downto 0);
      dina  : in  std_logic_vector(31 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(9 downto 0);
      doutb : out std_logic_vector(31 downto 0));
  end component test_dpram;

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  constant c_CARRIER_TYPE   : std_logic_vector(15 downto 0) := X"0001";
  constant c_BITSTREAM_TYPE : std_logic_vector(31 downto 0) := X"00000001";
  constant c_BITSTREAM_DATE : std_logic_vector(31 downto 0) := X"4D6BBE3E";  -- UTC time

  constant c_BAR0_APERTURE    : integer := 18;  -- nb of bits for 32-bit word address (= byte aperture - 2)
  constant c_CSR_WB_SLAVES_NB : integer := 11;

  constant c_CSR_WB_DMA_CONFIG       : integer := 0;
  constant c_CSR_WB_CARRIER_SPI      : integer := 1;
  constant c_CSR_WB_CARRIER_ONE_WIRE : integer := 2;
  constant c_CSR_WB_CARRIER_CSR      : integer := 3;
  constant c_CSR_WB_UTC_CORE         : integer := 4;
  constant c_CSR_WB_IRQ_CTRL         : integer := 5;
  constant c_CSR_WB_FMC_SYS_I2C      : integer := 6;
  constant c_CSR_WB_FMC_SPI          : integer := 7;
  constant c_CSR_WB_FMC_I2C          : integer := 8;
  constant c_CSR_WB_FMC_ADC_CORE     : integer := 9;
  constant c_CSR_WB_FMC_ONE_WIRE     : integer := 10;

  constant c_FMC_ONE_WIRE_NB : integer := 1;

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

  -- LCLK from GN4124 used as system clock
  signal l_clk : std_logic;

  -- Reset
  signal rst       : std_logic;
  signal sys_rst   : std_logic;
  signal sys_rst_n : std_logic;

  -- CSR wishbone bus (master)
  signal wbm_adr   : std_logic_vector(31 downto 0);
  signal wbm_dat_i : std_logic_vector(31 downto 0);
  signal wbm_dat_o : std_logic_vector(31 downto 0);
  signal wbm_sel   : std_logic_vector(3 downto 0);
  signal wbm_cyc   : std_logic;
  signal wbm_stb   : std_logic;
  signal wbm_we    : std_logic;
  signal wbm_ack   : std_logic;
  signal wbm_stall : std_logic;

  -- CSR wishbone bus (slaves)
  signal wb_adr   : std_logic_vector(31 downto 0);
  signal wb_dat_i : std_logic_vector((32*c_CSR_WB_SLAVES_NB)-1 downto 0);
  signal wb_dat_o : std_logic_vector(31 downto 0);
  signal wb_sel   : std_logic_vector(3 downto 0);
  signal wb_cyc   : std_logic_vector(c_CSR_WB_SLAVES_NB-1 downto 0);
  signal wb_stb   : std_logic;
  signal wb_we    : std_logic;
  signal wb_ack   : std_logic_vector(c_CSR_WB_SLAVES_NB-1 downto 0);
  signal wb_stall : std_logic_vector(c_CSR_WB_SLAVES_NB-1 downto 0);

  -- GN4124 DMA to DDR wishbone bus
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
  signal dma_irq           : std_logic_vector(1 downto 0);
  signal dma_irq_p         : std_logic_vector(1 downto 0);
  signal irq_sources       : std_logic_vector(31 downto 0);
  signal irq_to_gn4124     : std_logic;
  signal irq_sources_2_led : std_logic_vector(1 downto 0);

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
  signal mezz_owr_pwren : std_logic_vector(c_FMC_ONE_WIRE_NB - 1 downto 0);
  signal mezz_owr_en    : std_logic_vector(c_FMC_ONE_WIRE_NB - 1 downto 0);
  signal mezz_owr_i     : std_logic_vector(c_FMC_ONE_WIRE_NB - 1 downto 0);

  -- Carrier 1-wire
  signal carrier_owr_pwren : std_logic_vector(c_FMC_ONE_WIRE_NB - 1 downto 0);
  signal carrier_owr_en    : std_logic_vector(c_FMC_ONE_WIRE_NB - 1 downto 0);
  signal carrier_owr_i     : std_logic_vector(c_FMC_ONE_WIRE_NB - 1 downto 0);

  -- UTC core
  signal trigger_p   : std_logic;
  signal acq_start_p : std_logic;
  signal acq_stop_p  : std_logic;
  signal acq_end_p   : std_logic;

  -- Tests
  signal test_dpram_we : std_logic;
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
      dma_reg_adr_i   => wb_adr,
      dma_reg_dat_i   => wb_dat_o,
      dma_reg_sel_i   => wb_sel,
      dma_reg_stb_i   => wb_stb,
      dma_reg_we_i    => wb_we,
      dma_reg_cyc_i   => wb_cyc(c_CSR_WB_DMA_CONFIG),
      dma_reg_dat_o   => wb_dat_i(c_CSR_WB_DMA_CONFIG * 32 + 31 downto c_CSR_WB_DMA_CONFIG * 32),
      dma_reg_ack_o   => wb_ack(c_CSR_WB_DMA_CONFIG),
      dma_reg_stall_o => wb_stall(c_CSR_WB_DMA_CONFIG),
      -- CSR wishbone interface (master pipelined)
      csr_clk_i       => sys_clk_125,
      csr_adr_o       => wbm_adr,
      csr_dat_o       => wbm_dat_o,
      csr_sel_o       => wbm_sel,
      csr_stb_o       => wbm_stb,
      csr_we_o        => wbm_we,
      csr_cyc_o       => wbm_cyc,
      csr_dat_i       => wbm_dat_i,
      csr_ack_i       => wbm_ack,
      csr_stall_i     => wbm_stall,
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

  ------------------------------------------------------------------------------
  -- CSR wishbone address decoder
  --     0x00000 -> DMA configuration
  --     0x10000 -> Carrier SPI master
  --     0x20000 -> Carrier 1-wire master
  --     0x30000 -> Carrier CSR
  --     0x40000 -> UTC core
  --     0x50000 -> Interrupt controller
  --     0x60000 -> Mezzanine system managment I2C master
  --     0x70000 -> Mezzanine SPI master
  --     0x80000 -> Mezzanine I2C master
  --     0x90000 -> Mezzanine ADC core
  --     0xA0000 -> Mezzanine 1-wire master
  ------------------------------------------------------------------------------
  cmp_csr_wb_addr_decoder : wb_addr_decoder
    generic map (
      g_WINDOW_SIZE  => c_BAR0_APERTURE,
      g_WB_SLAVES_NB => c_CSR_WB_SLAVES_NB
      )
    port map (
      -- GN4124 core clock and reset
      clk_i       => sys_clk_125,
      rst_n_i     => L_RST_N,
      -- wishbone master interface
      wbm_adr_i   => wbm_adr,
      wbm_dat_i   => wbm_dat_o,
      wbm_sel_i   => wbm_sel,
      wbm_stb_i   => wbm_stb,
      wbm_we_i    => wbm_we,
      wbm_cyc_i   => wbm_cyc,
      wbm_dat_o   => wbm_dat_i,
      wbm_ack_o   => wbm_ack,
      wbm_stall_o => wbm_stall,
      -- wishbone slaves interface
      wb_adr_o    => wb_adr,
      wb_dat_o    => wb_dat_o,
      wb_sel_o    => wb_sel,
      wb_stb_o    => wb_stb,
      wb_we_o     => wb_we,
      wb_cyc_o    => wb_cyc,
      wb_dat_i    => wb_dat_i,
      wb_ack_i    => wb_ack,
      wb_stall_i  => wb_stall
      );

  ------------------------------------------------------------------------------
  -- Carrier SPI master
  --    VCXO DAC control
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Carrier 1-wire master
  --    DS18B20 (thermometer + unique ID)
  ------------------------------------------------------------------------------
  cmp_carrier_onewire : wb_onewire_master
    generic map(
      g_num_ports        => 1,
      g_ow_btp_normal    => "5.0",
      g_ow_btp_overdrive => "1.0"
      )
    port map(
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      wb_cyc_i => wb_cyc(c_CSR_WB_CARRIER_ONE_WIRE),
      wb_sel_i => wb_sel,
      wb_stb_i => wb_stb,
      wb_we_i  => wb_we,
      wb_adr_i => wb_adr(1 downto 0),
      wb_dat_i => wb_dat_o,
      wb_dat_o => wb_dat_i(c_CSR_WB_CARRIER_ONE_WIRE * 32 + 31 downto 32 * c_CSR_WB_CARRIER_ONE_WIRE),
      wb_ack_o => wb_ack(c_CSR_WB_CARRIER_ONE_WIRE),
      wb_int_o => open,

      owr_pwren_o => carrier_owr_pwren,
      owr_en_o    => carrier_owr_en,
      owr_i       => carrier_owr_i
      );

  carrier_one_wire_b <= '0' when carrier_owr_en(0) = '1' else 'Z';
  carrier_owr_i(0)   <= carrier_one_wire_b;

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_CARRIER_ONE_WIRE) <= '0';


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
      wb_addr_i                        => wb_adr(2 downto 0),
      wb_data_i                        => wb_dat_o,
      wb_data_o                        => wb_dat_i(c_CSR_WB_CARRIER_CSR * 32 + 31 downto c_CSR_WB_CARRIER_CSR * 32),
      wb_cyc_i                         => wb_cyc(c_CSR_WB_CARRIER_CSR),
      wb_sel_i                         => wb_sel,
      wb_stb_i                         => wb_stb,
      wb_we_i                          => wb_we,
      wb_ack_o                         => wb_ack(c_CSR_WB_CARRIER_CSR),
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

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_CARRIER_CSR) <= '0';

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

      wb_adr_i => wb_adr(4 downto 0),
      wb_dat_i => wb_dat_o,
      wb_dat_o => wb_dat_i(c_CSR_WB_UTC_CORE * 32 + 31 downto c_CSR_WB_UTC_CORE * 32),
      wb_cyc_i => wb_cyc(c_CSR_WB_UTC_CORE),
      wb_sel_i => wb_sel,
      wb_stb_i => wb_stb,
      wb_we_i  => wb_we,
      wb_ack_o => wb_ack(c_CSR_WB_UTC_CORE)
      );

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_UTC_CORE) <= '0';

  ------------------------------------------------------------------------------
  -- Interrupt controller
  ------------------------------------------------------------------------------
  cmp_irq_controller : irq_controller
    port map(
      clk_i   => sys_clk_125,
      rst_n_i => sys_rst_n,

      irq_src_p_i => irq_sources,

      irq_p_o => irq_to_gn4124,

      wb_adr_i => wb_adr(1 downto 0),
      wb_dat_i => wb_dat_o,
      wb_dat_o => wb_dat_i(c_CSR_WB_IRQ_CTRL * 32 + 31 downto c_CSR_WB_IRQ_CTRL * 32),
      wb_cyc_i => wb_cyc(c_CSR_WB_IRQ_CTRL),
      wb_sel_i => wb_sel,
      wb_stb_i => wb_stb,
      wb_we_i  => wb_we,
      wb_ack_o => wb_ack(c_CSR_WB_IRQ_CTRL)
      );

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_IRQ_CTRL) <= '0';

  -- IRQ sources
  irq_sources(1 downto 0)  <= dma_irq;
  irq_sources(2)           <= trigger_p;
  irq_sources(3)           <= acq_end_p;
  irq_sources(31 downto 4) <= (others => '0');

  -- just forward irq pulses for test
  --irq_to_gn4124 <= dma_irq(1) or dma_irq(0);

  ------------------------------------------------------------------------------
  -- Mezzanine system managment I2C master
  --    Access to mezzanine EEPROM
  ------------------------------------------------------------------------------
  cmp_fmc_sys_i2c : wb_i2c_master
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      wb_adr_i => wb_adr(2 downto 0),
      wb_dat_i => wb_dat_o,
      wb_dat_o => wb_dat_i(c_CSR_WB_FMC_SYS_I2C * 32 + 31 downto 32 * c_CSR_WB_FMC_SYS_I2C),
      wb_we_i  => wb_we,
      wb_stb_i => wb_stb,
      wb_sel_i => wb_sel,
      wb_cyc_i => wb_cyc(c_CSR_WB_FMC_SYS_I2C),
      wb_ack_o => wb_ack(c_CSR_WB_FMC_SYS_I2C),
      wb_int_o => open,

      scl_pad_i    => sys_scl_in,
      scl_pad_o    => sys_scl_out,
      scl_padoen_o => sys_scl_oe_n,
      sda_pad_i    => sys_sda_in,
      sda_pad_o    => sys_sda_out,
      sda_padoen_o => sys_sda_oe_n
      );

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_FMC_SYS_I2C) <= '0';

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
  cmp_fmc_spi : wb_spi
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      wb_adr_i => wb_adr(2 downto 0),
      wb_dat_i => wb_dat_o,
      wb_dat_o => wb_dat_i(c_CSR_WB_FMC_SPI * 32 + 31 downto c_CSR_WB_FMC_SPI * 32),
      wb_sel_i => wb_sel,
      wb_stb_i => wb_stb,
      wb_cyc_i => wb_cyc(c_CSR_WB_FMC_SPI),
      wb_we_i  => wb_we,
      wb_ack_o => wb_ack(c_CSR_WB_FMC_SPI),
      wb_err_o => open,
      wb_int_o => open,

      pad_cs_o   => spi_ss_t,
      pad_sclk_o => spi_sck_o,
      pad_mosi_o => spi_dout_o,
      pad_miso_i => spi_din_t(spi_din_t'left)
      );

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_FMC_SPI) <= '0';

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
  cmp_fmc_i2c : wb_i2c_master
    port map (
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      wb_adr_i => wb_adr(2 downto 0),
      wb_dat_i => wb_dat_o,
      wb_dat_o => wb_dat_i(c_CSR_WB_FMC_I2C * 32 + 31 downto 32 * c_CSR_WB_FMC_I2C),
      wb_we_i  => wb_we,
      wb_stb_i => wb_stb,
      wb_sel_i => wb_sel,
      wb_cyc_i => wb_cyc(c_CSR_WB_FMC_I2C),
      wb_ack_o => wb_ack(c_CSR_WB_FMC_I2C),
      wb_int_o => open,

      scl_pad_i    => si570_scl_in,
      scl_pad_o    => si570_scl_out,
      scl_padoen_o => si570_scl_oe_n,
      sda_pad_i    => si570_sda_in,
      sda_pad_o    => si570_sda_out,
      sda_padoen_o => si570_sda_oe_n
      );

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_FMC_I2C) <= '0';

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

      wb_csr_adr_i => wb_adr(4 downto 0),
      wb_csr_dat_i => wb_dat_o,
      wb_csr_dat_o => wb_dat_i(c_CSR_WB_FMC_ADC_CORE * 32 + 31 downto c_CSR_WB_FMC_ADC_CORE * 32),
      wb_csr_cyc_i => wb_cyc(c_CSR_WB_FMC_ADC_CORE),
      wb_csr_sel_i => wb_sel,
      wb_csr_stb_i => wb_stb,
      wb_csr_we_i  => wb_we,
      wb_csr_ack_o => wb_ack(c_CSR_WB_FMC_ADC_CORE),

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

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_FMC_ADC_CORE) <= '0';

  ------------------------------------------------------------------------------
  -- Mezzanine 1-wire master
  --    DS18B20 (thermometer + unique ID)
  ------------------------------------------------------------------------------
  cmp_fmc_onewire : wb_onewire_master
    generic map(
      g_num_ports        => 1,
      g_ow_btp_normal    => "5.0",
      g_ow_btp_overdrive => "1.0"
      )
    port map(
      clk_sys_i => sys_clk_125,
      rst_n_i   => sys_rst_n,

      wb_cyc_i => wb_cyc(c_CSR_WB_FMC_ONE_WIRE),
      wb_sel_i => wb_sel,
      wb_stb_i => wb_stb,
      wb_we_i  => wb_we,
      wb_adr_i => wb_adr(1 downto 0),
      wb_dat_i => wb_dat_o,
      wb_dat_o => wb_dat_i(c_CSR_WB_FMC_ONE_WIRE * 32 + 31 downto 32 * c_CSR_WB_FMC_ONE_WIRE),
      wb_ack_o => wb_ack(c_CSR_WB_FMC_ONE_WIRE),
      wb_int_o => open,

      owr_pwren_o => mezz_owr_pwren,
      owr_en_o    => mezz_owr_en,
      owr_i       => mezz_owr_i
      );

  mezz_one_wire_b <= '0' when mezz_owr_en(0) = '1' else 'Z';
  mezz_owr_i(0)   <= mezz_one_wire_b;

  -- Classic slave supporting single pipelined accesses, stall isn't used
  wb_stall(c_CSR_WB_FMC_ONE_WIRE) <= '0';

  ------------------------------------------------------------------------------
  -- DMA wishbone bus slaves
  --  -> DDR3 controller
  ------------------------------------------------------------------------------
  cmp_ddr_ctrl : ddr3_ctrl
    generic map(
      g_BANK_PORT_SELECT   => "BANK3_64B_32B",
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

      --wb0_clk_i   => '0',
      --wb0_sel_i   => "0000",
      --wb0_cyc_i   => '0',
      --wb0_stb_i   => '0',
      --wb0_we_i    => '0',
      --wb0_addr_i  => X"0000000",
      --wb0_data_i  => X"00000000",
      --wb0_data_o  => open,
      --wb0_ack_o   => open,
      --wb0_stall_o => open,

      --wb1_clk_i   => '0',
      --wb1_sel_i   => "0000",
      --wb1_cyc_i   => '0',
      --wb1_stb_i   => '0',
      --wb1_we_i    => '0',
      --wb1_addr_i  => X"0000000",
      --wb1_data_i  => X"00000000",
      --wb1_data_o  => open,
      --wb1_ack_o   => open,
      --wb1_stall_o => open);

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

      wb1_clk_i   => sys_clk_125,
      wb1_sel_i   => wb_dma_sel,
      wb1_cyc_i   => wb_dma_cyc,
      wb1_stb_i   => wb_dma_stb,
      wb1_we_i    => wb_dma_we,
      wb1_addr_i  => wb_dma_adr,
      wb1_data_i  => wb_dma_dat_o,
      wb1_data_o  => wb_dma_dat_i,
      wb1_ack_o   => wb_dma_ack,
      wb1_stall_o => wb_dma_stall);

  ddr3_calib_done <= ddr3_status(0);

--wb_ddr_stall <= '0';

--test_dpram_we <= wb_ddr_we and wb_ddr_stb and wb_ddr_cyc;

--p_test_dpram_wr_ack : process (sys_clk_250)
--begin
--  if rising_edge(sys_clk_250) then
--    if sys_rst_n = '0' then
--      wb_ddr_ack <= '0';
--    elsif wb_ddr_cyc = '1' and wb_ddr_stb = '1' then
--      wb_ddr_ack <= '1';
--    else
--      wb_ddr_ack <= '0';
--    end if;
--  end if;
--end process p_test_dpram_wr_ack;

--cmp_test_dpram : test_dpram
--  port map(
--    clka   => sys_clk_250,
--    wea(0) => test_dpram_we,           --: in  std_logic_vector(0 downto 0);
--    addra  => wb_ddr_adr(9 downto 0),  --: in  std_logic_vector(9 downto 0);
--    dina   => wb_ddr_dat_o,            --: in  std_logic_vector(31 downto 0);
--    clkb   => sys_clk_125,
--    addrb  => wb_dma_adr(9 downto 0),  --: in  std_logic_vector(9 downto 0);
--    doutb  => wb_dma_dat_i);           --: out std_logic_vector(31 downto 0));

--p_test_dpram_rd_ack : process (sys_clk_125)
--begin
--  if rising_edge(sys_clk_125) then
--    if sys_rst_n = '0' then
--      wb_dma_ack <= '0';
--    elsif wb_dma_cyc = '1' and wb_dma_stb = '1' then
--      wb_dma_ack <= '1';
--    else
--      wb_dma_ack <= '0';
--    end if;
--  end if;
--end process p_test_dpram_rd_ack;

--wb_dma_stall <= '0';

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
