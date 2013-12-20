library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.textio.all;

--library std_developerskit;
--use std_developerskit.std_iopak.all;

use work.util.all;
use work.textutil.all;

--############################################################################
--############################################################################
--==========================================================================--
--
-- *Module      : tb_spec
--
-- *Description : Test Bench for the GN4124 BFM + SPEC Design
--
-- *History
--
--==========================================================================--
--############################################################################
--############################################################################

entity TB_SPEC is
  generic
    (
      T_LCLK : time := 30 ns            -- Default LCLK Clock Period 
      );
end TB_SPEC;

architecture TEST of TB_SPEC is

--###########################################################################
--###########################################################################
--##
--## Component Declairations
--##
--###########################################################################
--###########################################################################
-----------------------------------------------------------------------------
-- GN4124 Local Bus Model
-----------------------------------------------------------------------------
  component GN412X_BFM
    generic
      (
        STRING_MAX     : integer := 256;           -- Command string maximum length
        T_LCLK         : time    := 5 ns;          -- Local Bus Clock Period
        T_P2L_CLK_DLY  : time    := 2 ns;          -- Delay from LCLK to P2L_CLK
        INSTANCE_LABEL : string  := "GN412X_BFM";  -- Label string to be used as a prefix for messages from the model
        MODE_PRIMARY   : boolean := true           -- TRUE for BFM acting as GN412x, FALSE for BFM acting as the DUT
        );
    port
      (
        --=========================================================--
        -------------------------------------------------------------
        -- CMD_ROUTER Interface
        --
        CMD                : in    string(1 to STRING_MAX);
        CMD_REQ            : in    bit;
        CMD_ACK            : out   bit;
        CMD_CLOCK_EN       : in    boolean;
        --=========================================================--
        -------------------------------------------------------------
        -- GN412x Signal I/O
        -------------------------------------------------------------
        -- This is the reset input to the BFM
        --
        RSTINn             : in    std_logic;
        -------------------------------------------------------------
        -- Reset outputs to DUT
        --
        RSTOUT18n          : out   std_logic;
        RSTOUT33n          : out   std_logic;
        -------------------------------------------------------------
        ----------------- Local Bus Clock ---------------------------
        -------------------------------------------------------------  __ Direction for primary mode
        --                                                            / \
        LCLK, LCLKn        : inout std_logic;      -- Out
        -------------------------------------------------------------
        ----------------- Local-to-PCI Dataflow ---------------------
        -------------------------------------------------------------
        -- Transmitter Source Synchronous Clock.
        --
        L2P_CLKp, L2P_CLKn : inout std_logic;      -- In  
        -------------------------------------------------------------
        -- L2P DDR Link
        --
        L2P_DATA           : inout std_logic_vector(15 downto 0);  -- In  -- Parallel Transmit Data.
        L2P_DFRAME         : inout std_logic;  -- In  -- Transmit Data Frame.
        L2P_VALID          : inout std_logic;  -- In  -- Transmit Data Valid. 
        L2P_EDB            : inout std_logic;  -- In  -- End-of-Packet Bad Flag.
        -------------------------------------------------------------
        -- L2P SDR Controls
        --
        L_WR_RDY           : inout std_logic_vector(1 downto 0);  -- Out -- Local-to-PCIe Write.
        P_RD_D_RDY         : inout std_logic_vector(1 downto 0);  -- Out -- PCIe-to-Local Read Response Data Ready.
        L2P_RDY            : inout std_logic;  -- Out -- Tx Buffer Full Flag.
        TX_ERROR           : inout std_logic;  -- Out -- Transmit Error.
        -------------------------------------------------------------
        ----------------- PCIe-to-Local Dataflow ---------------------
        -------------------------------------------------------------
        -- Transmitter Source Synchronous Clock.
        --
        P2L_CLKp, P2L_CLKn : inout std_logic;  -- Out -- P2L Source Synchronous Clock.
        -------------------------------------------------------------
        -- P2L DDR Link
        --
        P2L_DATA           : inout std_logic_vector(15 downto 0);  -- Out -- Parallel Receive Data.
        P2L_DFRAME         : inout std_logic;  -- Out -- Receive Frame.
        P2L_VALID          : inout std_logic;  -- Out -- Receive Data Valid.
        -------------------------------------------------------------
        -- P2L SDR Controls
        --
        P2L_RDY            : inout std_logic;  -- In  -- Rx Buffer Full Flag.
        P_WR_REQ           : inout std_logic_vector(1 downto 0);  -- Out -- PCIe Write Request.
        P_WR_RDY           : inout std_logic_vector(1 downto 0);  -- In  -- PCIe Write Ready.
        RX_ERROR           : inout std_logic;  -- In  -- Receive Error.
        VC_RDY             : inout std_logic_vector(1 downto 0);  -- Out -- Virtual Channel Ready Status.
        -------------------------------------------------------------
        -- GPIO signals
        --
        GPIO               : inout std_logic_vector(15 downto 0)
        );
  end component;  --GN412X_BFM;

