--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Top level entity for Simple PCIe FMC Carrier
-- http://www.ohwr.org/projects/spec
--------------------------------------------------------------------------------
--
-- unit name: Top-level for LED control (led_ctrl_top.vhd)
--
-- author: Theodor Stana (t.stana@cern.ch)
--
-- date of creation: 2011-09-14
--
-- version: 1.0
--
-- description: Top entity for LED control project
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.gn4124_core_pkg.all;

--=============================================================================
--  Entity declaration for LED control top-level
--=============================================================================
entity led_ctrl_top is
  port 
  (
    -- Local oscillator
    sys_clk : in std_logic;      -- 20MHz VCXO clock
    
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
    
    -- outputs:
    leds         : out   std_logic_vector(1 downto 0)  
  );
end entity;
--=============================================================================

--=============================================================================
--  Architecture declaration for LED control top-level entity
--=============================================================================
architecture struct of led_ctrl_top is
  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------  
  -- address decoder
  component addr_dec
    port (  
      -- Input signals
      cyc_i : in  std_logic;
      adr_i : in  std_logic;
      dat_i : in  std_logic_vector(63 downto 0);
      ack_i : in  std_logic_vector(1 downto 0);
      
      -- Output signals
      cyc_o : out std_logic_vector(1 downto 0);
      ack_o : out std_logic;
      dat_o : out std_logic_vector(31 downto 0)
    );
  end component;
  
  -- IRQ controller
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
  
  -- LED control slave
  component led_ctrl is
    Port (
      -------------------------------------------------------------------------
      -- WISHBONE SLAVE PORTS
      -------------------------------------------------------------------------
      -- input signals
      clk_i : in  STD_LOGIC;
      rst_i : in  STD_LOGIC;
      
      wb_dat_i : in  std_logic;
      wb_adr_i : in  std_logic;
      wb_stb_i : in  STD_LOGIC;
      wb_we_i  : in  STD_LOGIC;
      wb_cyc_i : in  STD_LOGIC;
      -- output signals
      wb_ack_o : out STD_LOGIC;
	    wb_dat_o : out std_logic;
      
      -------------------------------------------------------------------------
      -- OTHER ENTITY PORTS
      -------------------------------------------------------------------------
      irq_o  : out std_logic_vector(1 downto 0);
      leds_o : out STD_LOGIC_VECTOR (1 downto 0)
    );
  end component led_ctrl;
  
  -- clock divider
  component clk_div is
    port 
    ( 
      clk_i   : in  STD_LOGIC;
      reset_i : in  std_logic;
      clk_o   : out STD_LOGIC
    );
  end component clk_div;
    
  component leds_sm is
    port
    (
      -- global input signals
      clk_i   : in   STD_LOGIC;
      reset_i : in   STD_LOGIC;
      
      -- global output signals
      led1a_o : out  STD_LOGIC; -- LED1A, '1' = on
                                --        '0' = off
      led1b_o : out  STD_LOGIC  -- LED1B, '1' = on
                                --        '0' = off   
    );  
  end component leds_sm;    
  
  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  -- Local signals
  signal s_rst            : std_logic;
  signal l_clk            : std_logic;
  signal s_pps            : std_logic;
  signal s_leds           : std_logic_vector (1 downto 0);
  signal s_leds_mux_sel   : std_logic;
  signal s_leds_mux_in_a  : std_logic_vector (1 downto 0);
  signal s_leds_mux_in_b  : std_logic_vector (1 downto 0);

  -- System clock
  signal sys_clk_125_buf    : std_logic;
  signal sys_clk_250_buf    : std_logic;
  signal sys_clk_125        : std_logic;
  signal sys_clk_250        : std_logic;
  signal sys_clk_fb         : std_logic;
  signal sys_clk_pll_locked : std_logic;
  
  -- Gennum interface signals
  signal s_gennum_cyc_o   : std_logic;
  signal s_gennum_adr_o   : std_logic_vector (31 downto 0);
  signal s_gennum_sel_o   : std_logic_vector(3 downto 0);
  signal s_gennum_dat_i   : std_logic_vector(31 downto 0);
  signal s_gennum_dat_o   : std_logic_vector(31 downto 0);
  signal s_gennum_stb_o   : std_logic;
  signal s_gennum_we_o    : std_logic;
  signal s_gennum_we_o_d1 : std_logic;
  signal s_gennum_we_o_d2 : std_logic;
  signal s_gennum_ack_i   : std_logic;
  
  -- Address decoder signals
  signal s_dec_cyc_o    : std_logic_vector(1 downto 0);
  signal s_dec_ack_i    : std_logic_vector(1 downto 0);
  signal s_dec_dat_i    : std_logic_vector(63 downto 0);
  
  -- IRQ controller signals
  signal s_irq_p : std_logic;
  signal s_leds_irq : std_logic_vector(1 downto 0);
  signal s_irq   : std_logic_vector(31 downto 0);
  
