library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

--library std_developerskit;
--use std_developerskit.std_iopak.all;

use work.util.all;
use work.textutil.all;

--############################################################################
--############################################################################
--==========================================================================--
--
-- *Module      : tb_lambo
--
-- *Description : Test Bench for the GN4124 BFM + Lambo Design
--
-- *History
--
--==========================================================================--
--############################################################################
--############################################################################

entity TB_LAMBO is
	generic
	(
		T_LCLK      : time    := 30 ns -- Default LCLK Clock Period 
	);
end TB_LAMBO;

architecture TEST of TB_LAMBO is

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
		STRING_MAX     : integer := 256;   -- Command string maximum length
		T_LCLK         : time    := 10 ns; -- Local Bus Clock Period
		T_P2L_CLK_DLY  : time    := 2  ns; -- Delay from LCLK to P2L_CLK
		INSTANCE_LABEL : string  := "GN412X_BFM"; -- Label string to be used as a prefix for messages from the model
		MODE_PRIMARY   : boolean := TRUE   -- TRUE for BFM acting as GN412x, FALSE for BFM acting as the DUT
	);
	port
	(
		--=========================================================--
		-------------------------------------------------------------
		-- CMD_ROUTER Interface
		--
		CMD                : in     STRING(1 to STRING_MAX);
		CMD_REQ            : in     BIT;
		CMD_ACK            : out    BIT;
		CMD_CLOCK_EN       : in     boolean;
		--=========================================================--
		-------------------------------------------------------------
		-- GN412x Signal I/O
		-------------------------------------------------------------
		-- This is the reset input to the BFM
		--
		RSTINn             : in     std_logic;
		-------------------------------------------------------------
		-- Reset outputs to DUT
		--
		RSTOUT18n          : out    std_logic;
		RSTOUT33n          : out    std_logic;
		-------------------------------------------------------------
		----------------- Local Bus Clock ---------------------------
		-------------------------------------------------------------  __ Direction for primary mode
		--                                                            / \
		LCLK, LCLKn	       : inout  std_logic;                     -- Out
		-------------------------------------------------------------
		----------------- Local-to-PCI Dataflow ---------------------
		-------------------------------------------------------------
		-- Transmitter Source Synchronous Clock.
		--
		L2P_CLKp, L2P_CLKn : inout  std_logic;                     -- In  
		-------------------------------------------------------------
		-- L2P DDR Link
		--
		L2P_DATA           : inout  std_logic_vector(15 downto 0); -- In  -- Parallel Transmit Data.
		L2P_DFRAME         : inout  std_logic;                     -- In  -- Transmit Data Frame.
		L2P_VALID          : inout  std_logic;                     -- In  -- Transmit Data Valid. 
		L2P_EDB            : inout  std_logic;                     -- In  -- End-of-Packet Bad Flag.
		-------------------------------------------------------------
		-- L2P SDR Controls
		--
		L_WR_RDY           : inout  std_logic_vector( 1 downto 0); -- Out -- Local-to-PCIe Write.
		P_RD_D_RDY         : inout  std_logic_vector( 1 downto 0); -- Out -- PCIe-to-Local Read Response Data Ready.
		L2P_RDY            : inout  std_logic;                     -- Out -- Tx Buffer Full Flag.
		TX_ERROR           : inout  std_logic;                     -- Out -- Transmit Error.
		-------------------------------------------------------------
		----------------- PCIe-to-Local Dataflow ---------------------
		-------------------------------------------------------------
		-- Transmitter Source Synchronous Clock.
		--
		P2L_CLKp, P2L_CLKn : inout  std_logic;                     -- Out -- P2L Source Synchronous Clock.
		-------------------------------------------------------------
		-- P2L DDR Link
		--
		P2L_DATA           : inout  std_logic_vector(15 downto 0); -- Out -- Parallel Receive Data.
		P2L_DFRAME         : inout  std_logic;                     -- Out -- Receive Frame.
		P2L_VALID          : inout  std_logic;                     -- Out -- Receive Data Valid.
		-------------------------------------------------------------
		-- P2L SDR Controls
		--
		P2L_RDY	           : inout  std_logic;                     -- In  -- Rx Buffer Full Flag.
		P_WR_REQ           : inout  std_logic_vector( 1 downto 0); -- Out -- PCIe Write Request.
		P_WR_RDY           : inout  std_logic_vector( 1 downto 0); -- In  -- PCIe Write Ready.
		RX_ERROR           : inout  std_logic;                     -- In  -- Receive Error.
		VC_RDY             : inout  std_logic_vector( 1 downto 0); -- Out -- Virtual Channel Ready Status.
		-------------------------------------------------------------
		-- GPIO signals
		--
		GPIO               : inout  std_logic_vector(15 downto 0)
	);