-----------------------------------------------------------------------------
-- CMD_ROUTER component
-----------------------------------------------------------------------------
  component cmd_router
    generic(N_BFM      : integer := 8;
            N_FILES    : integer := 3;
            FIFO_DEPTH : integer := 8;
            STRING_MAX : integer := 256
            );
    port(CMD          : out string(1 to STRING_MAX);
         CMD_REQ      : out bit_vector(N_BFM-1 downto 0);
         CMD_ACK      : in  bit_vector(N_BFM-1 downto 0);
         CMD_ERR      : in  bit_vector(N_BFM-1 downto 0);
         CMD_CLOCK_EN : out boolean
         );
  end component;  --cmd_router;

-----------------------------------------------------------------------------
-- CMD_ROUTER component
-----------------------------------------------------------------------------
  component simple
    port(
      clk : in  std_logic;
      d   : in  std_logic_vector(15 downto 0);
      q   : out std_logic_vector(15 downto 0)
      );
  end component;

-----------------------------------------------------------------------------
-- Design top entity
-----------------------------------------------------------------------------
  component spec_top_fmc_adc_100Ms
    generic(
      g_SIMULATION    : string := "FALSE";
      g_CALIB_SOFT_IP : string := "TRUE");
    port
      (
        -- Local oscillator
        clk20_vcxo_i : in std_logic;    -- 20MHz VCXO clock

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

        adc0_one_wire_b : inout std_logic;  -- 1-wire interface (DS18B20 thermometer + unique ID)

        fmc0_prsnt_m2c_n_i : in std_logic;   -- Mezzanine present (active low)

        fmc0_sys_scl_b : inout std_logic;    -- Mezzanine system I2C clock (EEPROM)
        fmc0_sys_sda_b : inout std_logic     -- Mezzanine system I2C data (EEPROM)
        );
  end component spec_top_fmc_adc_100Ms;

  ------------------------------------------------------------------------------
  -- DDR3 model
  ------------------------------------------------------------------------------
  component ddr3
    port (
      rst_n   : in    std_logic;
      ck      : in    std_logic;
      ck_n    : in    std_logic;
      cke     : in    std_logic;
      cs_n    : in    std_logic;
      ras_n   : in    std_logic;
      cas_n   : in    std_logic;
      we_n    : in    std_logic;
      dm_tdqs : inout std_logic_vector(1 downto 0);
      ba      : in    std_logic_vector(2 downto 0);
      addr    : in    std_logic_vector(13 downto 0);
      dq      : inout std_logic_vector(15 downto 0);
      dqs     : inout std_logic_vector(1 downto 0);
      dqs_n   : inout std_logic_vector(1 downto 0);
      tdqs_n  : out   std_logic_vector(1 downto 0);
      odt     : in    std_logic
      );
  end component;

--###########################################################################
--###########################################################################
--##
--## Constants
--##
--###########################################################################
--###########################################################################
  --
  -- Number of Models receiving commands
  constant N_BFM      : integer := 2;   -- 0 : GN412X_BFM in Model Mode
  --                                  -- 1 : GN412X_BFM in DUT mode
  -- Number of files to feed BFMs
  constant N_FILES    : integer := 2;
  --
  -- Depth of the command FIFO for each model
  constant FIFO_DEPTH : integer := 16;
  --
  -- Maximum width of a command string
  constant STRING_MAX : integer := 256;

