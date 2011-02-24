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


entity spec_top is
  generic(
    g_SIMULATION    : string := "FALSE";
    g_CALIB_SOFT_IP : string := "TRUE");
  port
    (
      -- Global ports
      clk_20m_vcxo_i : in std_logic;    -- 20MHz VCXO clock

      --clk_125m_pllref_p_i : in std_logic;  -- 125 MHz PLL reference
      --clk_125m_pllref_n_i : in std_logic;

      -- From GN4124 Local bus
      L_CLKp : in std_logic;            -- Local bus clock (frequency set in GN4124 config registers)
      L_CLKn : in std_logic;            -- Local bus clock (frequency set in GN4124 config registers)

      L_RST_N : in std_logic;           -- Reset from GN4124 (RSTOUT18_N)

      -- General Purpose Interface
      GPIO : inout std_logic_vector(1 downto 0);  -- GPIO[0] -> GN4124 GPIO8
                                                  -- GPIO[1] -> GN4124 GPIO9

      -- PCIe to Local [Inbound Data] - RX
      P2L_RDY    : out std_logic;                      -- Rx Buffer Full Flag
      P2L_CLKn   : in  std_logic;                      -- Receiver Source Synchronous Clock-
      P2L_CLKp   : in  std_logic;                      -- Receiver Source Synchronous Clock+
      P2L_DATA   : in  std_logic_vector(15 downto 0);  -- Parallel receive data
      P2L_DFRAME : in  std_logic;                      -- Receive Frame
      P2L_VALID  : in  std_logic;                      -- Receive Data Valid

      -- Inbound Buffer Request/Status
      P_WR_REQ : in  std_logic_vector(1 downto 0);  -- PCIe Write Request
      P_WR_RDY : out std_logic_vector(1 downto 0);  -- PCIe Write Ready
      RX_ERROR : out std_logic;                     -- Receive Error

      -- Local to Parallel [Outbound Data] - TX
      L2P_DATA   : out std_logic_vector(15 downto 0);  -- Parallel transmit data
      L2P_DFRAME : out std_logic;                      -- Transmit Data Frame
      L2P_VALID  : out std_logic;                      -- Transmit Data Valid
      L2P_CLKn   : out std_logic;                      -- Transmitter Source Synchronous Clock-
      L2P_CLKp   : out std_logic;                      -- Transmitter Source Synchronous Clock+
      L2P_EDB    : out std_logic;                      -- Packet termination and discard

      -- Outbound Buffer Status
      L2P_RDY    : in std_logic;                     -- Tx Buffer Full Flag
      L_WR_RDY   : in std_logic_vector(1 downto 0);  -- Local-to-PCIe Write
      P_RD_D_RDY : in std_logic_vector(1 downto 0);  -- PCIe-to-Local Read Response Data Ready
      TX_ERROR   : in std_logic;                     -- Transmit Error
      VC_RDY     : in std_logic_vector(1 downto 0);  -- Channel ready

      -- Font panel LEDs
      LED_RED   : out std_logic;
      LED_GREEN : out std_logic;

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
      DDR3_RZQ     : inout std_logic
      );
end spec_top;