end component; --GN412X_BFM;

-----------------------------------------------------------------------------
-- CMD_ROUTER component
-----------------------------------------------------------------------------
component cmd_router
	generic( N_BFM      : integer := 8;
	         N_FILES    : integer := 3;
	         FIFO_DEPTH : integer := 8;
	         STRING_MAX : integer := 256
	       );
	port( CMD                : out    string(1 to STRING_MAX);
	      CMD_REQ            : out    bit_vector(N_BFM-1 downto 0);
	      CMD_ACK            : in     bit_vector(N_BFM-1 downto 0);
	      CMD_ERR            : in     bit_vector(N_BFM-1 downto 0);
	      CMD_CLOCK_EN       : out    boolean
	    );
end component; --cmd_router;

-----------------------------------------------------------------------------
-- CMD_ROUTER component
-----------------------------------------------------------------------------
component simple
    port(
	    clk             : in    std_logic;
	    d               : in    std_logic_vector(15 downto 0);
	    q               : out   std_logic_vector(15 downto 0)
    );
end component;

-----------------------------------------------------------------------------
-- The lambo design
-----------------------------------------------------------------------------
component lambo
	generic
	(
		TAR_ADDR_WDTH  : integer := 13
	);
	port
	(
	    -- From ASIC Local bus
	    l_clkp                 : in     std_logic;                     -- Running at 200 Mhz
	    l_clkn                 : in     std_logic;                     -- Running at 200 Mhz

	    l_rst_n                : in     std_logic;
	    l_rst33_n              : in     std_logic;

	    sys_clkb               : in     std_logic;                     -- Running at 161 Mhz (for the SDRAM)
	    sys_clk                : in     std_logic;                     -- Running at 161 Mhz (for the SDRAM)
	    reset_in_n             : in     std_logic;

	    -- General Purpose Interface
	    gpio                   : inout  std_logic_vector(15 downto 0); -- General Purpose Input/Output

	    -- PCIe to Local [Inbound Data] - RX
	    p2l_rdy                : out    std_logic;                     -- Rx Buffer Full Flag
	    p2l_clkn               : in     std_logic;                     -- Receiver Source Synchronous Clock-
	    p2l_clkp               : in     std_logic;                     -- Receiver Source Synchronous Clock+
	    p2l_data               : in     std_logic_vector(15 downto 0); -- Parallel receive data
	    p2l_dframe             : in     std_logic;                     -- Receive Frame
	    p2l_valid              : in     std_logic;                     -- Receive Data Valid

	    -- Inbound Buffer Request/Status
	    p_wr_req               : in     std_logic_vector(1 downto 0);  -- PCIe Write Request
	    p_wr_rdy               : out    std_logic_vector(1 downto 0);  -- PCIe Write Ready
	    rx_error               : out    std_logic;                     -- Receive Error

	    -- Local to Parallel [Outbound Data] - TX
	    l2p_data               : out    std_logic_vector(15 downto 0); -- Parallel transmit data 
	    l2p_dframe             : out    std_logic;                     -- Transmit Data Frame
	    l2p_valid              : out    std_logic;                     -- Transmit Data Valid
	    l2p_clkn               : out    std_logic;                     -- Transmitter Source Synchronous Clock-
	    l2p_clkp               : out    std_logic;                     -- Transmitter Source Synchronous Clock+
	    l2p_edb                : out    std_logic;                     -- Packet termination and discard

	    -- Outbound Buffer Status
	    l2p_rdy                : in     std_logic;                     -- Tx Buffer Full Flag
	    l_wr_rdy               : in     std_logic_vector(1 downto 0);  -- Local-to-PCIe Write
	    p_rd_d_rdy             : in     std_logic_vector(1 downto 0);  -- PCIe-to-Local Read Response Data Ready
	    tx_error               : in     std_logic;                     -- Transmit Error
	    vc_rdy                 : in     std_logic_vector(1 downto 0);  -- Channel ready

	    -- DDR2 SDRAM Interface
	    cntrl0_ddr2_dq         : inout  std_logic_vector(31 downto 0);
	    cntrl0_ddr2_a          : out    std_logic_vector(12 downto 0);
	    cntrl0_ddr2_ba         : out    std_logic_vector( 1 downto 0);
	    cntrl0_ddr2_cke        : out    std_logic;
	    cntrl0_ddr2_cs_n       : out    std_logic;
	    cntrl0_ddr2_ras_n      : out    std_logic;
	    cntrl0_ddr2_cas_n      : out    std_logic;
	    cntrl0_ddr2_we_n       : out    std_logic;
	    cntrl0_ddr2_odt        : out    std_logic;
	    cntrl0_ddr2_dm         : out    std_logic_vector(3 downto 0);
	    cntrl0_rst_dqs_div_in  : in     std_logic;
	    cntrl0_rst_dqs_div_out : out    std_logic;
	    cntrl0_ddr2_dqs        : inout  std_logic_vector(3 downto 0);
	    cntrl0_ddr2_dqs_n      : inout  std_logic_vector(3 downto 0);
	    cntrl0_ddr2_ck         : out    std_logic_vector(1 downto 0);
	    cntrl0_ddr2_ck_n       : out    std_logic_vector(1 downto 0);

	    mic_clka               : out    std_logic;
	    mic_clkb               : out    std_logic;
	    mic_data               : out    std_logic_vector(31 downto 0);

	    -- GN1559 related
	    ser                    : out    std_logic_vector(19 downto 0);
	    ser_h                  : out    std_logic;
	    ser_v                  : out    std_logic;
	    ser_f                  : out    std_logic;
	    ser_smpte_bypass       : out    std_logic;
	    ser_dvb_asi            : out    std_logic;
	    ser_sdhdn              : out    std_logic;

	    -- GN1531 de-serializer
	    des                    : in     std_logic_vector(19 downto 0);
	    des_pclk               : in     std_logic;
	    des_h                  : in     std_logic;
	    des_v                  : in     std_logic;
	    des_f                  : in     std_logic;
	    des_smpte_bypass       : inout  std_logic;
	    des_dvb_asi            : inout  std_logic;
	    des_sdhdn              : inout  std_logic;

	    -- GN4911 Timing Generator
	    syncseperator_h_timing : in     std_logic;
	    syncseperator_v_timing : in     std_logic;
	    syncseperator_f_timing : in     std_logic;

	    -- I2C
	    sda                    : inout  std_logic;
	    scl                    : in     std_logic;

	    -- Debug Switches
	    debug                  : in     std_logic_vector(7 downto 0);
	    led                    : out    std_logic_vector(7 downto 0);

	    -- SPI
	    spi_sck                : in     std_logic;
	    spi_ss                 : in     std_logic_vector(4 downto 0);
	    spi_mosi               : in     std_logic;
	    spi_miso               : out    std_logic;

	    pclk_4911_1531         : in     std_logic;  -- requested by Jared      
	    gs4911_host_b          : out    std_logic;
	    gs4911_sclk            : out    std_logic;
	    gs4911_sdin            : out    std_logic;
	    gs4911_sdout           : in     std_logic;
	    gs4911_csb             : out    std_logic;
	    gs4911_lock_lost       : in     std_logic;  -- requested by Jared
	    gs4911_ref_lost        : in     std_logic   -- requested by Jared
	);