--###########################################################################
--###########################################################################
--##
--## Signals
--##
--###########################################################################
--###########################################################################
-----------------------------------------------------------------------------
-- Command Router Signals
-----------------------------------------------------------------------------
  signal CMD          : string(1 to STRING_MAX);
  signal CMD_REQ      : bit_vector(N_BFM-1 downto 0);
  signal CMD_ACK      : bit_vector(N_BFM-1 downto 0);
  signal CMD_ERR      : bit_vector(N_BFM-1 downto 0);
  signal CMD_CLOCK_EN : boolean;

-----------------------------------------------------------------------------
-- GN412x BFM Signals
-----------------------------------------------------------------------------

  -- System signals
  signal clk20_vcxo_i       : std_logic                    := '0';  -- 20MHz VCXO clock
  signal led_red_o          : std_logic;
  signal led_green_o        : std_logic;
  signal pcb_ver_i          : std_logic_vector(3 downto 0) := X"1";
  signal carrier_one_wire_b : std_logic;                            -- 1-wire interface (DS18B20)

  -- GN4124 interface
  signal RSTINn             : std_logic;
  signal RSTOUT18n          : std_logic;
  signal RSTOUT33n          : std_logic;
  signal LCLK, LCLKn        : std_logic;
  signal L2P_CLKp, L2P_CLKn : std_logic;
  signal L2P_DATA           : std_logic_vector(15 downto 0);
  signal L2P_DATA_32        : std_logic_vector(31 downto 0);  -- For monitoring use
  signal L2P_DFRAME         : std_logic;
  signal L2P_VALID          : std_logic;
  signal L2P_EDB            : std_logic;
  signal L_WR_RDY           : std_logic_vector(1 downto 0);
  signal P_RD_D_RDY         : std_logic_vector(1 downto 0);
  signal L2P_RDY            : std_logic;
  signal TX_ERROR           : std_logic;
  signal P2L_CLKp, P2L_CLKn : std_logic;
  signal P2L_DATA           : std_logic_vector(15 downto 0);
  signal P2L_DATA_32        : std_logic_vector(31 downto 0);  -- For monitoring use
  signal P2L_DFRAME         : std_logic;
  signal P2L_VALID          : std_logic;
  signal P2L_RDY            : std_logic;
  signal P_WR_REQ           : std_logic_vector(1 downto 0);
  signal P_WR_RDY           : std_logic_vector(1 downto 0);
  signal RX_ERROR           : std_logic;
  signal VC_RDY             : std_logic_vector(1 downto 0);
  signal GPIO               : std_logic_vector(15 downto 0);

  -- Font panel LEDs
  signal LED_RED   : std_logic;
  signal LED_GREEN : std_logic;

  -- Auxiliary pins
  signal aux_leds_o    : std_logic_vector(3 downto 0);
  signal aux_buttons_i : std_logic_vector(1 downto 0);

  -- DDR3 interface
  signal ddr3_a_o     : std_logic_vector(13 downto 0);
  signal ddr3_ba_o    : std_logic_vector(2 downto 0);
  signal ddr3_cas_n_o : std_logic;
  signal ddr3_clk_p_o : std_logic;
  signal ddr3_clk_n_o : std_logic;
  signal ddr3_cke_o   : std_logic;
  signal ddr3_dm_b    : std_logic_vector(1 downto 0)  := (others => 'Z');
  signal ddr3_dq_b    : std_logic_vector(15 downto 0) := (others => 'Z');
  signal ddr3_dqs_p_b : std_logic_vector(1 downto 0)  := (others => 'Z');
  signal ddr3_dqs_n_b : std_logic_vector(1 downto 0)  := (others => 'Z');
  signal ddr3_odt_o   : std_logic;
  signal ddr3_ras_n_o : std_logic;
  signal ddr3_rst_n_o : std_logic;
  signal ddr3_dm_o    : std_logic;
  signal ddr3_udm_o   : std_logic;
  --signal ddr3_udqs_p_b : std_logic                     := 'Z';
  --signal ddr3_udqs_n_b : std_logic                     := 'Z';
  signal ddr3_we_n_o  : std_logic;
  signal ddr3_rzq_b   : std_logic;
  signal ddr3_zio_b   : std_logic                     := 'Z';

  -- FMC slot
  signal ext_trigger_p_i : std_logic                    := '0';
  signal ext_trigger_n_i : std_logic                    := '1';
  signal adc_dco_p_i     : std_logic                    := '0';
  signal adc_dco_n_i     : std_logic                    := '1';
  signal adc_fr_p_i      : std_logic                    := '0';              -- ADC frame start
  signal adc_fr_n_i      : std_logic                    := '1';
  signal adc_outa_p_i    : std_logic_vector(3 downto 0) := (others => '0');  -- ADC serial data (odd bits)
  signal adc_outa_n_i    : std_logic_vector(3 downto 0) := (others => '1');
  signal adc_outb_p_i    : std_logic_vector(3 downto 0) := (others => '0');  -- ADC serial data (even bits)
  signal adc_outb_n_i    : std_logic_vector(3 downto 0) := (others => '1');

  signal spi_din_i       : std_logic := '0';  -- SPI data from FMC
  signal spi_dout_o      : std_logic;         -- SPI data to FMC
  signal spi_sck_o       : std_logic;         -- SPI clock
  signal spi_cs_adc_n_o  : std_logic;         -- SPI ADC chip select (active low)
  signal spi_cs_dac1_n_o : std_logic;         -- SPI channel 1 offset DAC chip select (active low)
  signal spi_cs_dac2_n_o : std_logic;         -- SPI channel 2 offset DAC chip select (active low)
  signal spi_cs_dac3_n_o : std_logic;         -- SPI channel 3 offset DAC chip select (active low)
  signal spi_cs_dac4_n_o : std_logic;         -- SPI channel 4 offset DAC chip select (active low)

  signal gpio_dac_clr_n_o : std_logic;                     -- offset DACs clear (active low)
  signal gpio_led_acq_o   : std_logic;                     -- Mezzanine front panel power LED (PWR)
  signal gpio_led_trig_o  : std_logic;                     -- Mezzanine front panel trigger LED (TRIG)
  signal gpio_ssr_ch1_o   : std_logic_vector(6 downto 0);  -- Channel 1 solid state relays control
  signal gpio_ssr_ch2_o   : std_logic_vector(6 downto 0);  -- Channel 2 solid state relays control
  signal gpio_ssr_ch3_o   : std_logic_vector(6 downto 0);  -- Channel 3 solid state relays control
  signal gpio_ssr_ch4_o   : std_logic_vector(6 downto 0);  -- Channel 4 solid state relays control
  signal gpio_si570_oe_o  : std_logic;                     -- Si570 (programmable oscillator) output enable

  signal si570_scl_b : std_logic;       -- I2C bus clock (Si570)
  signal si570_sda_b : std_logic;       -- I2C bus data (Si570)

  signal mezz_one_wire_b : std_logic;   -- 1-wire interface (DS18B20)

  signal prsnt_m2c_n_i : std_logic := '0';  -- Mezzanine present (active low)

  signal sys_scl_b : std_logic;
  signal sys_sda_b : std_logic;