--=============================================================================
--  architecture begin
--=============================================================================
begin

  -----------------------------------------------------------------------------
  -- Input and output logic
  -----------------------------------------------------------------------------
  s_rst <= not L_RST_N;
  leds <= s_leds;
  GPIO(1) <= '0';
  
  -----------------------------------------------------------------------------
  -- Register for WE edge detection and selection
  -----------------------------------------------------------------------------
  p_reg : process (sys_clk, L_RST_N)
  begin
    if rising_edge(sys_clk) then
      if (L_RST_N = '0') then
        s_gennum_we_o_d1        <= '0';
        s_gennum_we_o_d2        <= '0';
        s_leds_mux_sel <= '0';
      else
        s_gennum_we_o_d1 <= s_gennum_we_o;
        s_gennum_we_o_d2 <= s_gennum_we_o_d1;
        if (s_gennum_we_o_d1 = '1') and (s_gennum_we_o_d2 = '0') and (s_dec_cyc_o(1) = '1') then
          s_leds_mux_sel <= '1';
        end if;
      end if;
    end if;
  end process p_reg;
  
  -----------------------------------------------------------------------------
  -- MUX for LED output control
  -----------------------------------------------------------------------------
  s_leds <= s_leds_mux_in_a when s_leds_mux_sel = '0' else
            s_leds_mux_in_b;
  
  -----------------------------------------------------------------------------
  -- Component instantiation
  -----------------------------------------------------------------------------
  -- PLL
  -- cmp_sys_clk_pll : PLL_BASE
    -- generic map (
      -- BANDWIDTH          => "OPTIMIZED",
      -- CLK_FEEDBACK       => "CLKFBOUT",
      -- COMPENSATION       => "INTERNAL",
      -- DIVCLK_DIVIDE      => 1,
      -- CLKFBOUT_MULT      => 50,
      -- CLKFBOUT_PHASE     => 0.000,
      -- CLKOUT0_DIVIDE     => 8,
      -- CLKOUT0_PHASE      => 0.000,
      -- CLKOUT0_DUTY_CYCLE => 0.500,
      -- CLKOUT1_DIVIDE     => 4,
      -- CLKOUT1_PHASE      => 0.000,
      -- CLKOUT1_DUTY_CYCLE => 0.500,
      -- CLKOUT2_DIVIDE     => 3,
      -- CLKOUT2_PHASE      => 0.000,
      -- CLKOUT2_DUTY_CYCLE => 0.500,
      -- CLKIN_PERIOD       => 50.0,
      -- REF_JITTER         => 0.016)
    -- port map (
      -- CLKFBOUT => sys_clk_fb,
      -- CLKOUT0  => sys_clk_125_buf,
      -- CLKOUT1  => sys_clk_250_buf,
      -- CLKOUT2  => open,
      -- CLKOUT3  => open,
      -- CLKOUT4  => open,
      -- CLKOUT5  => open,
      -- LOCKED   => sys_clk_pll_locked,
      -- RST      => '0',
      -- CLKFBIN  => sys_clk_fb,
      -- CLKIN    => sys_clk
    -- );
      
  -- GN4124 core  
  cmp_gn4124_core : gn4124_core
    port map(
      rst_n_a_i       => L_RST_N,
      status_o        => open,
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
      dma_irq_o       => open,
      irq_p_i         => s_irq_p,
      irq_p_o         => GPIO(0),
      -- DMA registers wishbone interface (slave classic)
      dma_reg_clk_i   => '0',
      dma_reg_adr_i   => (others => '0'),
      dma_reg_dat_i   => (others => '0'),
      dma_reg_sel_i   => (others => '0'),
      dma_reg_stb_i   => '0',
      dma_reg_we_i    => '0',
      dma_reg_cyc_i   => '0',
      dma_reg_dat_o   => open,
      dma_reg_ack_o   => open,
      dma_reg_stall_o => open,
      -- CSR wishbone interface (master pipelined)
      csr_clk_i       => sys_clk,
      csr_adr_o       => s_gennum_adr_o,
      csr_dat_o       => s_gennum_dat_o,
      csr_sel_o       => s_gennum_sel_o,
      csr_stb_o       => s_gennum_stb_o,
      csr_we_o        => s_gennum_we_o,
      csr_cyc_o       => s_gennum_cyc_o,
      csr_dat_i       => s_gennum_dat_i,
      csr_ack_i       => s_gennum_ack_i,
      csr_stall_i     => '0',
      -- DMA wishbone interface (pipelined)
      dma_clk_i       => '0',
      dma_adr_o       => open,
      dma_dat_o       => open,
      dma_sel_o       => open,
      dma_stb_o       => open,
      dma_we_o        => open,
      dma_cyc_o       => open,
      dma_dat_i       => (others => '0'),
      dma_ack_i       => '0',
      dma_stall_i     => '0'
      );
      
  -- local clock from Gennum clock
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

  -- Address decoder; address map:
  -- 0x0 : IRQ multi_irq
  -- 0x1 : IRQ src
  -- 0x2 : IRQ en_mask
  -- 0x3 : RESERVED
  -- 0x4 : LED LED1A
  -- 0x5 : LED LED1B
  cmp_addr_dec : addr_dec
    port map (
      adr_i => s_gennum_adr_o(2),
      cyc_i => s_gennum_cyc_o,
      dat_i => s_dec_dat_i,
      ack_i => s_dec_ack_i,
      
      cyc_o => s_dec_cyc_o,
      ack_o => s_gennum_ack_i,
      dat_o => s_gennum_dat_i
    );
  s_dec_dat_i(63 downto 33) <= (others => '0');
  
  -- IRQ controller
  cmp_irq_ctrl: irq_controller
    port map
    (
      clk_i       => sys_clk,
      rst_n_i     => L_RST_N,
      irq_src_p_i => s_irq,
      irq_p_o     => s_irq_p,
      wb_adr_i    => s_gennum_adr_o(1 downto 0),
      wb_dat_i    => s_gennum_dat_o,
      wb_dat_o    => s_dec_dat_i(31 downto 0),
      wb_cyc_i    => s_dec_cyc_o(0),
      wb_sel_i    => s_gennum_sel_o,
      wb_stb_i    => s_gennum_stb_o,
      wb_we_i     => s_gennum_we_o,
      wb_ack_o    => s_dec_ack_i(0)
    );
  
  s_irq(31 downto 2) <= (others => '0');
  s_irq(1 downto 0)  <= s_leds_irq;
  
  -- LED controller
  cmp_led_ctrl: led_ctrl
    port map 
    (
      clk_i    => sys_clk,
      rst_i    => s_rst,
      wb_dat_i => s_gennum_dat_o(0),
      wb_dat_o => s_dec_dat_i(32),
      wb_adr_i => s_gennum_adr_o(0),
      wb_stb_i => s_gennum_stb_o,
      wb_we_i  => s_gennum_we_o,
      wb_cyc_i => s_dec_cyc_o(1),
      wb_ack_o => s_dec_ack_i(1),
      irq_o    => s_leds_irq,
      leds_o   => s_leds_mux_in_b
    );
  
  -- clock divider
  cmp_clk_div : clk_div
    port map
    (
      clk_i   => sys_clk,
      reset_i => s_rst,
      clk_o   => s_pps    
    );
  
  -- LED switcher
  cmp_leds_sm : leds_sm
    port map
    (
      clk_i   => s_pps,
      reset_i => s_rst,
      
      led1a_o => s_leds_mux_in_a(0),
      led1b_o => s_leds_mux_in_a(1)
    );

end architecture;
--=============================================================================
--  architecture end
--=============================================================================