end component; --lambo;

--###########################################################################
--###########################################################################
--##
--## Constants
--##
--###########################################################################
--###########################################################################
	--
	-- Number of Models receiving commands
	constant N_BFM      : integer := 2; -- 0 : GN412X_BFM in Model Mode
	--                                  -- 1 : GN412X_BFM in DUT mode
	-- Number of files to feed BFMs
	constant N_FILES    : integer := 2; 
	--
	-- Depth of the command FIFO for each model
	constant FIFO_DEPTH : integer := 16;
	--
	-- Maximum width of a command string
	constant STRING_MAX : integer := 256;
	--

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
	signal  CMD          : STRING(1 to STRING_MAX);
	signal  CMD_REQ      : BIT_VECTOR(N_BFM-1 downto 0);
	signal  CMD_ACK      : BIT_VECTOR(N_BFM-1 downto 0);
	signal  CMD_ERR      : BIT_VECTOR(N_BFM-1 downto 0);
	signal  CMD_CLOCK_EN : boolean;

-----------------------------------------------------------------------------
-- GN412x BFM Signals
-----------------------------------------------------------------------------
	signal  RSTINn             : std_logic;
	signal  RSTOUT18n          : std_logic;
	signal  RSTOUT33n          : std_logic;
	signal  LCLK, LCLKn	       : std_logic;
	signal  L2P_CLKp, L2P_CLKn : std_logic;
	signal  L2P_DATA           : std_logic_vector(15 downto 0);
	signal  L2P_DATA_32        : std_logic_vector(31 downto 0); -- For monitoring use
	signal  L2P_DFRAME         : std_logic;
	signal  L2P_VALID          : std_logic;
	signal  L2P_EDB            : std_logic;
	signal  L_WR_RDY           : std_logic_vector( 1 downto 0);
	signal  P_RD_D_RDY         : std_logic_vector( 1 downto 0);
	signal  L2P_RDY            : std_logic;
	signal  TX_ERROR           : std_logic;
	signal  P2L_CLKp, P2L_CLKn : std_logic;
	signal  P2L_DATA           : std_logic_vector(15 downto 0);
	signal  P2L_DATA_32        : std_logic_vector(31 downto 0); -- For monitoring use
	signal  P2L_DFRAME         : std_logic;
	signal  P2L_VALID          : std_logic;
	signal  P2L_RDY	           : std_logic;
	signal  P_WR_REQ           : std_logic_vector( 1 downto 0);
	signal  P_WR_RDY           : std_logic_vector( 1 downto 0);
	signal  RX_ERROR           : std_logic;
	signal  VC_RDY             : std_logic_vector( 1 downto 0);