-----------------------------------------------------------------------------
-- Bus Monitor Signals
-----------------------------------------------------------------------------
  signal Q_P2L_DFRAME : std_logic;

  signal SIMPLE_TEST : std_logic_vector(15 downto 0);

-----------------------------------------------------------------------------
-- ADC data signals
-----------------------------------------------------------------------------
  -- ADC data
  type   data_in_t is array (0 to 3) of unsigned(15 downto 0);
  --constant ADC_DATA   : data_in_t                    := (0 => X"D158", 1 => X"D158", 2 => X"D158", 3 => X"D158");
  signal ADC_DATA  : data_in_t                    := (0 => X"0000", 1 => X"1000", 2 => X"2000", 3 => X"3000");
  signal ADC_FRAME : std_logic_vector(7 downto 0) := X"0F";

--###########################################################################
--###########################################################################
--##
--## Start of Code
--##
--###########################################################################
--###########################################################################

begin

-----------------------------------------------------------------------------
-- MODEL Component
-----------------------------------------------------------------------------

  CMD_ERR <= (others => '0');

  UC : cmd_router
    generic map
    (N_BFM      => N_BFM,
     N_FILES    => N_FILES,
     FIFO_DEPTH => FIFO_DEPTH,
     STRING_MAX => STRING_MAX
     )
    port map
    (CMD          => CMD,
     CMD_REQ      => CMD_REQ,
     CMD_ACK      => CMD_ACK,
     CMD_ERR      => CMD_ERR,
     CMD_CLOCK_EN => CMD_CLOCK_EN
     );