architecture rtl of spec_top is

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
  end component;  --  gn4124_core

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
      wb0_addr_i  : in  std_logic_vector(29 downto 0);
      wb0_data_i  : in  std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb0_data_o  : out std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb0_ack_o   : out std_logic;
      wb0_stall_o : out std_logic;

      wb1_clk_i   : in  std_logic;
      wb1_sel_i   : in  std_logic_vector(g_P0_MASK_SIZE - 1 downto 0);
      wb1_cyc_i   : in  std_logic;
      wb1_stb_i   : in  std_logic;
      wb1_we_i    : in  std_logic;
      wb1_addr_i  : in  std_logic_vector(29 downto 0);
      wb1_data_i  : in  std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb1_data_o  : out std_logic_vector(g_P0_DATA_PORT_SIZE - 1 downto 0);
      wb1_ack_o   : out std_logic;
      wb1_stall_o : out std_logic
      );
  end component ddr3_ctrl;

  component gpio_regs
    port (
      rst_n_i         : in  std_logic;
      wb_clk_i        : in  std_logic;
      wb_addr_i       : in  std_logic_vector(2 downto 0);
      wb_data_i       : in  std_logic_vector(31 downto 0);
      wb_data_o       : out std_logic_vector(31 downto 0);
      wb_cyc_i        : in  std_logic;
      wb_sel_i        : in  std_logic_vector(3 downto 0);
      wb_stb_i        : in  std_logic;
      wb_we_i         : in  std_logic;
      wb_ack_o        : out std_logic;
      gpio_stat_i     : in  std_logic_vector(31 downto 0);
      gpio_ctrl_1_o   : out std_logic_vector(31 downto 0);
      gpio_ctrl_2_o   : out std_logic_vector(31 downto 0);
      gpio_ctrl_3_o   : out std_logic_vector(31 downto 0);
      gpio_led_ctrl_o : out std_logic_vector(31 downto 0)
      );
  end component gpio_regs;

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

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  constant c_BAR0_APERTURE     : integer := 20;
  constant c_CSR_WB_SLAVES_NB  : integer := 3;
  constant c_DMA_WB_SLAVES_NB  : integer := 1;
  constant c_DMA_WB_ADDR_WIDTH : integer := 26;

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------

  -- System clock
  signal sys_clk_in         : std_logic;
  signal sys_clk_50_buf     : std_logic;
  signal sys_clk_200_buf    : std_logic;
  signal sys_clk_50         : std_logic;
  signal sys_clk_200        : std_logic;
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
  signal rst : std_logic;

  -- CSR wishbone bus
  signal wb_adr     : std_logic_vector(c_BAR0_APERTURE-log2_ceil(c_CSR_WB_SLAVES_NB+1)-1 downto 0);
  signal wb_dat_i   : std_logic_vector((32*c_CSR_WB_SLAVES_NB)-1 downto 0);
  signal wb_dat_o   : std_logic_vector(31 downto 0);
  signal wb_sel     : std_logic_vector(3 downto 0);
  signal wb_cyc     : std_logic_vector(c_CSR_WB_SLAVES_NB-1 downto 0);
  signal wb_stb     : std_logic;
  signal wb_we      : std_logic;
  signal wb_ack     : std_logic_vector(c_CSR_WB_SLAVES_NB-1 downto 0);
  signal spi_wb_adr : std_logic_vector(4 downto 0);
  signal ddr_wb_adr : std_logic_vector(29 downto 0);

  -- DMA wishbone bus
  signal dma_adr     : std_logic_vector(31 downto 0);
  signal dma_dat_i   : std_logic_vector((32*c_DMA_WB_SLAVES_NB)-1 downto 0);
  signal dma_dat_o   : std_logic_vector(31 downto 0);
  signal dma_sel     : std_logic_vector(3 downto 0);
  signal dma_cyc     : std_logic;       --_vector(c_DMA_WB_SLAVES_NB-1 downto 0);
  signal dma_stb     : std_logic;
  signal dma_we      : std_logic;
  signal dma_ack     : std_logic;       --_vector(c_DMA_WB_SLAVES_NB-1 downto 0);
  signal dma_stall   : std_logic;       --_vector(c_DMA_WB_SLAVES_NB-1 downto 0);
  signal ram_we      : std_logic_vector(0 downto 0);
  signal ddr_dma_adr : std_logic_vector(29 downto 0);

  -- Interrupts stuff
  signal irq_sources       : std_logic_vector(1 downto 0);
  signal irq_to_gn4124     : std_logic;
  signal irq_sources_2_led : std_logic_vector(1 downto 0);

  -- CSR whisbone slaves for test
  signal gpio_stat     : std_logic_vector(31 downto 0);
  signal gpio_ctrl_1   : std_logic_vector(31 downto 0);
  signal gpio_ctrl_2   : std_logic_vector(31 downto 0);
  signal gpio_ctrl_3   : std_logic_vector(31 downto 0);
  signal gpio_led_ctrl : std_logic_vector(31 downto 0);

  -- DDR3
  signal ddr3_calib_done : std_logic;