-----------------------------------------------------------------------------
-- Unused Signals
-----------------------------------------------------------------------------
	signal  GPIO               : std_logic_vector(15 downto 0);

-- Lambo
	    -- DDR2 SDRAM Interface
	signal  cntrl0_ddr2_dq         : std_logic_vector(31 downto 0);
	signal  cntrl0_ddr2_a          : std_logic_vector(12 downto 0);
	signal  cntrl0_ddr2_ba         : std_logic_vector( 1 downto 0);
	signal  cntrl0_ddr2_cke        : std_logic;
	signal  cntrl0_ddr2_cs_n       : std_logic;
	signal  cntrl0_ddr2_ras_n      : std_logic;
	signal  cntrl0_ddr2_cas_n      : std_logic;
	signal  cntrl0_ddr2_we_n       : std_logic;
	signal  cntrl0_ddr2_odt        : std_logic;
	signal  cntrl0_ddr2_dm         : std_logic_vector(3 downto 0);
	signal  cntrl0_rst_dqs_div_in  : std_logic;
	signal  cntrl0_rst_dqs_div_out : std_logic;
	signal  cntrl0_ddr2_dqs        : std_logic_vector(3 downto 0);
	signal  cntrl0_ddr2_dqs_n      : std_logic_vector(3 downto 0);
	signal  cntrl0_ddr2_ck         : std_logic_vector(1 downto 0);
	signal  cntrl0_ddr2_ck_n       : std_logic_vector(1 downto 0);

	signal  mic_clka               : std_logic;
	signal  mic_clkb               : std_logic;
	signal  mic_data               : std_logic_vector(31 downto 0);

	    -- GN1559 related
	signal  ser                    : std_logic_vector(19 downto 0);
	signal  ser_h                  : std_logic;
	signal  ser_v                  : std_logic;
	signal  ser_f                  : std_logic;
	signal  ser_smpte_bypass       : std_logic;
	signal  ser_dvb_asi            : std_logic;
	signal  ser_sdhdn              : std_logic;

	    -- GN1531 de-serializer
	signal  des                    : std_logic_vector(19 downto 0);
	signal  des_pclk               : std_logic;
	signal  des_h                  : std_logic;
	signal  des_v                  : std_logic;
	signal  des_f                  : std_logic;
	signal  des_smpte_bypass       : std_logic;
	signal  des_dvb_asi            : std_logic;
	signal  des_sdhdn              : std_logic;

	    -- GN4911 Timing Generator
	signal  syncseperator_h_timing : std_logic;
	signal  syncseperator_v_timing : std_logic;
	signal  syncseperator_f_timing : std_logic;

	    -- I2C
	signal  sda                    : std_logic;
	signal  scl                    : std_logic;

	    -- Debug Switches
	signal  debug                  : std_logic_vector(7 downto 0);
	signal  led                    : std_logic_vector(7 downto 0);

	    -- SPI
	signal  spi_sck                : std_logic;
	signal  spi_ss                 : std_logic_vector(4 downto 0);
	signal  spi_mosi               : std_logic;
	signal  spi_miso               : std_logic;

	signal  pclk_4911_1531         : std_logic;  -- requested by Jared      
	signal  gs4911_host_b          : std_logic;
	signal  gs4911_sclk            : std_logic;
	signal  gs4911_sdin            : std_logic;
	signal  gs4911_sdout           : std_logic;
	signal  gs4911_csb             : std_logic;
	signal  gs4911_lock_lost       : std_logic;  -- requested by Jared
	signal  gs4911_ref_lost        : std_logic;  -- requested by Jared