-----------------------------------------------------------------------------
-- GN412x BFM - PRIMARY
-----------------------------------------------------------------------------

  U0 : gn412x_bfm
    generic map
    (
      STRING_MAX     => STRING_MAX,
      T_LCLK         => 5 ns,
      T_P2L_CLK_DLY  => 2 ns,
      INSTANCE_LABEL => "U0(Primary GN412x): ",
      MODE_PRIMARY   => true
      )
    port map
    (
      --=========================================================--
      -------------------------------------------------------------
      -- CMD_ROUTER Interface
      --
      CMD          => CMD,
      CMD_REQ      => CMD_REQ(0),
      CMD_ACK      => CMD_ACK(0),
      CMD_CLOCK_EN => CMD_CLOCK_EN,
      --=========================================================--
      -------------------------------------------------------------
      -- GN412x Signal I/O
      -------------------------------------------------------------
      -- This is the reset input to the BFM
      --
      RSTINn       => RSTINn,
      -------------------------------------------------------------
      -- Reset outputs to DUT
      --
      RSTOUT18n    => RSTOUT18n,
      RSTOUT33n    => RSTOUT33n,
      -------------------------------------------------------------
      ----------------- Local Bus Clock ---------------------------
      ------------------------------------------------------------- 
      --
      LCLK         => LCLK,
      LCLKn        => LCLKn,
      -------------------------------------------------------------
      ----------------- Local-to-PCI Dataflow ---------------------
      -------------------------------------------------------------
      -- Transmitter Source Synchronous Clock.
      --
      L2P_CLKp     => L2P_CLKp,
      L2P_CLKn     => L2P_CLKn,
      -------------------------------------------------------------
      -- L2P DDR Link
      --
      L2P_DATA     => L2P_DATA,
      L2P_DFRAME   => L2P_DFRAME,
      L2P_VALID    => L2P_VALID,
      L2P_EDB      => L2P_EDB,
      -------------------------------------------------------------
      -- L2P SDR Controls
      --
      L_WR_RDY     => L_WR_RDY,
      P_RD_D_RDY   => P_RD_D_RDY,
      L2P_RDY      => L2P_RDY,
      TX_ERROR     => TX_ERROR,
      -------------------------------------------------------------
      ----------------- PCIe-to-Local Dataflow ---------------------
      -------------------------------------------------------------
      -- Transmitter Source Synchronous Clock.
      --
      P2L_CLKp     => P2L_CLKp,
      P2L_CLKn     => P2L_CLKn,
      -------------------------------------------------------------
      -- P2L DDR Link
      --
      P2L_DATA     => P2L_DATA,
      P2L_DFRAME   => P2L_DFRAME,
      P2L_VALID    => P2L_VALID,
      -------------------------------------------------------------
      -- P2L SDR Controls
      --
      P2L_RDY      => P2L_RDY,
      P_WR_REQ     => P_WR_REQ,
      P_WR_RDY     => P_WR_RDY,
      RX_ERROR     => RX_ERROR,
      VC_RDY       => VC_RDY,
      GPIO         => gpio
      );                                -- GN412X_BFM;