begin


  ------------------------------------------------------------------------------
  -- Clocks distribution from 20MHz TCXO
  --  50.000 MHz system clock
  -- 200.000 MHz fast system clock
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
      CLKOUT0_DIVIDE     => 20,
      CLKOUT0_PHASE      => 0.000,
      CLKOUT0_DUTY_CYCLE => 0.500,
      CLKOUT1_DIVIDE     => 5,
      CLKOUT1_PHASE      => 0.000,
      CLKOUT1_DUTY_CYCLE => 0.500,
      CLKOUT2_DIVIDE     => 3,
      CLKOUT2_PHASE      => 0.000,
      CLKOUT2_DUTY_CYCLE => 0.500,
      CLKIN_PERIOD       => 40.0,
      REF_JITTER         => 0.016)
    port map (
      CLKFBOUT => sys_clk_fb,
      CLKOUT0  => sys_clk_50_buf,
      CLKOUT1  => sys_clk_200_buf,
      CLKOUT2  => ddr_clk_buf,
      CLKOUT3  => open,
      CLKOUT4  => open,
      CLKOUT5  => open,
      LOCKED   => sys_clk_pll_locked,
      RST      => '0',
      CLKFBIN  => sys_clk_fb,
      CLKIN    => sys_clk_in);

  cmp_clk_50_buf : BUFG
    port map (
      O => sys_clk_50,
      I => sys_clk_50_buf);

  cmp_clk_200_buf : BUFG
    port map (
      O => sys_clk_200,
      I => sys_clk_200_buf);

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
  -- Active high reset
  ------------------------------------------------------------------------------
  rst <= not(L_RST_N);

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
      ---------------------------------------------------------
      -- Control and status
      --
      -- Asynchronous reset from GN4124
      rst_n_a_i      => L_RST_N,
      -- P2L clock PLL locked
      p2l_pll_locked => p2l_pll_locked,
      -- Debug outputs
      debug_o        => open,

      ---------------------------------------------------------
      -- P2L Direction
      --
      -- Source Sync DDR related signals
      p2l_clk_p_i  => P2L_CLKp,
      p2l_clk_n_i  => P2L_CLKn,
      p2l_data_i   => P2L_DATA,
      p2l_dframe_i => P2L_DFRAME,
      p2l_valid_i  => P2L_VALID,

      -- P2L Control
      p2l_rdy_o  => P2L_RDY,
      p_wr_req_i => P_WR_REQ,
      p_wr_rdy_o => P_WR_RDY,
      rx_error_o => RX_ERROR,

      ---------------------------------------------------------
      -- L2P Direction
      --
      -- Source Sync DDR related signals
      l2p_clk_p_o  => L2P_CLKp,
      l2p_clk_n_o  => L2P_CLKn,
      l2p_data_o   => L2P_DATA,
      l2p_dframe_o => L2P_DFRAME,
      l2p_valid_o  => L2P_VALID,
      l2p_edb_o    => L2P_EDB,

      -- L2P Control
      l2p_rdy_i    => L2P_RDY,
      l_wr_rdy_i   => L_WR_RDY,
      p_rd_d_rdy_i => P_RD_D_RDY,
      tx_error_i   => TX_ERROR,
      vc_rdy_i     => VC_RDY,

      ---------------------------------------------------------
      -- Interrupt interface
      dma_irq_o => irq_sources,
      irq_p_i   => irq_to_gn4124,
      irq_p_o   => GPIO(0),

      ---------------------------------------------------------
      -- CSR wishbone interface
      wb_clk_i => sys_clk_50,
      wb_adr_o => wb_adr,
      wb_dat_o => wb_dat_o,
      wb_sel_o => wb_sel,
      wb_stb_o => wb_stb,
      wb_we_o  => wb_we,
      wb_cyc_o => wb_cyc,
      wb_dat_i => wb_dat_i,
      wb_ack_i => wb_ack,

      ---------------------------------------------------------
      -- DMA wishbone interface (pipelined)
      dma_clk_i   => sys_clk_50,
      dma_adr_o   => dma_adr,
      dma_dat_o   => dma_dat_o,
      dma_sel_o   => dma_sel,
      dma_stb_o   => dma_stb,
      dma_we_o    => dma_we,
      dma_cyc_o   => dma_cyc,
      dma_dat_i   => dma_dat_i,
      dma_ack_i   => dma_ack,
      dma_stall_i => dma_stall);

  ------------------------------------------------------------------------------
  -- CSR wishbone bus slaves
  --  0 -> Not connected
  --  1 -> gpio registers
  --  2 -> DDR3 controller port0
  ------------------------------------------------------------------------------
  cmp_gpio_regs : gpio_regs
    port map(
      rst_n_i         => L_RST_N,
      wb_clk_i        => sys_clk_50,
      wb_addr_i       => wb_adr(2 downto 0),
      wb_data_i       => wb_dat_o,
      wb_data_o       => wb_dat_i(63 downto 32),
      wb_cyc_i        => wb_cyc(1),
      wb_sel_i        => wb_sel,
      wb_stb_i        => wb_stb,
      wb_we_i         => wb_we,
      wb_ack_o        => wb_ack(1),
      gpio_stat_i     => gpio_stat,
      gpio_ctrl_1_o   => gpio_ctrl_1,
      gpio_ctrl_2_o   => gpio_ctrl_2,
      gpio_ctrl_3_o   => gpio_ctrl_3,
      gpio_led_ctrl_o => gpio_led_ctrl);

  gpio_stat <= X"DEAD000"
               & '0'
               & ddr3_calib_done
               & sys_clk_pll_locked
               & p2l_pll_locked;

  gen_irq_led : for I in 0 to 1 generate
    cmp_irq_led : monostable
      generic map(
        g_INPUT_POLARITY  => '1',
        g_OUTPUT_POLARITY => '1',
        g_OUTPUT_RETRIG   => false,
        g_OUTPUT_LENGTH   => 5000000)
      port map(
        rst_n_i   => L_RST_N,
        clk_i     => sys_clk_50,
        trigger_i => irq_sources(I),
        pulse_o   => irq_sources_2_led(I));
  end generate gen_irq_led;


  LED_RED   <= gpio_led_ctrl(0) or irq_sources_2_led(0);
  LED_GREEN <= gpio_led_ctrl(1) or irq_sources_2_led(1);

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
      rst_n_i => L_RST_N,

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

      wb0_clk_i   => sys_clk_50,              --'0',
      wb0_sel_i   => "1111",
      wb0_cyc_i   => wb_cyc(2),               --'0',
      wb0_stb_i   => wb_stb,                  --'0',
      wb0_we_i    => wb_we,                   --'0',
      wb0_addr_i  => ddr_wb_adr,              --X"0000000" & "00",
      wb0_data_i  => wb_dat_o,                --X"00000000",
      wb0_data_o  => wb_dat_i(95 downto 64),  --open,
      wb0_ack_o   => wb_ack(2),               --open,
      wb0_stall_o => open,

      wb1_clk_i   => sys_clk_50,
      wb1_sel_i   => "1111",
      wb1_cyc_i   => dma_cyc,
      wb1_stb_i   => dma_stb,
      wb1_we_i    => dma_we,
      wb1_addr_i  => ddr_dma_adr,
      wb1_data_i  => dma_dat_o,
      wb1_data_o  => dma_dat_i,
      wb1_ack_o   => dma_ack,
      wb1_stall_o => dma_stall);

  -- 32-bit word to byte address
  ddr_wb_adr <= "0000000000" & wb_adr & "00";

  -- 32-bit word to byte address
  ddr_dma_adr <= dma_adr(27 downto 0) & "00";

  ------------------------------------------------------------------------------
  -- Assign unused outputs
  ------------------------------------------------------------------------------
  GPIO(1) <= '0';


end rtl;