-----------------------------------------------------------------------------
-- Bus Monitor Signals
-----------------------------------------------------------------------------
	signal  Q_P2L_DFRAME       : std_logic;

	signal  SIMPLE_TEST        : std_logic_vector(15 downto 0);

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
	    ( N_BFM      => N_BFM,
	      N_FILES    => N_FILES,
	      FIFO_DEPTH => FIFO_DEPTH, 
	      STRING_MAX => STRING_MAX
	    )
	port map
	    ( CMD           => CMD, 
	      CMD_REQ       => CMD_REQ, 
	      CMD_ACK       => CMD_ACK, 
	      CMD_ERR       => CMD_ERR, 
	      CMD_CLOCK_EN  => CMD_CLOCK_EN
	    );

-----------------------------------------------------------------------------
-- GN412x BFM - PRIMARY
-----------------------------------------------------------------------------

	U0 : gn412x_bfm
	generic map
	(
		STRING_MAX     => STRING_MAX,
		T_LCLK         => 10 ns,
		T_P2L_CLK_DLY  => 2  ns,
		INSTANCE_LABEL => "U0(Primary GN412x): ",
		MODE_PRIMARY   => TRUE
	)
	port map
	(
		--=========================================================--
		-------------------------------------------------------------
		-- CMD_ROUTER Interface
		--
	    CMD           => CMD, 
	    CMD_REQ       => CMD_REQ(0), 
	    CMD_ACK       => CMD_ACK(0), 
	    CMD_CLOCK_EN  => CMD_CLOCK_EN,
		--=========================================================--
		-------------------------------------------------------------
		-- GN412x Signal I/O
		-------------------------------------------------------------
		-- This is the reset input to the BFM
		--
		RSTINn        => RSTINn,
		-------------------------------------------------------------
		-- Reset outputs to DUT
		--
		RSTOUT18n     => RSTOUT18n,
		RSTOUT33n     => RSTOUT33n,
		-------------------------------------------------------------
		----------------- Local Bus Clock ---------------------------
		------------------------------------------------------------- 
		--
		LCLK          => LCLK,
		LCLKn         => LCLKn,
		-------------------------------------------------------------
		----------------- Local-to-PCI Dataflow ---------------------
		-------------------------------------------------------------
		-- Transmitter Source Synchronous Clock.
		--
		L2P_CLKp      => L2P_CLKp,
		L2P_CLKn      => L2P_CLKn,
		-------------------------------------------------------------
		-- L2P DDR Link
		--
		L2P_DATA      => L2P_DATA,
		L2P_DFRAME    => L2P_DFRAME,
		L2P_VALID     => L2P_VALID,
		L2P_EDB       => L2P_EDB,
		-------------------------------------------------------------
		-- L2P SDR Controls
		--
		L_WR_RDY      => L_WR_RDY,
		P_RD_D_RDY    => P_RD_D_RDY,
		L2P_RDY       => L2P_RDY,
		TX_ERROR      => TX_ERROR,
		-------------------------------------------------------------
		----------------- PCIe-to-Local Dataflow ---------------------
		-------------------------------------------------------------
		-- Transmitter Source Synchronous Clock.
		--
		P2L_CLKp      => P2L_CLKp,
		P2L_CLKn      => P2L_CLKn,
		-------------------------------------------------------------
		-- P2L DDR Link
		--
		P2L_DATA      => P2L_DATA,
		P2L_DFRAME    => P2L_DFRAME,
		P2L_VALID     => P2L_VALID,
		-------------------------------------------------------------
		-- P2L SDR Controls
		--
		P2L_RDY       => P2L_RDY,
		P_WR_REQ      => P_WR_REQ,
		P_WR_RDY      => P_WR_RDY,
		RX_ERROR      => RX_ERROR,
		VC_RDY        => VC_RDY,
		GPIO          => gpio
	); -- GN412X_BFM;