-----------------------------------------------------------------------------
-- UUT
-----------------------------------------------------------------------------

  U1 : spec_top_fmc_adc_100Ms
    generic map (
      g_SIMULATION    => "TRUE",
      g_CALIB_SOFT_IP => "FALSE")
    port map (
      clk20_vcxo_i       => clk20_vcxo_i,
      led_red_o          => LED_RED,
      led_green_o        => LED_GREEN,
      aux_leds_o         => aux_leds_o,
      aux_buttons_i      => aux_buttons_i,
      pcb_ver_i          => pcb_ver_i,
      carrier_one_wire_b => carrier_one_wire_b,

      -- GN4124 interface
      l_clkp     => LCLK,               -- Running at 200 Mhz
      l_clkn     => LCLKn,              -- Running at 200 Mhz
      l_rst_n    => RSTOUT18n,
      p2l_rdy    => P2L_RDY,            -- Rx Buffer Full Flag
      p2l_clkn   => P2L_CLKn,           -- Receiver Source Synchronous Clock-
      p2l_clkp   => P2L_CLKp,           -- Receiver Source Synchronous Clock+
      p2l_data   => P2L_DATA,           -- Parallel receive data
      p2l_dframe => P2L_DFRAME,         -- Receive Frame
      p2l_valid  => P2L_VALID,          -- Receive Data Valid
      p_wr_req   => P_WR_REQ,           -- PCIe Write Request
      p_wr_rdy   => P_WR_RDY,           -- PCIe Write Ready
      rx_error   => RX_ERROR,           -- Receive Error
      l2p_data   => L2P_DATA,           -- Parallel transmit data 
      l2p_dframe => L2P_DFRAME,         -- Transmit Data Frame
      l2p_valid  => L2P_VALID,          -- Transmit Data Valid
      l2p_clkn   => L2P_CLKn,           -- Transmitter Source Synchronous Clock-
      l2p_clkp   => L2P_CLKp,           -- Transmitter Source Synchronous Clock+
      l2p_edb    => L2P_EDB,            -- Packet termination and discard
      l2p_rdy    => L2P_RDY,            -- Tx Buffer Full Flag
      l_wr_rdy   => L_WR_RDY,           -- Local-to-PCIe Write
      p_rd_d_rdy => P_RD_D_RDY,         -- PCIe-to-Local Read Response Data Ready
      tx_error   => TX_ERROR,           -- Transmit Error
      vc_rdy     => VC_RDY,             -- Channel ready
      gpio       => GPIO(9 downto 8),   -- General Purpose Input/Output

      -- FMC slot
      adc0_ext_trigger_p_i => ext_trigger_p_i,
      adc0_ext_trigger_n_i => ext_trigger_n_i,

      adc0_dco_p_i  => adc_dco_p_i,
      adc0_dco_n_i  => adc_dco_n_i,
      adc0_fr_p_i   => adc_fr_p_i,
      adc0_fr_n_i   => adc_fr_n_i,
      adc0_outa_p_i => adc_outa_p_i,
      adc0_outa_n_i => adc_outa_n_i,
      adc0_outb_p_i => adc_outb_p_i,
      adc0_outb_n_i => adc_outb_n_i,

      adc0_spi_din_i       => spi_din_i,
      adc0_spi_dout_o      => spi_dout_o,
      adc0_spi_sck_o       => spi_sck_o,
      adc0_spi_cs_adc_n_o  => spi_cs_adc_n_o ,
      adc0_spi_cs_dac1_n_o => spi_cs_dac1_n_o,
      adc0_spi_cs_dac2_n_o => spi_cs_dac2_n_o,
      adc0_spi_cs_dac3_n_o => spi_cs_dac3_n_o,
      adc0_spi_cs_dac4_n_o => spi_cs_dac4_n_o,

      adc0_gpio_dac_clr_n_o => gpio_dac_clr_n_o,
      adc0_gpio_led_acq_o   => gpio_led_acq_o,
      adc0_gpio_led_trig_o  => gpio_led_trig_o,
      adc0_gpio_ssr_ch1_o   => gpio_ssr_ch1_o,
      adc0_gpio_ssr_ch2_o   => gpio_ssr_ch2_o,
      adc0_gpio_ssr_ch3_o   => gpio_ssr_ch3_o,
      adc0_gpio_ssr_ch4_o   => gpio_ssr_ch4_o,
      adc0_gpio_si570_oe_o  => gpio_si570_oe_o,

      adc0_si570_scl_b => si570_scl_b,
      adc0_si570_sda_b => si570_sda_b,

      adc0_one_wire_b => mezz_one_wire_b,

      fmc0_prsnt_m2c_n_i => prsnt_m2c_n_i,

      fmc0_sys_scl_b => sys_scl_b,
      fmc0_sys_sda_b => sys_sda_b,

      -- DDR3 interface
      ddr3_a       => ddr3_a_o,
      ddr3_ba      => ddr3_ba_o,
      ddr3_cas_n   => ddr3_cas_n_o,
      ddr3_ck_p    => ddr3_clk_p_o,
      ddr3_ck_n    => ddr3_clk_n_o,
      ddr3_cke     => ddr3_cke_o,
      ddr3_ldm     => ddr3_dm_b(0),
      ddr3_dq      => ddr3_dq_b,
      ddr3_ldqs_p  => ddr3_dqs_p_b(0),
      ddr3_ldqs_n  => ddr3_dqs_n_b(0),
      ddr3_odt     => ddr3_odt_o,
      ddr3_ras_n   => ddr3_ras_n_o,
      ddr3_reset_n => ddr3_rst_n_o,
      ddr3_udm     => ddr3_dm_b(1),
      ddr3_udqs_p  => ddr3_dqs_p_b(1),
      ddr3_udqs_n  => ddr3_dqs_n_b(1),
      ddr3_we_n    => ddr3_we_n_o,
      ddr3_rzq     => ddr3_rzq_b,
      ddr3_zio     => ddr3_zio_b
      );


  cmp_ddr3_model : ddr3
    port map(
      rst_n   => ddr3_rst_n_o,
      ck      => ddr3_clk_p_o,
      ck_n    => ddr3_clk_n_o,
      cke     => ddr3_cke_o,
      cs_n    => '0',                   -- Pulled down on PCB
      ras_n   => ddr3_ras_n_o,
      cas_n   => ddr3_cas_n_o,
      we_n    => ddr3_we_n_o,
      dm_tdqs => ddr3_dm_b,
      ba      => ddr3_ba_o,
      addr    => ddr3_a_o,
      dq      => ddr3_dq_b,
      dqs     => ddr3_dqs_p_b,
      dqs_n   => ddr3_dqs_n_b,
      tdqs_n  => open,                  -- dqs outputs for chaining
      odt     => ddr3_odt_o
      );


  process
    variable vP2L_DATA_LOW : std_logic_vector(P2L_DATA'range);
  begin
    wait until(P2L_CLKp'event and (P2L_CLKp = '1'));
    vP2L_DATA_LOW := P2L_DATA;
    loop
      wait on P2L_DATA, P2L_CLKp;
      P2L_DATA_32 <= P2L_DATA & vP2L_DATA_LOW;
      if(P2L_CLKp = '0') then
        exit;
      end if;
    end loop;
  end process;

  sys_clk : process
  begin
    clk20_vcxo_i <= '1';
    wait for 25 ns;
    clk20_vcxo_i <= '0';
    wait for 25 ns;
  end process sys_clk;

  p_adc_dco : process
  begin
    adc_dco_p_i <= '1';
    adc_dco_n_i <= '0';
    wait for 1.25 ns;
    adc_dco_p_i <= '0';
    adc_dco_n_i <= '1';
    wait for 1.25 ns;
  end process p_adc_dco;

  p_adc_data : process
  begin
    for I in 7 downto 0 loop
      wait until adc_dco_p_i'event;
      wait for 625 ps;
      for CH in 0 to 3 loop
        adc_outa_p_i(CH) <= ADC_DATA(CH)((2*I)+1);
        adc_outb_p_i(CH) <= ADC_DATA(CH)(2*I);
      end loop;  -- CH
      adc_fr_p_i <= ADC_FRAME(I);
    end loop;  -- I
  end process;

  adc_outa_n_i <= not(adc_outa_p_i);
  adc_outb_n_i <= not(adc_outb_p_i);

  adc_fr_n_i <= not(adc_fr_p_i);

  p_adc_data_incr : process
  begin
    wait until rising_edge(adc_fr_p_i);
    if gpio_si570_oe_o = '1' then
      for CH in 0 to 3 loop
        ADC_DATA(CH) <= ADC_DATA(CH) + 1;
      end loop;  -- CH
    end if;
  end process p_adc_data_incr;


end TEST;
