--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- FMC ADC 100Ms/s core
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: fmc_adc_100Ms_core (fmc_adc_100Ms_core.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 28-02-2011
--
-- version: 1.0
--
-- description: FMC ADC 100Ms/s core.
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


entity fmc_adc_100Ms_core is
  generic();
  port
    (
      -- Clock, reset
      sys_clk_i   : std_logic;
      sys_rst_n_i : std_logic;

      -- CSR wishbone interface
      wb_csr_clk_i : in  std_logic;
      wb_csr_adr_i : in  std_logic_vector(4 downto 0);
      wb_csr_dat_i : in  std_logic_vector(31 downto 0);
      wb_csr_dat_o : out std_logic_vector(31 downto 0);
      wb_csr_cyc_i : in  std_logic;
      wb_csr_sel_i : in  std_logic_vector(3 downto 0);
      wb_csr_stb_i : in  std_logic;
      wb_csr_we_i  : in  std_logic;
      wb_csr_ack_o : out std_logic;

      -- DMA wishbone interface
      wb_dma_clk_i   : in  std_logic;
      wb_dma_adr_o   : out std_logic_vector(31 downto 0);
      wb_dma_dat_o   : out std_logic_vector(31 downto 0);
      wb_dma_sel_o   : out std_logic_vector(3 downto 0);
      wb_dma_stb_o   : out std_logic;
      wb_dma_we_o    : out std_logic;
      wb_dma_cyc_o   : out std_logic;
      wb_dma_dat_i   : in  std_logic_vector(31 downto 0);
      wb_dma_ack_i   : in  std_logic;
      wb_dma_stall_i : in  std_logic;

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
      gpio_si750_oe_o    : out std_logic                      -- Si750 (programmable oscillator) output enable
      );
end fmc_adc_100Ms_core;


architecture rtl of fmc_adc_100Ms_core is


  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------

  component adc_serdes
    generic
      (
        sys_w : integer := 9;                 -- width of the data for the system
        dev_w : integer := 72                 -- width of the data for the device
        );
    port
      (
        -- Datapath
        DATA_IN_FROM_PINS_P : in  std_logic_vector(sys_w-1 downto 0);
        DATA_IN_FROM_PINS_N : in  std_logic_vector(sys_w-1 downto 0);
        DATA_IN_TO_DEVICE   : out std_logic_vector(dev_w-1 downto 0);
        -- Data control
        BITSLIP             : in  std_logic;
        -- Clock and reset signals
        CLK_IN              : in  std_logic;  -- Fast clock from PLL/MMCM
        CLK_DIV_IN          : in  std_logic;  -- Slow clock from PLL/MMCM
        LOCKED_IN           : in  std_logic;
        LOCKED_OUT          : out std_logic;
        CLK_RESET           : in  std_logic;  -- Reset signal for Clock circuit
        IO_RESET            : in  std_logic   -- Reset signal for IO circuit
        );
  end component adc_serdes;

  component fmc_adc_100Ms_csr
    port (
      rst_n_i                                : in  std_logic;
      wb_clk_i                               : in  std_logic;
      wb_addr_i                              : in  std_logic_vector(4 downto 0);
      wb_data_i                              : in  std_logic_vector(31 downto 0);
      wb_data_o                              : out std_logic_vector(31 downto 0);
      wb_cyc_i                               : in  std_logic;
      wb_sel_i                               : in  std_logic_vector(3 downto 0);
      wb_stb_i                               : in  std_logic;
      wb_we_i                                : in  std_logic;
      wb_ack_o                               : out std_logic;
      fs_clk_i                               : in  std_logic;
      fmc_adc_core_ctl_fsm_cmd_o             : out std_logic_vector(1 downto 0);
      fmc_adc_core_ctl_fsm_cmd_wr_o          : out std_logic;
      fmc_adc_core_ctl_fmc_clk_oe_o          : out std_logic;
      fmc_adc_core_ctl_offset_dac_clr_n_o    : out std_logic;
      fmc_adc_core_sta_fsm_i                 : in  std_logic_vector(2 downto 0);
      fmc_adc_core_sta_serdes_pll_i          : in  std_logic;
      fmc_adc_core_sta_serdes_synced_i       : in  std_logic;
      fmc_adc_core_trig_cfg_hw_trig_sel_o    : out std_logic;
      fmc_adc_core_trig_cfg_ext_trig_pol_o   : out std_logic;
      fmc_adc_core_trig_cfg_hw_trig_en_o     : out std_logic;
      fmc_adc_core_trig_cfg_sw_trig_en_o     : out std_logic;
      fmc_adc_core_trig_cfg_int_trig_sel_o   : out std_logic_vector(1 downto 0);
      fmc_adc_core_trig_cfg_dummy_o          : out std_logic_vector(9 downto 0);
      fmc_adc_core_trig_cfg_int_trig_thres_o : out std_logic_vector(15 downto 0);
      fmc_adc_core_trig_dly_o                : out std_logic_vector(31 downto 0);
      fmc_adc_core_sw_trig_o                 : out std_logic_vector(31 downto 0);
      fmc_adc_core_sw_trig_wr_o              : out std_logic;
      fmc_adc_core_shots_nb_o                : out std_logic_vector(15 downto 0);
      fmc_adc_core_trig_utc_l_i              : in  std_logic_vector(31 downto 0);
      fmc_adc_core_trig_utc_h_i              : in  std_logic_vector(31 downto 0);
      fmc_adc_core_start_utc_l_i             : in  std_logic_vector(31 downto 0);
      fmc_adc_core_start_utc_h_i             : in  std_logic_vector(31 downto 0);
      fmc_adc_core_stop_utc_l_i              : in  std_logic_vector(31 downto 0);
      fmc_adc_core_stop_utc_h_i              : in  std_logic_vector(31 downto 0);
      fmc_adc_core_sr_deci_o                 : out std_logic_vector(15 downto 0);
      fmc_adc_core_pre_samples_o             : out std_logic_vector(31 downto 0);
      fmc_adc_core_post_samples_o            : out std_logic_vector(31 downto 0);
      fmc_adc_core_samp_cnt_i                : in  std_logic_vector(31 downto 0);
      fmc_adc_core_ch1_ssr_o                 : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch1_val_i                 : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch2_ssr_o                 : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch2_val_i                 : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch3_ssr_o                 : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch3_val_i                 : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch4_ssr_o                 : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch4_val_i                 : in  std_logic_vector(15 downto 0)
      );
  end component fmc_adc_100Ms_csr;

  component ext_pulse_sync
    generic(
      g_MIN_PULSE_WIDTH : natural   := 2;      --! Minimum input pulse width
                                               --! (in ns), must be >1 clk_i tick
      g_CLK_FREQUENCY   : natural   := 40;     --! clk_i frequency (in MHz)
      g_OUTPUT_POLARITY : std_logic := '1';    --! pulse_o polarity
                                               --! (1=negative, 0=positive)
      g_OUTPUT_RETRIG   : boolean   := false;  --! Retriggerable output monostable
      g_OUTPUT_LENGTH   : natural   := 1       --! pulse_o lenght (in clk_i ticks)
      );
    port (
      rst_n_i          : in  std_logic;        --! Reset (active low)
      clk_i            : in  std_logic;        --! Clock to synchronize pulse
      input_polarity_i : in  std_logic;        --! Input pulse polarity (1=negative, 0=positive)
      pulse_i          : in  std_logic;        --! Asynchronous input pulse
      pulse_o          : out std_logic         --! Synchronized output pulse
      );
  end component ext_pulse_sync;

  component adc_sync_fifo
    port (
      rst    : in  std_logic;
      wr_clk : in  std_logic;
      rd_clk : in  std_logic;
      din    : in  std_logic_vector(64 downto 0);
      wr_en  : in  std_logic;
      rd_en  : in  std_logic;
      dout   : out std_logic_vector(64 downto 0);
      full   : out std_logic;
      empty  : out std_logic;
      valid  : out std_logic
      );
  end component adc_sync_fifo;

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Types declaration
  ------------------------------------------------------------------------------
  type t_acq_fsm_state is (IDLE, PRE_TRIG, WAIT_TRIG, POST_TRIG, DECR_SHOT);

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------

  -- Reset
  signal sys_rst  : std_logic;
  signal fs_rst   : std_logic;
  signal fs_rst_n : std_logic;

  -- Clocks and PLL
  signal dco_clk    : std_logic;
  signal clk_fb     : std_logic;
  signal locked_in  : std_logic;
  signal locked_out : std_logic;
  signal serdes_clk : std_logic;
  signal fs_clk     : std_logic;
  signal fs_clk_buf : std_logic;

  -- SerDes
  signal serdes_in_p     : std_logic_vector(8 downto 0);
  signal serdes_in_n     : std_logic_vector(8 downto 0);
  signal serdes_out_raw  : std_logic_vector(71 downto 0);
  signal serdes_out_data : std_logic_vector(63 downto 0);
  signal serdes_out_fr   : std_logic_vector(7 downto 0);
  signal serdes_bitslip  : std_logic;
  signal serdes_synced   : std_logic;
  signal bitslip_sreg    : std_logic_vector(7 downto 0);

  -- Trigger
  signal ext_trig_a     : std_logic;
  signal ext_trig       : std_logic;
  signal int_trig       : std_logic;
  signal int_trig_sel   : std_logic_vector(1 downto 0);
  signal int_trig_thres : std_logic_vector(15 downto 0);
  signal ext_trig_pol   : std_logic;
  signal hw_trig        : std_logic;
  signal hw_trig_t      : std_logic;
  signal hw_trig_sel    : std_logic;
  signal hw_trig_en     : std_logic;
  signal sw_trig        : std_logic;
  signal sw_trig_t      : std_logic;
  signal sw_trig_en     : std_logic;
  signal trig           : std_logic;
  signal trig_delay     : std_logic_vector(31 downto 0);
  signal trig_delay_cnt : unsigned(31 downto 0);
  signal trig_d         : std_logic;

  -- Sync FIFO
  signal sync_fifo_din   : std_logic_vector(64 downto 0);
  signal sync_fifo_dout  : std_logic_vector(64 downto 0);
  signal sync_fifo_empty : std_logic;
  signal sync_fifo_full  : std_logic;
  signal sync_fifo_wr    : std_logic;
  signal sync_fifo_rd    : std_logic;
  signal sync_fifo_valid : std_logic;

  -- Acquisition FSM
  signal acq_fsm_current_state : t_acq_fsm_state;
  signal acq_fsm_next_state    : t_acq_fsm_state;
  signal fsm_cmd               : std_logic_vector(1 downto 0);
  signal fsm_cmd_wr            : std_logic;
  signal acq_fsm_start         : std_logic;
  signal acq_fsm_stop          : std_logic;
  signal acq_fsm_trig          : std_logic;

begin


  ------------------------------------------------------------------------------
  -- Active high reset
  ------------------------------------------------------------------------------
  sys_rst <= not(sys_rst_n_i);

  ------------------------------------------------------------------------------
  -- ADC data clock buffer
  ------------------------------------------------------------------------------
  cmp_dco_buf : IBUFDS
    generic map (
      DIFF_TERM  => true,               -- Differential termination
      IOSTANDARD => "LVDS_25")
    port map (
      I  => adc_dco_p_i,
      IB => adc_dco_n_i,
      O  => dco_clk
      );

  ------------------------------------------------------------------------------
  -- Clock PLL for SerDes
  -- LTC2174-14 must be configured in 16-bit serialization
  --    dco_clk = 4*fs_clk = 400MHz
  ------------------------------------------------------------------------------
  cmp_serdes_clk_pll : PLL_BASE
    generic map (
      BANDWIDTH          => "OPTIMIZED",
      CLK_FEEDBACK       => "CLKFBOUT",
      COMPENSATION       => "SYSTEM_SYNCHRONOUS",
      DIVCLK_DIVIDE      => 1,
      CLKFBOUT_MULT      => 2,
      CLKFBOUT_PHASE     => 0.000,
      CLKOUT0_DIVIDE     => 1,
      CLKOUT0_PHASE      => 0.000,
      CLKOUT0_DUTY_CYCLE => 0.500,
      CLKOUT1_DIVIDE     => 8,
      CLKOUT1_PHASE      => 0.000,
      CLKOUT1_DUTY_CYCLE => 0.500,
      CLKIN_PERIOD       => 2.5,
      REF_JITTER         => 0.010)
    port map (
      -- Output clocks
      CLKFBOUT => clk_fb,
      CLKOUT0  => serdes_clk,
      CLKOUT1  => fs_clk_buf,
      CLKOUT2  => open,
      CLKOUT3  => open,
      CLKOUT4  => open,
      CLKOUT5  => open,
      -- Status and control signals
      LOCKED   => locked_in,
      RST      => sys_rst,
      -- Input clock control
      CLKFBIN  => clk_fb,
      CLKIN    => dco_clk);

  cmp_fs_clk_buf : BUFG
    port map (
      O => fs_clk,
      I => fs_clk_buf
      );

  ------------------------------------------------------------------------------
  -- ADC data and frame SerDes
  ------------------------------------------------------------------------------
  cmp_adc_serdes : adc_serdes
    port map(
      DATA_IN_FROM_PINS_P => serdes_in_p,
      DATA_IN_FROM_PINS_N => serdes_in_n,
      DATA_IN_TO_DEVICE   => serdes_out_raw,
      BITSLIP             => serdes_bitslip,
      CLK_IN              => serdes_clk,
      CLK_DIV_IN          => fs_clk,
      LOCKED_IN           => locked_in,
      LOCKED_OUT          => locked_out,
      CLK_RESET           => '0',       -- unused
      IO_RESET            => sys_rst
      );

  -- serdes inputs forming
  serdes_in_p <= adc_fr_p_i
                 & adc_outa_p_i(3) & adc_outb_p_i(3)
                 & adc_outa_p_i(2) & adc_outb_p_i(2)
                 & adc_outa_p_i(1) & adc_outb_p_i(1)
                 & adc_outa_p_i(0) & adc_outb_p_i(0);
  serdes_in_n <= adc_fr_n_i
                 & adc_outa_n_i(3) & adc_outb_n_i(3)
                 & adc_outa_n_i(2) & adc_outb_n_i(2)
                 & adc_outa_n_i(1) & adc_outb_n_i(1)
                 & adc_outa_n_i(0) & adc_outb_n_i(0);

  -- serdes outputs re-ordering
  --    out_raw(7:0)   = CH1D12 CH1D10 CH1D8 CH1D6 CH1D4 CH1D2 CH1D0 0   = CH1_B
  --    out_raw(15:8)  = CH1D13 CH1D11 CH1D9 CH1D7 CH1D5 CH1D3 CH1D1 0   = CH1_A
  --    out_raw(23:16) = CH2D12 CH2D10 CH2D8 CH2D6 CH2D4 CH2D2 CH2D0 0   = CH2_B
  --    out_raw(31:24) = CH2D13 CH2D11 CH2D9 CH2D7 CH2D5 CH2D3 CH2D1 0   = CH2_A
  --    out_raw(39:32) = CH3D12 CH3D10 CH3D8 CH3D6 CH3D4 CH3D2 CH3D0 0   = CH3_B
  --    out_raw(47:40) = CH3D13 CH3D11 CH3D9 CH3D7 CH3D5 CH3D3 CH3D1 0   = CH3_A
  --    out_raw(55:48) = CH4D12 CH4D10 CH4D8 CH4D6 CH4D4 CH4D2 CH4D0 0   = CH4_B
  --    out_raw(63:56) = CH4D13 CH4D11 CH4D9 CH4D7 CH4D5 CH4D3 CH4D1 0   = CH4_A
  --    out_raw(71:64) = FR7    FR6    FR5   FR4   FR3   FR2   FR1   FR0 = FR
  --
  --    out_data(15:0)  = CH1
  --    out_data(31:16) = CH2
  --    out_data(47:32) = CH3
  --    out_data(63:48) = CH4
  --    Note: The two LSBs of each channel are always '0' => 14-bit ADC
  gen_serdes_dout_reorder : for I in 0 to 7 generate
    serdes_out_data(0*16 + 2*i)   <= serdes_out_raw(i + 0*8);  -- CH1 even bits
    serdes_out_data(0*16 + 2*i+1) <= serdes_out_raw(i + 1*8);  -- CH1 odd bits
    serdes_out_data(1*16 + 2*i)   <= serdes_out_raw(i + 2*8);  -- CH2 even bits
    serdes_out_data(1*16 + 2*i+1) <= serdes_out_raw(i + 3*8);  -- CH2 odd bits
    serdes_out_data(2*16 + 2*i)   <= serdes_out_raw(i + 4*8);  -- CH3 even bits
    serdes_out_data(2*16 + 2*i+1) <= serdes_out_raw(i + 5*8);  -- CH3 odd bits
    serdes_out_data(3*16 + 2*i)   <= serdes_out_raw(i + 6*8);  -- CH4 even bits
    serdes_out_data(3*16 + 2*i+1) <= serdes_out_raw(i + 7*8);  -- CH4 odd bits
    serdes_out_fr(i)              <= serdes_out_raw(i + 8*8);  -- FR
  end generate gen_serdes_dout_reorder;


  -- serdes bitslip generation
  p_bitslip : process (serdes_clk, sys_rst_n_i)
  begin
    if rising_edge(serdes_clk) then
      if sys_rst_n_i = '0' then
        bitslip_sreg   <= std_logic_vector(to_unsigned(1, bitslip_sreg'length));
        serdes_bitslip <= '0';
        serdes_synced  <= '0';
      else
        -- Shift register to generate bitslip enable (serdes_clk/8)
        bitfsip_sreg <= bitslip_sreg(0) & bitslip_sreg(bitslip_sreg'length-1 downto 1);

        -- Generate bitslip and synced signal
        if(bitslip_sreg(bitslip_sreg'left) = '1') then
          if(serdes_out_fr /= "11110000") then
            serdes_bitslip <= '1';
            serdes_synced  <= '0';
          else
            serdes_bitslip <= '0';
            serdes_synced  <= '1';
          end if;
        else
          serdes_bitslip <= '0';
        end if;

      end if;
    end if;
  end process;

  ------------------------------------------------------------------------------
  -- ADC core control and status registers (CSR)
  ------------------------------------------------------------------------------
  cmp_fmc_adc_100Ms_csr : fmc_adc_100Ms_csr
    port map(
      rst_n_i                                => sys_rst_n_i,
      wb_clk_i                               => wb_csr_clk_i,
      wb_addr_i                              => wb_csr_adr_i,
      wb_data_i                              => wb_csr_dat_i,
      wb_data_o                              => wb_csr_dat_o,
      wb_cyc_i                               => wb_csr_cyc_i,
      wb_sel_i                               => wb_csr_sel_i,
      wb_stb_i                               => wb_csr_stb_i,
      wb_we_i                                => wb_csr_we_i,
      wb_ack_o                               => wb_csr_ack_o,
      fs_clk_i                               => fs_clk,
      fmc_adc_core_ctl_fsm_cmd_o             => fsm_cmd,
      fmc_adc_core_ctl_fsm_cmd_wr_o          => fsm_cmd_wr,
      fmc_adc_core_ctl_fmc_clk_oe_o          => gpio_si750_oe_o,
      fmc_adc_core_ctl_offset_dac_clr_n_o    => gpio_dac_clr_n_o,
      fmc_adc_core_sta_fsm_i                 => "000",
      fmc_adc_core_sta_serdes_pll_i          => locked_out,
      fmc_adc_core_sta_serdes_synced_i       => serdes_synced,
      fmc_adc_core_trig_cfg_hw_trig_sel_o    => hw_trig_sel,
      fmc_adc_core_trig_cfg_ext_trig_pol_o   => ext_trig_pol,
      fmc_adc_core_trig_cfg_hw_trig_en_o     => hw_trig_en,
      fmc_adc_core_trig_cfg_sw_trig_en_o     => sw_trig_en,
      fmc_adc_core_trig_cfg_int_trig_sel_o   => int_trig_sel,
      fmc_adc_core_trig_cfg_dummy_o          => open,
      fmc_adc_core_trig_cfg_int_trig_thres_o => int_trig_thres,
      fmc_adc_core_trig_dly_o                => trig_delay,
      fmc_adc_core_sw_trig_o                 => open,
      fmc_adc_core_sw_trig_wr_o              => sw_trig_t,
      fmc_adc_core_shots_nb_o                => open,
      fmc_adc_core_trig_utc_l_i              => X"00000000",
      fmc_adc_core_trig_utc_h_i              => X"00000000",
      fmc_adc_core_start_utc_l_i             => X"00000000",
      fmc_adc_core_start_utc_h_i             => X"00000000",
      fmc_adc_core_stop_utc_l_i              => X"00000000",
      fmc_adc_core_stop_utc_h_i              => X"00000000",
      fmc_adc_core_sr_deci_o                 => open,
      fmc_adc_core_pre_samples_o             => open,
      fmc_adc_core_post_samples_o            => open,
      fmc_adc_core_samp_cnt_i                => X"00000000",
      fmc_adc_core_ch1_ssr_o                 => gpio_ssr_ch1_o,
      fmc_adc_core_ch1_val_i                 => X"0000",
      fmc_adc_core_ch2_ssr_o                 => gpio_ssr_ch2_o,
      fmc_adc_core_ch2_val_i                 => X"0000",
      fmc_adc_core_ch3_ssr_o                 => gpio_ssr_ch3_o,
      fmc_adc_core_ch3_val_i                 => X"0000",
      fmc_adc_core_ch4_ssr_o                 => gpio_ssr_ch4_o,
      fmc_adc_core_ch4_val_i                 => X"0000"
      );

  ------------------------------------------------------------------------------
  -- Trigger
  ------------------------------------------------------------------------------

  -- External hardware trigger differential to single-ended buffer
  cmp_ext_trig_buf : IBUFDS
    port map (
      O  => ext_trig_a,
      I  => ext_trigger_p_i,
      IB => ext_trigger_n_i
      );

  -- External hardware trigger synchronization
  cmp_trig_sync : ext_pulse_sync
    generic map(
      g_MIN_PULSE_WIDTH => ,            -- clk_i ticks
      g_CLK_FREQUENCY   => 100,         -- MHz
      g_OUTPUT_POLARITY => 0,           -- positive pulse
      g_OUTPUT_RETRIG   => false,
      g_OUTPUT_LENGTH   => 1            -- clk_i tick
      )
    port map(
      rst_n_i          => fs_rst_n,
      clk_i            => fs_clk,
      input_polarity_i => ext_trig_pol,
      pulse_i          => ext_trig_a,
      pulse_o          => ext_trig
      );

  -- Internal hardware trigger
  int_trig <= '0';

  -- Hardware trigger selection
  --    internal = adc data threshold
  --    external = pulse from front panel
  hw_trig_t <= ext_trig when hw_trig_sel = '1' else int_trig;

  -- Hardware trigger enable
  hw_trig <= hw_trig_t and hw_trig_en;

  -- Software trigger enable
  sw_trig <= sw_trig_t and sw_trig_en;

  -- Trigger sources ORing
  trig <= sw_trig or hw_trig;

  -- Trigger delay
  p_trig_delay_cnt : process(fs_clk)
  begin
    if rising_edge(fs_clk) then
      if trig = '1' then
        trig_delay_cnt <= trig_delay;
      elsif trig_delay_cnt = 0 then
        trig_delay_cnt <= trig_delay_cnt - 1;
      end if;
    end if;
  end process p_trig_delay_cnt;

  p_trig_delay : process(fs_clk)
  begin
    if rising_edge(fs_clk) then
      if trig_delay = X"00000000" then
        if trig = '1' then
          trig_d <= '1';
        else
          trig_d <= '0';
        end if;
      else
        if trig_delay_cnt = X"00000001" then
          if trig = '1' then
            trig_d <= '1';
          else
            trig_d <= '0';
          end if;
        end if;
      end if;
    end if;
  end process p_trig_delay;

  ------------------------------------------------------------------------------
  -- Synchronisation FIFO to system clock domain
  ------------------------------------------------------------------------------
  cmp_adc_sync_fifo : adc_sync_fifo
    port (
      rst    => sys_rst,                -- must be at least 3 wr_clk and rd_clk cycles
      wr_clk => fs_clk,
      rd_clk => sys_clk_i,
      din    => sync_fifo_din,
      wr_en  => sync_fifo_wr,
      rd_en  => sync_fifo_rd,
      dout   => sync_fifo_dout,
      full   => sync_fifo_full,
      empty  => sync_fifo_empty,
      valid  => sync_fifo_valid
      );

  sync_fifo_din <= trig_d & serdes_out_data;

  sync_fifo_wr <= serdes_synced and not(sync_fifo_full);
  sync_fifo_rd <= and not(sync_fifo_empty);

  ------------------------------------------------------------------------------
  -- Aqcuisition FSM
  ------------------------------------------------------------------------------

  -- FSM commands
  acq_fsm_start <= '1' when fsm_cmd_wr = '1' and fsm_cmd = "01" else '0';
  acq_fsm_stop  <= '1' when fsm_cmd_wr = '1' and fsm_cmd = "10" else '0';
  acq_fsm_trig  <= sync_fifo_dout(64);

  -- FSM current state register
  p_acq_fsm_state : process (sys_clk_i)
  begin
    if rising_edge(sys_clk_i) then
      if sys_rst_n_i = '0' then
        acq_fsm_current_state <= IDLE;
      else
        acq_fsm_current_state <= acq_fsm_next_state;
      end if;
    end if;
  end process p_acq_fsm_state;

  -- FSM transitions
  p_acq_fsm_transitions : process(acq_fsm_current_state,
                                  acq_fsm_start,
                                  acq_fsm_stop,
                                  acq_fsm_trig)
  begin
    case acq_fsm_current_state is

      when IDLE =>
        if acq_fsm_start = '1' then
          acq_fsm_next_state <= PRE_TRIG;
        end if;

      when PRE_TRIG =>
;

      when WAIT_TRIG =>
;

      when POST_TRIG =>
;

      when DECR_SHOT =>
;

      when others =>
        null;

    end case;
  end process p_acq_fsm_transitions;

  -- FSM outputs
  p_acq_fsm_outputs : process(acq_fsm_current_state)
  begin
    case acq_fsm_current_state is

      when IDLE =>
;

      when PRE_TRIG =>
;

      when WAIT_TRIG =>
;

      when POST_TRIG =>
;

      when DECR_SHOT =>
;

      when others =>
        null;

    end case;
  end process p_acq_fsm_outputs;

end rtl;