-----------------------------------------------------------------------------
-- Lambo FPGA IP
-----------------------------------------------------------------------------

	U1 : lambo
	port map
	(
	    -- From ASIC Local bus
	    l_clkp                 => LCLK,              -- Running at 200 Mhz
	    l_clkn                 => LCLKn,             -- Running at 200 Mhz

	    l_rst_n                => RSTOUT18n,
	    l_rst33_n              => RSTOUT33n,

	    sys_clkb               => '1',               -- Running at 161 Mhz (for the SDRAM)
	    sys_clk                => '0',               -- Running at 161 Mhz (for the SDRAM)
	    reset_in_n             => RSTOUT18n,

	    -- General Purpose Interface
	    gpio                   => GPIO, -- General Purpose Input/Output

	    -- PCIe to Local [Inbound Data] - RX
	    p2l_rdy                => P2L_RDY,            -- Rx Buffer Full Flag
	    p2l_clkn               => P2L_CLKn,           -- Receiver Source Synchronous Clock-
	    p2l_clkp               => P2L_CLKp,           -- Receiver Source Synchronous Clock+
	    p2l_data               => P2L_DATA,           -- Parallel receive data
	    p2l_dframe             => P2L_DFRAME,         -- Receive Frame
	    p2l_valid              => P2L_VALID,          -- Receive Data Valid

	    -- Inbound Buffer Request/Status
	    p_wr_req               => P_WR_REQ,           -- PCIe Write Request
	    p_wr_rdy               => P_WR_RDY,           -- PCIe Write Ready
	    rx_error               => RX_ERROR,           -- Receive Error

	    -- Local to Parallel [Outbound Data] - TX
	    l2p_data               => L2P_DATA,           -- Parallel transmit data 
	    l2p_dframe             => L2P_DFRAME,         -- Transmit Data Frame
	    l2p_valid              => L2P_VALID,          -- Transmit Data Valid
	    l2p_clkn               => L2P_CLKn,           -- Transmitter Source Synchronous Clock-
	    l2p_clkp               => L2P_CLKp,           -- Transmitter Source Synchronous Clock+
	    l2p_edb                => L2P_EDB,            -- Packet termination and discard

	    -- Outbound Buffer Status
	    l2p_rdy                => L2P_RDY,            -- Tx Buffer Full Flag
	    l_wr_rdy               => L_WR_RDY,           -- Local-to-PCIe Write
	    p_rd_d_rdy             => P_RD_D_RDY,         -- PCIe-to-Local Read Response Data Ready
	    tx_error               => TX_ERROR,           -- Transmit Error
	    vc_rdy                 => VC_RDY,             -- Channel ready

	    -- DDR2 SDRAM Interface
	    cntrl0_ddr2_dq         => cntrl0_ddr2_dq,
	    cntrl0_ddr2_a          => cntrl0_ddr2_a,
	    cntrl0_ddr2_ba         => cntrl0_ddr2_ba,
	    cntrl0_ddr2_cke        => cntrl0_ddr2_cke,
	    cntrl0_ddr2_cs_n       => cntrl0_ddr2_cs_n,
	    cntrl0_ddr2_ras_n      => cntrl0_ddr2_ras_n,
	    cntrl0_ddr2_cas_n      => cntrl0_ddr2_cas_n,
	    cntrl0_ddr2_we_n       => cntrl0_ddr2_we_n,
	    cntrl0_ddr2_odt        => cntrl0_ddr2_odt,
	    cntrl0_ddr2_dm         => cntrl0_ddr2_dm,
	    cntrl0_rst_dqs_div_in  => cntrl0_rst_dqs_div_in,
	    cntrl0_rst_dqs_div_out => cntrl0_rst_dqs_div_out,
	    cntrl0_ddr2_dqs        => cntrl0_ddr2_dqs,
	    cntrl0_ddr2_dqs_n      => cntrl0_ddr2_dqs_n,
	    cntrl0_ddr2_ck         => cntrl0_ddr2_ck,
	    cntrl0_ddr2_ck_n       => cntrl0_ddr2_ck_n,

	    mic_clka               => mic_clka,
	    mic_clkb               => mic_clkb,
	    mic_data               => mic_data,

	    -- GN1559 related
	    ser                    => ser,
	    ser_h                  => ser_h,
	    ser_v                  => ser_v,
	    ser_f                  => ser_f,
	    ser_smpte_bypass       => ser_smpte_bypass,
	    ser_dvb_asi            => ser_dvb_asi,
	    ser_sdhdn              => ser_sdhdn,

	    -- GN1531 de-serializer
	    des                    => des,
	    des_pclk               => des_pclk,
	    des_h                  => des_h,
	    des_v                  => des_v,
	    des_f                  => des_f,
	    des_smpte_bypass       => des_smpte_bypass,
	    des_dvb_asi            => des_dvb_asi,
	    des_sdhdn              => des_sdhdn,

	    -- GN4911 Timing Generator
	    syncseperator_h_timing => syncseperator_h_timing,
	    syncseperator_v_timing => syncseperator_v_timing,
	    syncseperator_f_timing => syncseperator_f_timing,

	    -- I2C
	    sda                    => sda,
	    scl                    => scl,

	    -- Debug Switches
	    debug                  => debug,
	    led                    => led,

	    -- SPI
	    spi_sck                => spi_sck,
	    spi_ss                 => spi_ss,
	    spi_mosi               => spi_mosi,
	    spi_miso               => spi_miso,

	    pclk_4911_1531         => pclk_4911_1531,
	    gs4911_host_b          => gs4911_host_b,
	    gs4911_sclk            => gs4911_sclk,
	    gs4911_sdin            => gs4911_sdin,
	    gs4911_sdout           => gs4911_sdout,
	    gs4911_csb             => gs4911_csb,
	    gs4911_lock_lost       => gs4911_lock_lost,
	    gs4911_ref_lost        => gs4911_ref_lost
	);


	process
		variable  vP2L_DATA_LOW     : std_logic_vector(P2L_DATA'range);
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

end TEST;

