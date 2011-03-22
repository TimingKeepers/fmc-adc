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
use work.gn4124_core_pkg.all;

library UNISIM;
use UNISIM.vcomponents.all;


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

      -- PCB version
      pcb_ver_i : in std_logic_vector(3 downto 0);

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

      si570_thermo_scl_b : inout std_logic;  -- I2C bus clock (Si570 and MCP9801 thermometer)
      si570_thermo_sda_b : inout std_logic;  -- I2C bus data (Si570 and MCP9801 thermometer)

      prsnt_m2c_n_i : in std_logic      -- Mezzanine present (active low)
      );
end spec_top_fmc_adc_100Ms;


architecture rtl of spec_top_fmc_adc_100Ms is

  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------

  component gn4124_core
    generic(
      g_BAR0_APERTURE     : integer := 20;  -- BAR0 aperture, defined in GN4124 PCI_BAR_CONFIG register (0x80C)
                                            -- => number of bits to address periph on the board
      g_CSR_WB_SLAVES_NB  : integer := 1;   -- Number of CSR wishbone slaves
      g_DMA_WB_SLAVES_NB  : integer := 1;   -- Number of DMA wishbone slaves
      g_DMA_WB_ADDR_WIDTH : integer := 26   -- DMA wishbone address bus width
      );
    port
      (
        ---------------------------------------------------------
        -- Control and status
        --
        -- Asynchronous reset from GN4124
        rst_n_a_i      : in  std_logic;
        -- P2L clock PLL locked
        p2l_pll_locked : out std_logic;
        -- Debug ouputs
        debug_o        : out std_logic_vector(7 downto 0);

        ---------------------------------------------------------
        -- P2L Direction
        --
        -- Source Sync DDR related signals
        p2l_clk_p_i  : in  std_logic;                      -- Receiver Source Synchronous Clock+
        p2l_clk_n_i  : in  std_logic;                      -- Receiver Source Synchronous Clock-
        p2l_data_i   : in  std_logic_vector(15 downto 0);  -- Parallel receive data
        p2l_dframe_i : in  std_logic;                      -- Receive Frame
        p2l_valid_i  : in  std_logic;                      -- Receive Data Valid
        -- P2L Control
        p2l_rdy_o    : out std_logic;                      -- Rx Buffer Full Flag
        p_wr_req_i   : in  std_logic_vector(1 downto 0);   -- PCIe Write Request
        p_wr_rdy_o   : out std_logic_vector(1 downto 0);   -- PCIe Write Ready
        rx_error_o   : out std_logic;                      -- Receive Error

        ---------------------------------------------------------
        -- L2P Direction
        --
        -- Source Sync DDR related signals
        l2p_clk_p_o  : out std_logic;                      -- Transmitter Source Synchronous Clock+
        l2p_clk_n_o  : out std_logic;                      -- Transmitter Source Synchronous Clock-
        l2p_data_o   : out std_logic_vector(15 downto 0);  -- Parallel transmit data
        l2p_dframe_o : out std_logic;                      -- Transmit Data Frame
        l2p_valid_o  : out std_logic;                      -- Transmit Data Valid
        l2p_edb_o    : out std_logic;                      -- Packet termination and discard
        -- L2P Control
        l2p_rdy_i    : in  std_logic;                      -- Tx Buffer Full Flag
        l_wr_rdy_i   : in  std_logic_vector(1 downto 0);   -- Local-to-PCIe Write
        p_rd_d_rdy_i : in  std_logic_vector(1 downto 0);   -- PCIe-to-Local Read Response Data Ready
        tx_error_i   : in  std_logic;                      -- Transmit Error
        vc_rdy_i     : in  std_logic_vector(1 downto 0);   -- Channel ready

        ---------------------------------------------------------
        -- Interrupt interface
        dma_irq_o : out std_logic_vector(1 downto 0);  -- Interrupts sources to IRQ manager
        irq_p_i   : in  std_logic;                     -- Interrupt request pulse from IRQ manager
        irq_p_o   : out std_logic;                     -- Interrupt request pulse to GN4124 GPIO

        ---------------------------------------------------------
        -- Target interface (CSR wishbone master)
        wb_clk_i : in  std_logic;
        wb_adr_o : out std_logic_vector(g_BAR0_APERTURE-log2_ceil(g_CSR_WB_SLAVES_NB+1)-1 downto 0);
        wb_dat_o : out std_logic_vector(31 downto 0);                         -- Data out
        wb_sel_o : out std_logic_vector(3 downto 0);                          -- Byte select
        wb_stb_o : out std_logic;
        wb_we_o  : out std_logic;
        wb_cyc_o : out std_logic_vector(g_CSR_WB_SLAVES_NB-1 downto 0);
        wb_dat_i : in  std_logic_vector((32*g_CSR_WB_SLAVES_NB)-1 downto 0);  -- Data in
        wb_ack_i : in  std_logic_vector(g_CSR_WB_SLAVES_NB-1 downto 0);

        ---------------------------------------------------------
        -- DMA interface (Pipelined wishbone master)
        dma_clk_i   : in  std_logic;
        dma_adr_o   : out std_logic_vector(31 downto 0);
        dma_dat_o   : out std_logic_vector(31 downto 0);                         -- Data out
        dma_sel_o   : out std_logic_vector(3 downto 0);                          -- Byte select
        dma_stb_o   : out std_logic;
        dma_we_o    : out std_logic;
        dma_cyc_o   : out std_logic;                                             --_vector(g_DMA_WB_SLAVES_NB-1 downto 0);
        dma_dat_i   : in  std_logic_vector((32*g_DMA_WB_SLAVES_NB)-1 downto 0);  -- Data in
        dma_ack_i   : in  std_logic;                                             --_vector(g_DMA_WB_SLAVES_NB-1 downto 0);
        dma_stall_i : in  std_logic--_vector(g_DMA_WB_SLAVES_NB-1 downto 0)        -- for pipelined Wishbone
        );
  end component gn4124_core;

  component ddr3_ctrl
    generic(
      g_MEMCLK_PERIOD      : integer := 3200;               -- in ps
      g_RST_ACT_LOW        : integer := 1;                  -- 1=active low
      g_INPUT_CLK_TYPE     : string  := "SINGLE_ENDED";
      g_SIMULATION         : string  := "FALSE";
      g_CALIB_SOFT_IP      : string  := "TRUE";
      g_MEM_ADDR_ORDER     : string  := "ROW_BANK_COLUMN";  -- BANK_ROW_COLUMN or ROW_BANK_COLUMN
      g_NUM_DQ_PINS        : integer := 16;
      g_MEM_ADDR_WIDTH     : integer := 14;
      g_MEM_BANKADDR_WIDTH : integer := 3;
      g_P0_MASK_SIZE       : integer := 4;
      g_P0_DATA_PORT_SIZE  : integer := 32;
      g_P1_MASK_SIZE       : integer := 4;
      g_P1_DATA_PORT_SIZE  : integer := 32
      );

    port(
      clk_i         : in    std_logic;
      rst_n_i       : in    std_logic;
      calib_done    : out   std_logic;
      ddr3_dq_b     : inout std_logic_vector(g_NUM_DQ_PINS-1 downto 0);
      ddr3_a_o      : out   std_logic_vector(g_MEM_ADDR_WIDTH-1 downto 0);
      ddr3_ba_o     : out   std_logic_vector(g_MEM_BANKADDR_WIDTH-1 downto 0);
      ddr3_ras_n_o  : out   std_logic;
      ddr3_cas_n_o  : out   std_logic;
      ddr3_we_n_o   : out   std_logic;
      ddr3_odt_o    : out   std_logic;
      ddr3_rst_n_o  : out   std_logic;
      ddr3_cke_o    : out   std_logic;
      ddr3_dm_o     : out   std_logic;
      ddr3_udm_o    : out   std_logic;
      ddr3_dqs_p_b  : inout std_logic;
      ddr3_dqs_n_b  : inout std_logic;
      ddr3_udqs_p_b : inout std_logic;
      ddr3_udqs_n_b : inout std_logic;
      ddr3_clk_p_o  : out   std_logic;
      ddr3_clk_n_o  : out   std_logic;
      ddr3_rzq_b    : inout std_logic;
      ddr3_zio_b    : inout std_logic;

      wb0_clk_i   : in  std_logic;
      wb0_sel_i   : in  std_logic_vector(g_P0_MASK_SIZE - 1 downto 0);
      wb0_cyc_i   : in  std_logic;
      wb0_stb_i   : in  std_logic;
      wb0_we_i    : in  std_logic;
      wb0_addr_i  : in  std_logic_vector(27 downto 0);
      wb0_data_i  : in  std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb0_data_o  : out std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb0_ack_o   : out std_logic;
      wb0_stall_o : out std_logic;

      wb1_clk_i   : in  std_logic;
      wb1_sel_i   : in  std_logic_vector(g_P0_MASK_SIZE - 1 downto 0);
      wb1_cyc_i   : in  std_logic;
      wb1_stb_i   : in  std_logic;
      wb1_we_i    : in  std_logic;
      wb1_addr_i  : in  std_logic_vector(27 downto 0);
      wb1_data_i  : in  std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb1_data_o  : out std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb1_ack_o   : out std_logic;
      wb1_stall_o : out std_logic
      );
  end component ddr3_ctrl;

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
      carrier_csr_carrier_dummy_i      : in  std_logic_vector(11 downto 0);
      carrier_csr_carrier_type_i       : in  std_logic_vector(15 downto 0);
      carrier_csr_bitstream_type_i     : in  std_logic_vector(31 downto 0);
      carrier_csr_bitstream_date_i     : in  std_logic_vector(31 downto 0);
      carrier_csr_stat_fmc_pres_i      : in  std_logic;
      carrier_csr_stat_p2l_pll_lck_i   : in  std_logic;
      carrier_csr_stat_sys_pll_lck_i   : in  std_logic;
      carrier_csr_stat_ddr3_cal_done_i : in  std_logic;
      carrier_csr_ctrl_led_green_o     : out std_logic;
      carrier_csr_ctrl_led_red_o       : out std_logic;
      carrier_csr_ctrl_dac_clr_n_o     : out std_logic
      );
  end component carrier_csr;

  component wb_spi_master
    port(
      wb_clk_i   : in  std_logic;
      wb_rst_i   : in  std_logic;
      wb_adr_i   : in  std_logic_vector(4 downto 0);
      wb_dat_i   : in  std_logic_vector(31 downto 0);
      wb_dat_o   : out std_logic_vector(31 downto 0);
      wb_sel_i   : in  std_logic_vector(3 downto 0);
      wb_stb_i   : in  std_logic;
      wb_cyc_i   : in  std_logic;
      wb_we_i    : in  std_logic;
      wb_ack_o   : out std_logic;
      wb_err_o   : out std_logic;
      wb_int_o   : out std_logic;
      ss_pad_o   : out std_logic_vector(7 downto 0);
      sclk_pad_o : out std_logic;
      mosi_pad_o : out std_logic;
      miso_pad_i : in  std_logic);
  end component wb_spi_master;

  component i2c_master_top
    generic(
      ARST_LVL : std_logic := '0'                    -- asynchronous reset level
      );
    port (
      -- wishbone signals
      wb_clk_i  : in  std_logic;                     -- master clock input
      wb_rst_i  : in  std_logic := '0';              -- synchronous active high reset
      arst_i    : in  std_logic := not ARST_LVL;     -- asynchronous reset
      wb_adr_i  : in  std_logic_vector(2 downto 0);  -- lower address bits
      wb_dat_i  : in  std_logic_vector(7 downto 0);  -- Databus input
      wb_dat_o  : out std_logic_vector(7 downto 0);  -- Databus output
      wb_we_i   : in  std_logic;                     -- Write enable input
      wb_stb_i  : in  std_logic;                     -- Strobe signals / core select signal
      wb_cyc_i  : in  std_logic;                     -- Valid bus cycle input
      wb_ack_o  : out std_logic;                     -- Bus cycle acknowledge output
      wb_inta_o : out std_logic;                     -- interrupt request output signal

      -- i2c lines
      scl_pad_i    : in  std_logic;     -- i2c clock line input
      scl_pad_o    : out std_logic;     -- i2c clock line output
      scl_padoen_o : out std_logic;     -- i2c clock line output enable, active low
      sda_pad_i    : in  std_logic;     -- i2c data line input
      sda_pad_o    : out std_logic;     -- i2c data line output
      sda_padoen_o : out std_logic      -- i2c data line output enable, active low
      );
  end component i2c_master_top;

  component monostable
    generic(
      g_INPUT_POLARITY  : std_logic := '1';    --! trigger_i polarity
                                               --! ('0'=negative, 1=positive)
      g_OUTPUT_POLARITY : std_logic := '1';    --! pulse_o polarity
                                               --! ('0'=negative, 1=positive)
      g_OUTPUT_RETRIG   : boolean   := false;  --! Retriggerable output monostable
      g_OUTPUT_LENGTH   : natural   := 1       --! pulse_o lenght (in clk_i ticks)
      );
    port (
      rst_n_i   : in  std_logic;               --! Reset (active low)
      clk_i     : in  std_logic;               --! Clock
      trigger_i : in  std_logic;               --! Trigger input pulse
      pulse_o   : out std_logic                --! Monostable output pulse
      );
  end component monostable;

  component fmc_adc_100Ms_core
    port (
      -- Clock, reset
      sys_clk_i   : std_logic;
      sys_rst_n_i : std_logic;

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
      wb_ddr_dat_o   : out std_logic_vector(31 downto 0);
      wb_ddr_sel_o   : out std_logic_vector(3 downto 0);
      wb_ddr_stb_o   : out std_logic;
      wb_ddr_we_o    : out std_logic;
      wb_ddr_cyc_o   : out std_logic;
      wb_ddr_dat_i   : in  std_logic_vector(31 downto 0);
      wb_ddr_ack_i   : in  std_logic;
      wb_ddr_stall_i : in  std_logic;

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

      gpio_dac_clr_n_o   : out std_logic;                     -- offset DACs clear (active low)
      gpio_led_power_o   : out std_logic;                     -- Mezzanine front panel power LED (PWR)
      gpio_led_trigger_o : out std_logic;                     -- Mezzanine front panel trigger LED (TRIG)
      gpio_ssr_ch1_o     : out std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
      gpio_ssr_ch2_o     : out std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
      gpio_ssr_ch3_o     : out std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
      gpio_ssr_ch4_o     : out std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
      gpio_si570_oe_o    : out std_logic                      -- Si570 (programmable oscillator) output enable
      );
  end component fmc_adc_100Ms_core;

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  constant c_CARRIER_TYPE   : std_logic_vector(15 downto 0) := X"0001";
  constant c_BITSTREAM_TYPE : std_logic_vector(31 downto 0) := X"00000001";
  constant c_BITSTREAM_DATE : std_logic_vector(31 downto 0) := X"4D6BBE3E";  -- UTC time

  constant c_BAR0_APERTURE     : integer := 20;
  constant c_CSR_WB_SLAVES_NB  : integer := 9;
  constant c_DMA_WB_SLAVES_NB  : integer := 1;
  constant c_DMA_WB_ADDR_WIDTH : integer := 26;

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

  -- P2L clock PLL status
  signal p2l_pll_locked : std_logic;

  -- Reset
  signal rst       : std_logic;
  signal sys_rst   : std_logic;
  signal sys_rst_n : std_logic;

  -- CSR wishbone bus
  signal wb_adr   : std_logic_vector(c_BAR0_APERTURE-log2_ceil(c_CSR_WB_SLAVES_NB+1)-1 downto 0);
  signal wb_dat_o : std_logic_vector(31 downto 0);
  signal wb_stb   : std_logic;
  signal wb_we    : std_logic;
  signal wb_sel   : std_logic_vector(3 downto 0);

  signal wb_dat_carrier_spi  : std_logic_vector(31 downto 0);
  signal wb_dat_carrier_i2c  : std_logic_vector(31 downto 0);
  signal wb_dat_carrier_csr  : std_logic_vector(31 downto 0);
  signal wb_dat_utc_core     : std_logic_vector(31 downto 0);
  signal wb_dat_irq_ctrl     : std_logic_vector(31 downto 0);
  signal wb_dat_fmc_sys_i2c  : std_logic_vector(31 downto 0);
  signal wb_dat_fmc_spi      : std_logic_vector(31 downto 0);
  signal wb_dat_fmc_i2c      : std_logic_vector(31 downto 0);
  signal wb_dat_fmc_adc_core : std_logic_vector(31 downto 0);

  signal wb_cyc_carrier_spi  : std_logic;
  signal wb_cyc_carrier_i2c  : std_logic;
  signal wb_cyc_carrier_csr  : std_logic;
  signal wb_cyc_utc_core     : std_logic;
  signal wb_cyc_irq_ctrl     : std_logic;
  signal wb_cyc_fmc_sys_i2c  : std_logic;
  signal wb_cyc_fmc_spi      : std_logic;
  signal wb_cyc_fmc_i2c      : std_logic;
  signal wb_cyc_fmc_adc_core : std_logic;

  signal wb_ack_carrier_spi  : std_logic;
  signal wb_ack_carrier_i2c  : std_logic;
  signal wb_ack_carrier_csr  : std_logic;
  signal wb_ack_utc_core     : std_logic;
  signal wb_ack_irq_ctrl     : std_logic;
  signal wb_ack_fmc_sys_i2c  : std_logic;
  signal wb_ack_fmc_spi      : std_logic;
  signal wb_ack_fmc_i2c      : std_logic;
  signal wb_ack_fmc_adc_core : std_logic;

  signal wb_adr_carrier_spi  : std_logic_vector(4 downto 0);
  signal wb_adr_carrier_i2c  : std_logic_vector(2 downto 0);
  signal wb_adr_carrier_csr  : std_logic_vector(2 downto 0);
  signal wb_adr_utc_core     : std_logic_vector(1 downto 0);
  signal wb_adr_irq_ctrl     : std_logic_vector(1 downto 0);
  signal wb_adr_fmc_sys_i2c  : std_logic_vector(2 downto 0);
  signal wb_adr_fmc_spi      : std_logic_vector(4 downto 0);
  signal wb_adr_fmc_i2c      : std_logic_vector(2 downto 0);
  signal wb_adr_fmc_adc_core : std_logic_vector(4 downto 0);

  -- GN4124 DMA to DDR wishbone bus
  signal wb_dma_adr     : std_logic_vector(31 downto 0);
  signal wb_dma_dat_i   : std_logic_vector((32*c_DMA_WB_SLAVES_NB)-1 downto 0);
  signal wb_dma_dat_o   : std_logic_vector(31 downto 0);
  signal wb_dma_sel     : std_logic_vector(3 downto 0);
  signal wb_dma_cyc     : std_logic;    --_vector(c_DMA_WB_SLAVES_NB-1 downto 0);
  signal wb_dma_stb     : std_logic;
  signal wb_dma_we      : std_logic;
  signal wb_dma_ack     : std_logic;    --_vector(c_DMA_WB_SLAVES_NB-1 downto 0);
  signal wb_dma_stall   : std_logic;    --_vector(c_DMA_WB_SLAVES_NB-1 downto 0);

  -- FMC ADC core to DDR wishbone bus
  signal wb_ddr_adr   : std_logic_vector(31 downto 0);
  signal wb_ddr_dat_i : std_logic_vector((32*c_DMA_WB_SLAVES_NB)-1 downto 0);
  signal wb_ddr_dat_o : std_logic_vector(31 downto 0);
  signal wb_ddr_sel   : std_logic_vector(3 downto 0);
  signal wb_ddr_cyc   : std_logic;
  signal wb_ddr_stb   : std_logic;
  signal wb_ddr_we    : std_logic;
  signal wb_ddr_ack   : std_logic;
  signal wb_ddr_stall : std_logic;

  -- Interrupts stuff
  signal irq_sources       : std_logic_vector(1 downto 0);
  signal irq_to_gn4124     : std_logic;
  signal irq_sources_2_led : std_logic_vector(1 downto 0);

  -- Mezzanine I2C for Si570 and thermometer
  signal si570_thermo_scl_in   : std_logic;
  signal si570_thermo_scl_out  : std_logic;
  signal si570_thermo_scl_oe_n : std_logic;
  signal si570_thermo_sda_in   : std_logic;
  signal si570_thermo_sda_out  : std_logic;
  signal si570_thermo_sda_oe_n : std_logic;

  -- LED control from carrier CSR register
  signal led_red   : std_logic;
  signal led_green : std_logic;

  -- CSR whisbone slaves for test
  signal gpio_stat     : std_logic_vector(31 downto 0);
  signal gpio_ctrl_1   : std_logic_vector(31 downto 0);
  signal gpio_ctrl_2   : std_logic_vector(31 downto 0);
  signal gpio_ctrl_3   : std_logic_vector(31 downto 0);
  signal gpio_led_ctrl : std_logic_vector(31 downto 0);

  -- DDR3
  signal ddr3_calib_done : std_logic;

  -- SPI
  signal spi_din_t  : std_logic_vector(3 downto 0);
  signal spi_ss_t   : std_logic_vector(7 downto 0);


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
    generic map (
      g_BAR0_APERTURE     => c_BAR0_APERTURE,
      g_CSR_WB_SLAVES_NB  => c_CSR_WB_SLAVES_NB,
      g_DMA_WB_SLAVES_NB  => c_DMA_WB_SLAVES_NB,
      g_DMA_WB_ADDR_WIDTH => c_DMA_WB_ADDR_WIDTH)
    port map(
      rst_n_a_i      => L_RST_N,         -- Asynchronous reset from GN4124
      p2l_pll_locked => p2l_pll_locked,  -- P2L clock PLL locked
      debug_o        => open,
      -- P2L Direction Source Sync DDR related signals
      p2l_clk_p_i    => P2L_CLKp,
      p2l_clk_n_i    => P2L_CLKn,
      p2l_data_i     => P2L_DATA,
      p2l_dframe_i   => P2L_DFRAME,
      p2l_valid_i    => P2L_VALID,
      -- P2L Control
      p2l_rdy_o      => P2L_RDY,
      p_wr_req_i     => P_WR_REQ,
      p_wr_rdy_o     => P_WR_RDY,
      rx_error_o     => RX_ERROR,
      -- L2P Direction Source Sync DDR related signals
      l2p_clk_p_o    => L2P_CLKp,
      l2p_clk_n_o    => L2P_CLKn,
      l2p_data_o     => L2P_DATA,
      l2p_dframe_o   => L2P_DFRAME,
      l2p_valid_o    => L2P_VALID,
      l2p_edb_o      => L2P_EDB,
      -- L2P Control
      l2p_rdy_i      => L2P_RDY,
      l_wr_rdy_i     => L_WR_RDY,
      p_rd_d_rdy_i   => P_RD_D_RDY,
      tx_error_i     => TX_ERROR,
      vc_rdy_i       => VC_RDY,
      -- Interrupt interface
      dma_irq_o      => irq_sources,
      irq_p_i        => irq_to_gn4124,
      irq_p_o        => GPIO(0),
      -- CSR wishbone interface
      wb_clk_i       => sys_clk_125,
      wb_dat_o       => wb_dat_o,
      wb_sel_o       => wb_sel,
      wb_stb_o       => wb_stb,
      wb_we_o        => wb_we,
      wb_adr_o       => wb_adr,

      wb_cyc_o(0) => wb_cyc_carrier_spi,
      wb_cyc_o(1) => wb_cyc_carrier_i2c,
      wb_cyc_o(2) => wb_cyc_carrier_csr,
      wb_cyc_o(3) => wb_cyc_utc_core,
      wb_cyc_o(4) => wb_cyc_irq_ctrl,
      wb_cyc_o(5) => wb_cyc_fmc_sys_i2c,
      wb_cyc_o(6) => wb_cyc_fmc_spi,
      wb_cyc_o(7) => wb_cyc_fmc_i2c,
      wb_cyc_o(8) => wb_cyc_fmc_adc_core,

      wb_ack_i(0) => wb_ack_carrier_spi,
      wb_ack_i(1) => wb_ack_carrier_i2c,
      wb_ack_i(2) => wb_ack_carrier_csr,
      wb_ack_i(3) => wb_ack_utc_core,
      wb_ack_i(4) => wb_ack_irq_ctrl,
      wb_ack_i(5) => wb_ack_fmc_sys_i2c,
      wb_ack_i(6) => wb_ack_fmc_spi,
      wb_ack_i(7) => wb_ack_fmc_i2c,
      wb_ack_i(8) => wb_ack_fmc_adc_core,

      wb_dat_i(0 * 32 + 31 downto 0 * 32) => wb_dat_carrier_spi,
      wb_dat_i(1 * 32 + 31 downto 1 * 32) => wb_dat_carrier_i2c,
      wb_dat_i(2 * 32 + 31 downto 2 * 32) => wb_dat_carrier_csr,
      wb_dat_i(3 * 32 + 31 downto 3 * 32) => wb_dat_utc_core,
      wb_dat_i(4 * 32 + 31 downto 4 * 32) => wb_dat_irq_ctrl,
      wb_dat_i(5 * 32 + 31 downto 5 * 32) => wb_dat_fmc_sys_i2c,
      wb_dat_i(6 * 32 + 31 downto 6 * 32) => wb_dat_fmc_spi,
      wb_dat_i(7 * 32 + 31 downto 7 * 32) => wb_dat_fmc_i2c,
      wb_dat_i(8 * 32 + 31 downto 8 * 32) => wb_dat_fmc_adc_core,

      -- DMA wishbone interface (pipelined)
      dma_clk_i   => sys_clk_125,
      dma_adr_o   => wb_dma_adr,
      dma_dat_o   => wb_dma_dat_o,
      dma_sel_o   => wb_dma_sel,
      dma_stb_o   => wb_dma_stb,
      dma_we_o    => wb_dma_we,
      dma_cyc_o   => wb_dma_cyc,
      dma_dat_i   => wb_dma_dat_i,
      dma_ack_i   => wb_dma_ack,
      dma_stall_i => wb_dma_stall
      );

  ------------------------------------------------------------------------------
  -- CSR wishbone bus slaves
  --    (0x00000 -> DMA configuration)
  --     0x10000 -> Carrier SPI master
  --     0x20000 -> Carrier I2C master
  --     0x30000 -> Carrier CSR
  --     0x40000 -> UTC core
  --     0x50000 -> Interrupt controller
  --     0x60000 -> Mezzanine system managment I2C master
  --     0x70000 -> Mezzanine SPI master
  --     0x80000 -> Mezzanine I2C master
  --     0x90000 -> Mezzanine ADC core
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Carrier SPI master
  --    VCXO DAC control
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Carrier I2C master
  --    Thermometer control
  ------------------------------------------------------------------------------


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
      wb_addr_i                        => wb_adr_carrier_csr,
      wb_data_i                        => wb_dat_o,
      wb_data_o                        => wb_dat_carrier_csr,
      wb_cyc_i                         => wb_cyc_carrier_csr,
      wb_sel_i                         => wb_sel,
      wb_stb_i                         => wb_stb,
      wb_we_i                          => wb_we,
      wb_ack_o                         => wb_ack_carrier_csr,
      carrier_csr_carrier_pcb_rev_i    => pcb_ver_i,
      carrier_csr_carrier_dummy_i      => X"000",
      carrier_csr_carrier_type_i       => c_CARRIER_TYPE,
      carrier_csr_bitstream_type_i     => c_BITSTREAM_TYPE,
      carrier_csr_bitstream_date_i     => c_BITSTREAM_DATE,
      carrier_csr_stat_fmc_pres_i      => prsnt_m2c_n_i,
      carrier_csr_stat_p2l_pll_lck_i   => p2l_pll_locked,
      carrier_csr_stat_sys_pll_lck_i   => sys_clk_pll_locked,
      carrier_csr_stat_ddr3_cal_done_i => ddr3_calib_done,
      carrier_csr_ctrl_led_green_o     => led_green,
      carrier_csr_ctrl_led_red_o       => led_red,
      carrier_csr_ctrl_dac_clr_n_o     => open
      );

  wb_adr_carrier_csr <= wb_adr(2 downto 0);

  gen_irq_led : for I in 0 to 1 generate
    cmp_irq_led : monostable
      generic map(
        g_INPUT_POLARITY  => '1',
        g_OUTPUT_POLARITY => '1',
        g_OUTPUT_RETRIG   => false,
        g_OUTPUT_LENGTH   => 5000000)
      port map(
        rst_n_i   => sys_rst_n,
        clk_i     => sys_clk_125,
        trigger_i => irq_sources(I),
        pulse_o   => irq_sources_2_led(I));
  end generate gen_irq_led;

  led_red_o   <= led_red or irq_sources_2_led(0);
  led_green_o <= led_green or irq_sources_2_led(1);

  ------------------------------------------------------------------------------
  -- UTC core
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Interrupt controller
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Mezzanine system managment I2C master
  --    Access to mezzanine EEPROM
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Mezzanine SPI master
  --    Offset DACs control
  --    ADC control
  ------------------------------------------------------------------------------
  cmp_fmc_spi : wb_spi_master
    port map (
      wb_clk_i    => sys_clk_125,
      wb_rst_i    => sys_rst,
      wb_adr_i    => wb_adr_fmc_spi,
      wb_dat_i    => wb_dat_o,
      wb_dat_o    => wb_dat_fmc_spi,
      wb_sel_i    => wb_sel,
      wb_stb_i    => wb_stb,
      wb_cyc_i    => wb_cyc_fmc_spi,
      wb_we_i     => wb_we,
      wb_ack_o    => wb_ack_fmc_spi,
      wb_err_o    => open,
      wb_int_o    => open,
      ss_pad_o    => spi_ss_t,
      sclk_pad_o  => spi_sck_o,
      mosi_pad_o  => spi_dout_o,
      miso_pad_i  => spi_din_t(spi_din_t'left)
      );

  -- 32-bit word to byte address
  wb_adr_fmc_spi <= wb_adr(2 downto 0) & "00";

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
  --    Thermometer control
  ------------------------------------------------------------------------------
  cmp_fmc_i2c : i2c_master_top
    generic map (
      ARST_LVL => '0')
    port map (
      wb_clk_i     => sys_clk_125,
      wb_rst_i     => sys_rst,
      arst_i       => '1',
      wb_adr_i     => wb_adr_fmc_i2c(2 downto 0),
      wb_dat_i     => wb_dat_o(7 downto 0),
      wb_dat_o     => wb_dat_fmc_i2c(7 downto 0),
      wb_we_i      => wb_we,
      wb_stb_i     => wb_stb,
      wb_cyc_i     => wb_cyc_fmc_i2c,
      wb_ack_o     => wb_ack_fmc_i2c,
      wb_inta_o    => open,
      scl_pad_i    => si570_thermo_scl_in,
      scl_pad_o    => si570_thermo_scl_out,
      scl_padoen_o => si570_thermo_scl_oe_n,
      sda_pad_i    => si570_thermo_sda_in,
      sda_pad_o    => si570_thermo_sda_out,
      sda_padoen_o => si570_thermo_sda_oe_n);

  -- Even if I2C registers are 8-bit wide, they are accessed as 32-bit registers
  wb_adr_fmc_i2c <= wb_adr(2 downto 0);

  -- Tri-state buffer for SDA and SCL
  si570_thermo_scl_b  <= si570_thermo_scl_out when si570_thermo_scl_oe_n = '0' else 'Z';
  si570_thermo_scl_in <= si570_thermo_scl_b;

  si570_thermo_sda_b  <= si570_thermo_sda_out when si570_thermo_sda_oe_n = '0' else 'Z';
  si570_thermo_sda_in <= si570_thermo_sda_b;

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
      wb_csr_dat_o => wb_dat_fmc_adc_core,
      wb_csr_cyc_i => wb_cyc_fmc_adc_core,
      wb_csr_sel_i => wb_sel,
      wb_csr_stb_i => wb_stb,
      wb_csr_we_i  => wb_we,
      wb_csr_ack_o => wb_ack_fmc_adc_core,

      wb_ddr_clk_i   => sys_clk_250,
      wb_ddr_adr_o   => wb_ddr_adr,
      wb_ddr_dat_o   => wb_ddr_dat_o,
      wb_ddr_sel_o   => wb_ddr_sel,
      wb_ddr_stb_o   => wb_ddr_stb,
      wb_ddr_we_o    => wb_ddr_we,
      wb_ddr_cyc_o   => wb_ddr_cyc,
      wb_ddr_dat_i   => wb_ddr_dat_i,
      wb_ddr_ack_i   => wb_ddr_ack,
      wb_ddr_stall_i => wb_ddr_stall,

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

      gpio_dac_clr_n_o   => gpio_dac_clr_n_o,
      gpio_led_power_o   => gpio_led_power_o,
      gpio_led_trigger_o => gpio_led_trigger_o,
      gpio_ssr_ch1_o     => gpio_ssr_ch1_o,
      gpio_ssr_ch2_o     => gpio_ssr_ch2_o,
      gpio_ssr_ch3_o     => gpio_ssr_ch3_o,
      gpio_ssr_ch4_o     => gpio_ssr_ch4_o,
      gpio_si570_oe_o    => gpio_si570_oe_o
      );

  ------------------------------------------------------------------------------
  -- Interrupt stuff
  ------------------------------------------------------------------------------
  -- just forward irq pulses for test
  irq_to_gn4124 <= irq_sources(1) or irq_sources(0);

  ------------------------------------------------------------------------------
  -- DMA wishbone bus slaves
  --  -> DDR3 controller
  ------------------------------------------------------------------------------
  cmp_ddr_ctrl : ddr3_ctrl
    generic map(
      g_MEMCLK_PERIOD => 3000,
      g_SIMULATION    => g_SIMULATION,
      g_CALIB_SOFT_IP => g_CALIB_SOFT_IP)
    port map (
      clk_i   => ddr_clk,
      rst_n_i => sys_rst_n,

      calib_done => ddr3_calib_done,

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

      wb0_clk_i   => sys_clk_250,
      wb0_sel_i   => wb_ddr_sel,
      wb0_cyc_i   => wb_ddr_cyc,
      wb0_stb_i   => wb_ddr_stb,
      wb0_we_i    => wb_ddr_we,
      wb0_addr_i  => wb_ddr_adr(27 downto 0),
      wb0_data_i  => wb_ddr_dat_o,
      wb0_data_o  => wb_ddr_dat_i,
      wb0_ack_o   => wb_ddr_ack,
      wb0_stall_o => wb_ddr_stall,

      wb1_clk_i   => sys_clk_125,
      wb1_sel_i   => "1111",
      wb1_cyc_i   => wb_dma_cyc,
      wb1_stb_i   => wb_dma_stb,
      wb1_we_i    => wb_dma_we,
      wb1_addr_i  => wb_dma_adr(27 downto 0),
      wb1_data_i  => wb_dma_dat_o,
      wb1_data_o  => wb_dma_dat_i,
      wb1_ack_o   => wb_dma_ack,
      wb1_stall_o => wb_dma_stall);

  ------------------------------------------------------------------------------
  -- Assign unused outputs
  ------------------------------------------------------------------------------
  GPIO(1) <= '0';


end rtl;
