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
    gpio_si570_oe_o  : out std_logic                      -- Si570 (programmable oscillator) output enable
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
      fmc_adc_core_ctl_man_bitslip_o         : out std_logic;
      fmc_adc_core_ctl_test_data_en_o        : out std_logic;
      fmc_adc_core_ctl_trig_led_o            : out std_logic;
      fmc_adc_core_ctl_acq_led_o             : out std_logic;
      fmc_adc_core_ctl_reserved_o            : out std_logic_vector(23 downto 0);
      fmc_adc_core_sta_fsm_i                 : in  std_logic_vector(2 downto 0);
      fmc_adc_core_sta_serdes_pll_i          : in  std_logic;
      fmc_adc_core_sta_serdes_synced_i       : in  std_logic;
      fmc_adc_core_sta_reserved_i            : in  std_logic_vector(26 downto 0);
      fmc_adc_core_trig_cfg_hw_trig_sel_o    : out std_logic;
      fmc_adc_core_trig_cfg_hw_trig_pol_o    : out std_logic;
      fmc_adc_core_trig_cfg_hw_trig_en_o     : out std_logic;
      fmc_adc_core_trig_cfg_sw_trig_en_o     : out std_logic;
      fmc_adc_core_trig_cfg_int_trig_sel_o   : out std_logic_vector(1 downto 0);
      fmc_adc_core_trig_cfg_reserved_o       : out std_logic_vector(9 downto 0);
      fmc_adc_core_trig_cfg_int_trig_thres_o : out std_logic_vector(15 downto 0);
      fmc_adc_core_trig_dly_o                : out std_logic_vector(31 downto 0);
      fmc_adc_core_sw_trig_o                 : out std_logic_vector(31 downto 0);
      fmc_adc_core_sw_trig_wr_o              : out std_logic;
      fmc_adc_core_shots_nb_o                : out std_logic_vector(15 downto 0);
      fmc_adc_core_shots_reserved_o          : out std_logic_vector(15 downto 0);
      fmc_adc_core_trig_pos_i                : in  std_logic_vector(31 downto 0);
      fmc_adc_core_sr_deci_o                 : out std_logic_vector(15 downto 0);
      fmc_adc_core_sr_reserved_o             : out std_logic_vector(15 downto 0);
      fmc_adc_core_pre_samples_o             : out std_logic_vector(31 downto 0);
      fmc_adc_core_post_samples_o            : out std_logic_vector(31 downto 0);
      fmc_adc_core_samples_cnt_i             : in  std_logic_vector(31 downto 0);
      fmc_adc_core_ch1_ctl_ssr_o             : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch1_ctl_reserved_o        : out std_logic_vector(24 downto 0);
      fmc_adc_core_ch1_sta_val_i             : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch1_sta_reserved_i        : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch1_gain_val_o            : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch1_gain_reserved_o       : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch1_offset_val_o          : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch1_offset_reserved_o     : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch2_ctl_ssr_o             : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch2_ctl_reserved_o        : out std_logic_vector(24 downto 0);
      fmc_adc_core_ch2_sta_val_i             : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch2_sta_reserved_i        : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch2_gain_val_o            : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch2_gain_reserved_o       : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch2_offset_val_o          : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch2_offset_reserved_o     : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch3_ctl_ssr_o             : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch3_ctl_reserved_o        : out std_logic_vector(24 downto 0);
      fmc_adc_core_ch3_sta_val_i             : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch3_sta_reserved_i        : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch3_gain_val_o            : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch3_gain_reserved_o       : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch3_offset_val_o          : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch3_offset_reserved_o     : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch4_ctl_ssr_o             : out std_logic_vector(6 downto 0);
      fmc_adc_core_ch4_ctl_reserved_o        : out std_logic_vector(24 downto 0);
      fmc_adc_core_ch4_sta_val_i             : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch4_sta_reserved_i        : in  std_logic_vector(15 downto 0);
      fmc_adc_core_ch4_gain_val_o            : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch4_gain_reserved_o       : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch4_offset_val_o          : out std_logic_vector(15 downto 0);
      fmc_adc_core_ch4_offset_reserved_o     : out std_logic_vector(15 downto 0)
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

  component offset_gain_s
    port (
      rst_n_i  : in  std_logic;                      --! Reset (active low)
      clk_i    : in  std_logic;                      --! Clock
      offset_i : in  std_logic_vector(15 downto 0);  --! Signed offset input (two's complement)
      gain_i   : in  std_logic_vector(15 downto 0);  --! Unsigned gain input
      data_i   : in  std_logic_vector(15 downto 0);  --! Signed data input (two's complement)
      data_o   : out std_logic_vector(15 downto 0)   --! Signed data output (two's complement)
      );
  end component offset_gain_s;

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

  component wb_ddr_fifo
    port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      din   : in  std_logic_vector(64 downto 0);
      wr_en : in  std_logic;
      rd_en : in  std_logic;
      dout  : out std_logic_vector(64 downto 0);
      full  : out std_logic;
      empty : out std_logic;
      valid : out std_logic);
  end component wb_ddr_fifo;

  component multishot_dpram
    port (
      clka  : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(12 downto 0);
      dina  : in  std_logic_vector(63 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(12 downto 0);
      doutb : out std_logic_vector(63 downto 0));
  end component multishot_dpram;

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
  signal clk_fb_buf : std_logic;
  signal locked_in  : std_logic;
  signal locked_out : std_logic;
  signal serdes_clk : std_logic;
  signal fs_clk     : std_logic;
  signal fs_clk_buf : std_logic;

  -- SerDes
  signal serdes_in_p         : std_logic_vector(8 downto 0);
  signal serdes_in_n         : std_logic_vector(8 downto 0);
  signal serdes_out_raw      : std_logic_vector(71 downto 0);
  signal serdes_out_data     : std_logic_vector(63 downto 0);
  signal serdes_out_data_d   : std_logic_vector(63 downto 0);
  signal serdes_out_fr       : std_logic_vector(7 downto 0);
  signal serdes_auto_bitslip : std_logic;
  signal serdes_man_bitslip  : std_logic;
  signal serdes_bitslip      : std_logic;
  signal serdes_synced       : std_logic;
  signal bitslip_sreg        : std_logic_vector(7 downto 0);

  -- Trigger
  signal ext_trig_a            : std_logic;
  signal ext_trig              : std_logic;
  signal int_trig              : std_logic;
  signal int_trig_over_thres   : std_logic;
  signal int_trig_over_thres_d : std_logic;
  signal int_trig_sel          : std_logic_vector(1 downto 0);
  signal int_trig_data         : std_logic_vector(15 downto 0);
  signal int_trig_thres        : std_logic_vector(15 downto 0);
  signal hw_trig_pol           : std_logic;
  signal hw_trig               : std_logic;
  signal hw_trig_t             : std_logic;
  signal hw_trig_sel           : std_logic;
  signal hw_trig_en            : std_logic;
  signal sw_trig               : std_logic;
  signal sw_trig_t             : std_logic;
  signal sw_trig_en            : std_logic;
  signal trig                  : std_logic;
  signal trig_delay            : std_logic_vector(31 downto 0);
  signal trig_delay_cnt        : unsigned(31 downto 0);
  signal trig_d                : std_logic;
  signal trig_align            : std_logic;

  -- Decimation
  signal decim_factor : std_logic_vector(15 downto 0);
  signal decim_cnt    : unsigned(15 downto 0);
  signal decim_en     : std_logic;

  -- Sync FIFO (from fs_clk to sys_clk_i)
  signal sync_fifo_din   : std_logic_vector(64 downto 0);
  signal sync_fifo_dout  : std_logic_vector(64 downto 0);
  signal sync_fifo_empty : std_logic;
  signal sync_fifo_full  : std_logic;
  signal sync_fifo_wr    : std_logic;
  signal sync_fifo_rd    : std_logic;
  signal sync_fifo_valid : std_logic;
  signal sync_fifo_dreq  : std_logic;

  -- Gain/offset calibration
  signal gain_calibr     : std_logic_vector(63 downto 0);
  signal offset_calibr   : std_logic_vector(63 downto 0);
  signal data_calibr_in  : std_logic_vector(63 downto 0);
  signal data_calibr_out : std_logic_vector(63 downto 0);

  -- Acquisition FSM
  signal acq_fsm_current_state : t_acq_fsm_state;
  signal acq_fsm_state         : std_logic_vector(2 downto 0);
  signal fsm_cmd               : std_logic_vector(1 downto 0);
  signal fsm_cmd_wr            : std_logic;
  signal acq_start             : std_logic;
  signal acq_stop              : std_logic;
  signal acq_trig              : std_logic;
  signal acq_end               : std_logic;
  signal acq_end_d             : std_logic;
  signal acq_in_pre_trig       : std_logic;
  signal acq_in_wait_trig      : std_logic;
  signal acq_in_post_trig      : std_logic;
  signal samples_wr_en         : std_logic;

  -- pre/post trigger and shots counters
  signal pre_trig_value       : std_logic_vector(31 downto 0);
  signal pre_trig_cnt         : unsigned(31 downto 0);
  signal pre_trig_done        : std_logic;
  signal post_trig_value      : std_logic_vector(31 downto 0);
  signal post_trig_cnt        : unsigned(31 downto 0);
  signal post_trig_done       : std_logic;
  signal samples_cnt          : unsigned(31 downto 0);
  signal shots_value          : std_logic_vector(15 downto 0);
  signal shots_cnt            : unsigned(15 downto 0);
  signal shots_done           : std_logic;
  signal shots_decr           : std_logic;
  signal single_shot          : std_logic;
  signal multishot_buffer_sel : std_logic;

  -- Multi-shot mode
  constant c_DPRAM_DEPTH : integer := 13;

  signal dpram_addra_cnt       : unsigned(c_DPRAM_DEPTH-1 downto 0);
  signal dpram_addra_trig      : unsigned(c_DPRAM_DEPTH-1 downto 0);
  signal dpram_addra_post_done : unsigned(c_DPRAM_DEPTH-1 downto 0);
  signal dpram_addrb_cnt       : unsigned(c_DPRAM_DEPTH-1 downto 0);
  signal dpram_dout            : std_logic_vector(63 downto 0);
  signal dpram_valid           : std_logic;
  signal dpram_valid_t         : std_logic;

  signal dpram0_dina  : std_logic_vector(63 downto 0);
  signal dpram0_addra : std_logic_vector(c_DPRAM_DEPTH-1 downto 0);
  signal dpram0_wea   : std_logic;
  signal dpram0_addrb : std_logic_vector(c_DPRAM_DEPTH-1 downto 0);
  signal dpram0_doutb : std_logic_vector(63 downto 0);

  signal dpram1_dina  : std_logic_vector(63 downto 0);
  signal dpram1_addra : std_logic_vector(c_DPRAM_DEPTH-1 downto 0);
  signal dpram1_wea   : std_logic;
  signal dpram1_addrb : std_logic_vector(c_DPRAM_DEPTH-1 downto 0);
  signal dpram1_doutb : std_logic_vector(63 downto 0);

  -- Wishbone to DDR flowcontrol FIFO
  signal wb_ddr_fifo_din   : std_logic_vector(64 downto 0);
  signal wb_ddr_fifo_dout  : std_logic_vector(64 downto 0);
  signal wb_ddr_fifo_empty : std_logic;
  signal wb_ddr_fifo_full  : std_logic;
  signal wb_ddr_fifo_wr    : std_logic;
  signal wb_ddr_fifo_rd    : std_logic;
  signal wb_ddr_fifo_valid : std_logic;
  signal wb_ddr_fifo_dreq  : std_logic;
  signal wb_ddr_fifo_wr_en : std_logic;

  -- RAM address counter
  signal ram_addr_cnt : unsigned(24 downto 0);
  signal test_data_en : std_logic;
  signal trig_addr    : std_logic_vector(31 downto 0);

  -- Wishbone interface to DDR
  signal wb_ddr_stall_t : std_logic;

  -- LEDs
  signal trig_led     : std_logic;
  signal trig_led_man : std_logic;
  signal acq_led      : std_logic;
  signal acq_led_man  : std_logic;

begin


  ------------------------------------------------------------------------------
  -- LEDs
  ------------------------------------------------------------------------------
  cmp_acq_led_monostable : monostable
    generic map(
      g_INPUT_POLARITY  => '1',
      g_OUTPUT_POLARITY => '1',
      g_OUTPUT_RETRIG   => true,
      g_OUTPUT_LENGTH   => 12500000
      )
    port map(
      rst_n_i   => sys_rst_n_i,
      clk_i     => sys_clk_i,
      trigger_i => samples_wr_en,
      pulse_o   => acq_led
      );

  gpio_led_acq_o <= acq_led or acq_led_man;

  cmp_trig_led_monostable : monostable
    generic map(
      g_INPUT_POLARITY  => '1',
      g_OUTPUT_POLARITY => '1',
      g_OUTPUT_RETRIG   => true,
      g_OUTPUT_LENGTH   => 12500000
      )
    port map(
      rst_n_i   => sys_rst_n_i,
      clk_i     => sys_clk_i,
      trigger_i => acq_trig,
      pulse_o   => trig_led
      );

  gpio_led_trig_o <= trig_led or trig_led_man;

  ------------------------------------------------------------------------------
  -- Resets
  ------------------------------------------------------------------------------
  sys_rst  <= not(sys_rst_n_i);
  fs_rst_n <= sys_rst_n_i and locked_out;
  fs_rst   <= not(fs_rst_n);

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
      CLKFBOUT => clk_fb_buf,
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

  cmp_fb_clk_buf : BUFG
    port map (
      O => clk_fb,
      I => clk_fb_buf
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


  --============================================================================
  -- Sampling clock domain
  --============================================================================

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

  -- serdes outputs re-ordering (time slices -> channel)
  --    out_raw :(71:63)(62:54)(53:45)(44:36)(35:27)(26:18)(17:9)(8:0)
  --                |      |      |      |      |      |      |    |
  --                V      V      V      V      V      V      V    V
  --              CH1D12 CH1D10 CH1D8  CH1D6  CH1D4  CH1D2  CH1D0  0   = CH1_B
  --              CH1D13 CH1D11 CH1D9  CH1D7  CH1D5  CH1D3  CH1D1  0   = CH1_A
  --              CH2D12 CH2D10 CH2D8  CH2D6  CH2D4  CH2D2  CH2D0  0   = CH2_B
  --              CH2D13 CH2D11 CH2D9  CH2D7  CH2D5  CH2D3  CH2D1  0   = CH2_A
  --              CH3D12 CH3D10 CH3D8  CH3D6  CH3D4  CH3D2  CH3D0  0   = CH3_B
  --              CH3D13 CH3D11 CH3D9  CH3D7  CH3D5  CH3D3  CH3D1  0   = CH3_A
  --              CH4D12 CH4D10 CH4D8  CH4D6  CH4D4  CH4D2  CH4D0  0   = CH4_B
  --              CH4D13 CH4D11 CH4D9  CH4D7  CH4D5  CH4D3  CH4D1  0   = CH4_A
  --              FR7    FR6    FR5    FR4    FR3    FR2    FR1    FR0 = FR
  --
  --    out_data(15:0)  = CH1
  --    out_data(31:16) = CH2
  --    out_data(47:32) = CH3
  --    out_data(63:48) = CH4
  --    Note: The two LSBs of each channel are always '0' => 14-bit ADC
  gen_serdes_dout_reorder : for I in 0 to 7 generate
    serdes_out_data(0*16 + 2*i)   <= serdes_out_raw(0 + i*9);  -- CH1 even bits
    serdes_out_data(0*16 + 2*i+1) <= serdes_out_raw(1 + i*9);  -- CH1 odd bits
    serdes_out_data(1*16 + 2*i)   <= serdes_out_raw(2 + i*9);  -- CH2 even bits
    serdes_out_data(1*16 + 2*i+1) <= serdes_out_raw(3 + i*9);  -- CH2 odd bits
    serdes_out_data(2*16 + 2*i)   <= serdes_out_raw(4 + i*9);  -- CH3 even bits
    serdes_out_data(2*16 + 2*i+1) <= serdes_out_raw(5 + i*9);  -- CH3 odd bits
    serdes_out_data(3*16 + 2*i)   <= serdes_out_raw(6 + i*9);  -- CH4 even bits
    serdes_out_data(3*16 + 2*i+1) <= serdes_out_raw(7 + i*9);  -- CH4 odd bits
    serdes_out_fr(i)              <= serdes_out_raw(8 + i*9);  -- FR
  end generate gen_serdes_dout_reorder;


  -- serdes bitslip generation
  p_auto_bitslip : process (fs_clk, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      bitslip_sreg        <= std_logic_vector(to_unsigned(1, bitslip_sreg'length));
      serdes_auto_bitslip <= '0';
      serdes_synced       <= '0';
    elsif rising_edge(fs_clk) then

      -- Shift register to generate bitslip enable (serdes_clk/8)
      bitslip_sreg <= bitslip_sreg(0) & bitslip_sreg(bitslip_sreg'length-1 downto 1);

      -- Generate bitslip and synced signal
      if(bitslip_sreg(bitslip_sreg'left) = '1') then
        if(serdes_out_fr /= "00001111") then  -- use fr_n pattern (fr_p and fr_n are swapped on the adc mezzanine)
          serdes_auto_bitslip <= '1';
          serdes_synced       <= '0';
        else
          serdes_auto_bitslip <= '0';
          serdes_synced       <= '1';
        end if;
      else
        serdes_auto_bitslip <= '0';
      end if;

    end if;
  end process;

  serdes_bitslip <= serdes_auto_bitslip or serdes_man_bitslip;

  ------------------------------------------------------------------------------
  -- ADC core control and status registers (CSR)
  ------------------------------------------------------------------------------
  cmp_fmc_adc_100Ms_csr : fmc_adc_100Ms_csr
    port map(
      rst_n_i                                => sys_rst_n_i,
      wb_clk_i                               => sys_clk_i,
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
      fmc_adc_core_ctl_fmc_clk_oe_o          => gpio_si570_oe_o,
      fmc_adc_core_ctl_offset_dac_clr_n_o    => gpio_dac_clr_n_o,
      fmc_adc_core_ctl_man_bitslip_o         => serdes_man_bitslip,
      fmc_adc_core_ctl_test_data_en_o        => test_data_en,
      fmc_adc_core_ctl_trig_led_o            => trig_led_man,
      fmc_adc_core_ctl_acq_led_o             => acq_led_man,
      fmc_adc_core_ctl_reserved_o            => open,
      fmc_adc_core_sta_fsm_i                 => acq_fsm_state,
      fmc_adc_core_sta_serdes_pll_i          => locked_out,
      fmc_adc_core_sta_serdes_synced_i       => serdes_synced,
      fmc_adc_core_sta_reserved_i            => (others => '0'),
      fmc_adc_core_trig_cfg_hw_trig_sel_o    => hw_trig_sel,
      fmc_adc_core_trig_cfg_hw_trig_pol_o    => hw_trig_pol,
      fmc_adc_core_trig_cfg_hw_trig_en_o     => hw_trig_en,
      fmc_adc_core_trig_cfg_sw_trig_en_o     => sw_trig_en,
      fmc_adc_core_trig_cfg_int_trig_sel_o   => int_trig_sel,
      fmc_adc_core_trig_cfg_reserved_o       => open,
      fmc_adc_core_trig_cfg_int_trig_thres_o => int_trig_thres,
      fmc_adc_core_trig_dly_o                => trig_delay,
      fmc_adc_core_sw_trig_o                 => open,
      fmc_adc_core_sw_trig_wr_o              => sw_trig_t,
      fmc_adc_core_shots_nb_o                => shots_value,
      fmc_adc_core_shots_reserved_o          => open,
      fmc_adc_core_trig_pos_i                => trig_addr,
      fmc_adc_core_sr_deci_o                 => decim_factor,
      fmc_adc_core_sr_reserved_o             => open,
      fmc_adc_core_pre_samples_o             => pre_trig_value,
      fmc_adc_core_post_samples_o            => post_trig_value,
      fmc_adc_core_samples_cnt_i             => std_logic_vector(samples_cnt),
      fmc_adc_core_ch1_ctl_ssr_o             => gpio_ssr_ch1_o,
      fmc_adc_core_ch1_ctl_reserved_o        => open,
      fmc_adc_core_ch1_sta_val_i             => serdes_out_data(15 downto 0),
      fmc_adc_core_ch1_sta_reserved_i        => (others => '0'),
      fmc_adc_core_ch1_gain_val_o            => gain_calibr(15 downto 0),
      fmc_adc_core_ch1_gain_reserved_o       => open,
      fmc_adc_core_ch1_offset_val_o          => offset_calibr(15 downto 0),
      fmc_adc_core_ch1_offset_reserved_o     => open,
      fmc_adc_core_ch2_ctl_ssr_o             => gpio_ssr_ch2_o,
      fmc_adc_core_ch2_ctl_reserved_o        => open,
      fmc_adc_core_ch2_sta_val_i             => serdes_out_data(31 downto 16),
      fmc_adc_core_ch2_sta_reserved_i        => (others => '0'),
      fmc_adc_core_ch2_gain_val_o            => gain_calibr(31 downto 16),
      fmc_adc_core_ch2_gain_reserved_o       => open,
      fmc_adc_core_ch2_offset_val_o          => offset_calibr(31 downto 16),
      fmc_adc_core_ch2_offset_reserved_o     => open,
      fmc_adc_core_ch3_ctl_ssr_o             => gpio_ssr_ch3_o,
      fmc_adc_core_ch3_ctl_reserved_o        => open,
      fmc_adc_core_ch3_sta_val_i             => serdes_out_data(47 downto 32),
      fmc_adc_core_ch3_sta_reserved_i        => (others => '0'),
      fmc_adc_core_ch3_gain_val_o            => gain_calibr(47 downto 32),
      fmc_adc_core_ch3_gain_reserved_o       => open,
      fmc_adc_core_ch3_offset_val_o          => offset_calibr(47 downto 32),
      fmc_adc_core_ch3_offset_reserved_o     => open,
      fmc_adc_core_ch4_ctl_ssr_o             => gpio_ssr_ch4_o,
      fmc_adc_core_ch4_ctl_reserved_o        => open,
      fmc_adc_core_ch4_sta_val_i             => serdes_out_data(63 downto 48),
      fmc_adc_core_ch4_sta_reserved_i        => (others => '0'),
      fmc_adc_core_ch4_gain_val_o            => gain_calibr(63 downto 48),
      fmc_adc_core_ch4_gain_reserved_o       => open,
      fmc_adc_core_ch4_offset_val_o          => offset_calibr(63 downto 48),
      fmc_adc_core_ch4_offset_reserved_o     => open
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
      g_MIN_PULSE_WIDTH => 1,           -- clk_i ticks
      g_CLK_FREQUENCY   => 100,         -- MHz
      g_OUTPUT_POLARITY => '0',         -- positive pulse
      g_OUTPUT_RETRIG   => false,
      g_OUTPUT_LENGTH   => 1            -- clk_i tick
      )
    port map(
      rst_n_i          => fs_rst_n,
      clk_i            => fs_clk,
      input_polarity_i => hw_trig_pol,
      pulse_i          => ext_trig_a,
      pulse_o          => ext_trig
      );

  -- Internal hardware trigger
  int_trig_data <= serdes_out_data(15 downto 0) when int_trig_sel = "00" else   -- CH1 selected
                   serdes_out_data(31 downto 16) when int_trig_sel = "01" else  -- CH2 selected
                   serdes_out_data(47 downto 32) when int_trig_sel = "10" else  -- CH3 selected
                   serdes_out_data(63 downto 48) when int_trig_sel = "11" else  -- CH4 selected
                   (others => '0');

  p_int_trig : process (fs_clk, fs_rst_n)
  begin
    if fs_rst_n = '0' then
      int_trig_over_thres   <= '0';
      int_trig_over_thres_d <= '0';
      serdes_out_data_d     <= (others => '0');
    elsif rising_edge(fs_clk) then
      if int_trig_data > int_trig_thres then
        int_trig_over_thres <= '1';
      else
        int_trig_over_thres <= '0';
      end if;
      int_trig_over_thres_d <= int_trig_over_thres;
      serdes_out_data_d     <= serdes_out_data;  -- delay data to compensate for threshold detection delay
    end if;
  end process p_int_trig;

  int_trig <= int_trig_over_thres and not(int_trig_over_thres_d) when hw_trig_pol = '0' else  -- positive slope
              not(int_trig_over_thres) and int_trig_over_thres_d;                             -- negative slope

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
  p_trig_delay_cnt : process(fs_clk, fs_rst_n)
  begin
    if fs_rst_n = '0' then
      trig_delay_cnt <= (others => '0');
    elsif rising_edge(fs_clk) then
      if trig = '1' then
        trig_delay_cnt <= unsigned(trig_delay);
      elsif trig_delay_cnt = 0 then
        trig_delay_cnt <= trig_delay_cnt - 1;
      end if;
    end if;
  end process p_trig_delay_cnt;

  p_trig_delay : process(fs_clk, fs_rst_n)
  begin
    if fs_rst_n = '0' then
      trig_d <= '0';
    elsif rising_edge(fs_clk) then
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
  -- Samples decimation and trigger alignment
  --    When the decimantion is enabled, if the trigger occurs between two
  --    samples it will be realigned to the next sample
  ------------------------------------------------------------------------------
  p_deci_cnt : process (fs_clk, fs_rst_n)
  begin
    if fs_rst_n = '0' then
      decim_cnt <= to_unsigned(1, decim_cnt'length);
      decim_en  <= '0';
    elsif rising_edge(fs_clk) then
      if decim_cnt = to_unsigned(0, decim_cnt'length) then
        if decim_factor /= X"0000" then
          decim_cnt <= unsigned(decim_factor) - 1;
        end if;
        decim_en <= '1';
      else
        decim_cnt <= decim_cnt - 1;
        decim_en  <= '0';
      end if;
    end if;
  end process p_deci_cnt;

  p_trig_align : process (fs_clk, fs_rst_n)
  begin
    if fs_rst_n = '0' then
      trig_align <= '0';
    elsif rising_edge(fs_clk) then
      if trig_d = '1' then
        trig_align <= '1';
      elsif decim_en = '1' then
        trig_align <= '0';
      end if;
    end if;
  end process p_trig_align;

  ------------------------------------------------------------------------------
  -- Offset and gain calibration
  ------------------------------------------------------------------------------
  l_offset_gain_calibr : for I in 0 to 3 generate
    cmp_offset_gain_calibr : offset_gain_s
      port map(
        rst_n_i  => fs_rst_n,
        clk_i    => fs_clk,
        offset_i => offset_calibr((I+1)*16-1 downto I*16),
        gain_i   => gain_calibr((I+1)*16-1 downto I*16),
        data_i   => data_calibr_in((I+1)*16-1 downto I*16),
        data_o   => data_calibr_out((I+1)*16-1 downto I*16)
        );
  end generate l_offset_gain_calibr;

  -- An additional 1 fs_clk period delay is added when internal hw trigger is selected
  data_calibr_in <= serdes_out_data_d when hw_trig_sel = '0' else serdes_out_data;

  ------------------------------------------------------------------------------
  -- Synchronisation FIFO to system clock domain
  ------------------------------------------------------------------------------
  cmp_adc_sync_fifo : adc_sync_fifo
    port map(
      rst    => fs_rst,                 -- must be at least 3 wr_clk and rd_clk cycles
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

  sync_fifo_din <= trig_align & data_calibr_out;
  -- FOR DEBUG: FR instead of CH1 and SerDes Synced instead of CH2
  --sync_fifo_din <= trig_align & serdes_out_data(63 downto 32) &
  --                 "000000000000000" & serdes_synced &
  --                 "00000000" & serdes_out_fr;

  sync_fifo_wr <= decim_en and serdes_synced and not(sync_fifo_full);
  sync_fifo_rd <= sync_fifo_dreq and not(sync_fifo_empty);


  --============================================================================
  -- System clock domain
  --============================================================================

  ------------------------------------------------------------------------------
  -- Shots counter
  ------------------------------------------------------------------------------
  p_shots_cnt : process (sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      shots_cnt   <= to_unsigned(0, shots_cnt'length);
      single_shot <= '0';
    elsif rising_edge(sys_clk_i) then
      if acq_start = '1' then
        shots_cnt  <= unsigned(shots_value);
      elsif shots_decr = '1' then
        shots_cnt <= shots_cnt - 1;
      end if;
      if shots_value = std_logic_vector(to_unsigned(1, shots_value'length)) then
        single_shot <= '1';
      else
        single_shot <= '0';
      end if;
    end if;
  end process p_shots_cnt;

  multishot_buffer_sel <= std_logic(shots_cnt(0));
  shots_done <= '1' when shots_cnt = to_unsigned(1, shots_cnt'length) else '0';

  ------------------------------------------------------------------------------
  -- Pre-trigger counter
  ------------------------------------------------------------------------------
  --p_pre_trig_cnt : process (sys_clk_i, sys_rst_n_i)
  --begin
  --  if sys_rst_n_i = '0' then
  --    pre_trig_cnt  <= to_unsigned(1, pre_trig_cnt'length);
  --    pre_trig_done <= '0';
  --  elsif rising_edge(sys_clk_i) then
  --    if (acq_start = '1' or pre_trig_done = '1') then
  --      pre_trig_cnt  <= unsigned(pre_trig_value);
  --      pre_trig_done <= '0';
  --    elsif pre_trig_cnt = to_unsigned(0, pre_trig_cnt'length) then
  --      pre_trig_done <= '1';
  --    elsif (acq_in_pre_trig = '1' and sync_fifo_valid = '1') then
  --      pre_trig_cnt <= pre_trig_cnt - 1;
  --    end if;
  --  end if;
  --end process p_pre_trig_cnt;


  p_pre_trig_cnt : process (sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      pre_trig_cnt  <= to_unsigned(1, pre_trig_cnt'length);
    elsif rising_edge(sys_clk_i) then
      if (acq_start = '1' or pre_trig_done = '1') then
        if unsigned(pre_trig_value) = to_unsigned(0, pre_trig_value'length) then
          pre_trig_cnt  <= (others => '0');
        else
          pre_trig_cnt  <= unsigned(pre_trig_value) - 1;
        end if;
      elsif (acq_in_pre_trig = '1' and sync_fifo_valid = '1') then
        pre_trig_cnt <= pre_trig_cnt - 1;
      end if;
    end if;
  end process p_pre_trig_cnt;


  pre_trig_done <= '1' when (pre_trig_cnt = to_unsigned(0, pre_trig_cnt'length) and
                             sync_fifo_valid = '1') else '0';

  ------------------------------------------------------------------------------
  -- Post-trigger counter
  ------------------------------------------------------------------------------
  --p_post_trig_cnt : process (sys_clk_i, sys_rst_n_i)
  --begin
  --  if sys_rst_n_i = '0' then
  --    post_trig_cnt  <= to_unsigned(1, post_trig_cnt'length);
  --    post_trig_done <= '0';
  --  elsif rising_edge(sys_clk_i) then
  --    if (acq_start = '1' or post_trig_done = '1') then
  --      post_trig_cnt  <= unsigned(post_trig_value);
  --      post_trig_done <= '0';
  --    elsif post_trig_cnt = to_unsigned(0, post_trig_cnt'length) then
  --      post_trig_done <= '1';
  --    elsif (acq_in_post_trig = '1' and sync_fifo_valid = '1') then
  --      post_trig_cnt <= post_trig_cnt - 1;
  --    end if;
  --  end if;
  --end process p_post_trig_cnt;


  p_post_trig_cnt : process (sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      post_trig_cnt  <= to_unsigned(1, post_trig_cnt'length);
    elsif rising_edge(sys_clk_i) then
      if (acq_start = '1' or post_trig_done = '1') then
        if unsigned(post_trig_value) = to_unsigned(0, post_trig_value'length) then
          post_trig_cnt  <= (others => '0');
        else
          post_trig_cnt  <= unsigned(post_trig_value) - 1;
        end if;
      elsif (acq_in_post_trig = '1' and sync_fifo_valid = '1') then
        post_trig_cnt <= post_trig_cnt - 1;
      end if;
    end if;
  end process p_post_trig_cnt;

  post_trig_done <= '1' when (post_trig_cnt = to_unsigned(0, post_trig_cnt'length) and
                              sync_fifo_valid = '1') else '0';

  ------------------------------------------------------------------------------
  -- Samples counter
  ------------------------------------------------------------------------------
  p_samples_cnt : process (sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      samples_cnt  <= (others => '0');
    elsif rising_edge(sys_clk_i) then
      if (acq_start = '1') then
        samples_cnt <= (others => '0');
      elsif ((acq_in_pre_trig = '1' or acq_in_post_trig = '1') and sync_fifo_valid = '1') then
        samples_cnt <= samples_cnt + 1;
      end if;
    end if;
  end process p_samples_cnt;

  ------------------------------------------------------------------------------
  -- Aqcuisition FSM
  ------------------------------------------------------------------------------

  -- Event pulses to time-tag
  trigger_p_o   <= acq_trig;
  acq_start_p_o <= acq_start;
  acq_stop_p_o  <= acq_stop;

  -- End of acquisition pulse generation
  p_acq_end : process (sys_clk_i)
  begin
    if rising_edge(sys_clk_i) then
      if sys_rst_n_i = '0' then
        acq_end_d <= '0';
      else
        acq_end_d <= acq_end;
      end if;
    end if;
  end process p_acq_end;

  acq_end_p_o <= acq_end and not(acq_end_d);

  -- FSM commands
  acq_start <= '1' when fsm_cmd_wr = '1' and fsm_cmd = "01" else '0';
  acq_stop  <= '1' when fsm_cmd_wr = '1' and fsm_cmd = "10" else '0';
  acq_trig  <= sync_fifo_valid and sync_fifo_dout(64) and acq_in_wait_trig;
  acq_end   <= shots_done and post_trig_done;

  -- FSM transitions
  p_acq_fsm_transitions : process(sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      acq_fsm_current_state <= IDLE;
    elsif rising_edge(sys_clk_i) then

      case acq_fsm_current_state is

        when IDLE =>
          if acq_start = '1' then
            acq_fsm_current_state <= PRE_TRIG;
          end if;

        when PRE_TRIG =>
          if acq_stop = '1' then
            acq_fsm_current_state <= IDLE;
          elsif pre_trig_done = '1' then
            acq_fsm_current_state <= WAIT_TRIG;
          end if;

        when WAIT_TRIG =>
          if acq_stop = '1' then
            acq_fsm_current_state <= IDLE;
          elsif acq_trig = '1' then
            acq_fsm_current_state <= POST_TRIG;
          end if;

        when POST_TRIG =>
          if acq_stop = '1' then
            acq_fsm_current_state <= IDLE;
          elsif post_trig_done = '1' then
            if single_shot = '1' then
              acq_fsm_current_state <= IDLE;
            else
              acq_fsm_current_state <= DECR_SHOT;
            end if;
          end if;

        when DECR_SHOT =>
          if acq_stop = '1' then
            acq_fsm_current_state <= IDLE;
          else
            if shots_done = '1' then
              acq_fsm_current_state <= IDLE;
            else
              acq_fsm_current_state <= PRE_TRIG;
            end if;
          end if;

        when others =>
          acq_fsm_current_state <= IDLE;

      end case;
    end if;
  end process p_acq_fsm_transitions;

  -- FSM outputs
  p_acq_fsm_outputs : process(acq_fsm_current_state)
  begin

    case acq_fsm_current_state is

      when IDLE =>
        shots_decr       <= '0';
        sync_fifo_dreq   <= '1';
        acq_in_pre_trig  <= '0';
        acq_in_wait_trig <= '0';
        acq_in_post_trig <= '0';
        samples_wr_en    <= '0';
        acq_fsm_state    <= "001";

      when PRE_TRIG =>
        shots_decr       <= '0';
        sync_fifo_dreq   <= '1';
        acq_in_pre_trig  <= '1';
        acq_in_wait_trig <= '0';
        acq_in_post_trig <= '0';
        samples_wr_en    <= '1';
        acq_fsm_state    <= "010";

      when WAIT_TRIG =>
        shots_decr       <= '0';
        sync_fifo_dreq   <= '1';
        acq_in_pre_trig  <= '0';
        acq_in_wait_trig <= '1';
        acq_in_post_trig <= '0';
        samples_wr_en    <= '1';
        acq_fsm_state    <= "011";

      when POST_TRIG =>
        shots_decr       <= '0';
        sync_fifo_dreq   <= '1';
        acq_in_pre_trig  <= '0';
        acq_in_wait_trig <= '0';
        acq_in_post_trig <= '1';
        samples_wr_en    <= '1';
        acq_fsm_state    <= "100";

      when DECR_SHOT =>
        shots_decr       <= '1';
        sync_fifo_dreq   <= '1';
        acq_in_pre_trig  <= '0';
        acq_in_wait_trig <= '0';
        acq_in_post_trig <= '0';
        samples_wr_en    <= '0';
        acq_fsm_state    <= "101";

      when others =>
        shots_decr       <= '0';
        sync_fifo_dreq   <= '1';
        acq_in_pre_trig  <= '0';
        acq_in_wait_trig <= '0';
        acq_in_post_trig <= '0';
        samples_wr_en    <= '0';
        acq_fsm_state    <= "111";

    end case;
  end process p_acq_fsm_outputs;

  ------------------------------------------------------------------------------
  -- Dual DPRAM buffers for multi-shots acquisition
  -----------------------------------------------------------------------------

  -- DPRAM input address counter
  p_dpram_addra_cnt : process (sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      dpram_addra_cnt       <= (others => '0');
      dpram_addra_trig      <= (others => '0');
      dpram_addra_post_done <= (others => '0');
    elsif rising_edge(sys_clk_i) then
      if shots_decr = '1' then
        dpram_addra_cnt <= to_unsigned(0, dpram_addra_cnt'length);
      elsif (samples_wr_en = '1' and sync_fifo_valid = '1') then
        dpram_addra_cnt <= dpram_addra_cnt + 1;
      end if;
      if acq_trig = '1' then
        dpram_addra_trig <= dpram_addra_cnt;
      end if;
      if post_trig_done = '1' then
        dpram_addra_post_done <= dpram_addra_cnt;
      end if;
    end if;
  end process p_dpram_addra_cnt;

  -- DPRAM inputs
  dpram0_addra <= std_logic_vector(dpram_addra_cnt);
  dpram1_addra <= std_logic_vector(dpram_addra_cnt);
  dpram0_dina  <= sync_fifo_dout(63 downto 0);
  dpram1_dina  <= sync_fifo_dout(63 downto 0);
  dpram0_wea   <= (samples_wr_en and sync_fifo_valid) when multishot_buffer_sel = '0' else '0';
  dpram1_wea   <= (samples_wr_en and sync_fifo_valid) when multishot_buffer_sel = '1' else '0';

  -- DPRAMs
  cmp_multishot_dpram0 : multishot_dpram
    port map(
      clka   => sys_clk_i,
      wea(0) => dpram0_wea,
      addra  => dpram0_addra,
      dina   => dpram0_dina,
      clkb   => sys_clk_i,
      addrb  => dpram0_addrb,
      doutb  => dpram0_doutb
      );

  cmp_multishot_dpram1 : multishot_dpram
    port map(
      clka   => sys_clk_i,
      wea(0) => dpram1_wea,
      addra  => dpram1_addra,
      dina   => dpram1_dina,
      clkb   => sys_clk_i,
      addrb  => dpram1_addrb,
      doutb  => dpram1_doutb
      );

  -- DPRAM output address counter
  p_dpram_addrb_cnt : process (sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      dpram_addrb_cnt <= (others => '0');
      dpram_valid_t   <= '0';
      dpram_valid     <= '0';
    elsif rising_edge(sys_clk_i) then
      if post_trig_done = '1' then
        dpram_addrb_cnt <= dpram_addra_trig - unsigned(pre_trig_value(c_DPRAM_DEPTH-1 downto 0)) + 1;
        dpram_valid_t   <= '1';
      elsif (dpram_addrb_cnt = dpram_addra_post_done) then
        dpram_valid_t <= '0';
      else
        dpram_addrb_cnt <= dpram_addrb_cnt + 1;
      end if;
      dpram_valid <= dpram_valid_t;
    end if;
  end process p_dpram_addrb_cnt;

  -- DPRAM output mux
  dpram_dout   <= dpram0_doutb when multishot_buffer_sel = '1' else dpram1_doutb;
  dpram0_addrb <= std_logic_vector(dpram_addrb_cnt);
  dpram1_addrb <= std_logic_vector(dpram_addrb_cnt);

  ------------------------------------------------------------------------------
  -- Flow control FIFO for data to DDR
  ------------------------------------------------------------------------------
  cmp_wb_ddr_fifo : wb_ddr_fifo
    port map(
      rst   => sys_rst,                 -- must be at least 3 wr_clk and rd_clk cycles
      clk   => sys_clk_i,
      din   => wb_ddr_fifo_din,
      wr_en => wb_ddr_fifo_wr,
      rd_en => wb_ddr_fifo_rd,
      dout  => wb_ddr_fifo_dout,
      full  => wb_ddr_fifo_full,
      empty => wb_ddr_fifo_empty,
      valid => wb_ddr_fifo_valid
      );

  p_wb_ddr_fifo_input : process (sys_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      wb_ddr_fifo_din   <= (others => '0');
      wb_ddr_fifo_wr_en <= '0';
    elsif rising_edge(sys_clk_i) then
      if single_shot = '1' then
        wb_ddr_fifo_din   <= acq_trig & sync_fifo_dout(63 downto 0);  -- trigger + data
        wb_ddr_fifo_wr_en <= samples_wr_en and sync_fifo_valid;
      else
        wb_ddr_fifo_din   <= '0' & dpram_dout;
        wb_ddr_fifo_wr_en <= dpram_valid;
      end if;
    end if;
  end process p_wb_ddr_fifo_input;
  --wb_ddr_fifo_din   <= sync_fifo_dout(63 downto 0) when single_shot = '1' else dpram_dout;
  --wb_ddr_fifo_wr_en <= samples_wr_en               when single_shot = '1' else dpram_valid;
  wb_ddr_fifo_wr <= wb_ddr_fifo_wr_en and not(wb_ddr_fifo_full);

  wb_ddr_fifo_rd   <= wb_ddr_fifo_dreq and not(wb_ddr_fifo_empty) and not(wb_ddr_stall_t);
  wb_ddr_fifo_dreq <= '1';

  ------------------------------------------------------------------------------
  -- RAM address counter (32-bit word address)
  ------------------------------------------------------------------------------
  p_ram_addr_cnt : process (wb_ddr_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      ram_addr_cnt <= (others => '0');
    elsif rising_edge(wb_ddr_clk_i) then
      if acq_start = '1' then
        ram_addr_cnt <= (others => '0');
      elsif wb_ddr_fifo_valid = '1' then
        ram_addr_cnt <= ram_addr_cnt + 1;
      end if;
    end if;
  end process p_ram_addr_cnt;

  ------------------------------------------------------------------------------
  -- Store trigger DDR address
  ------------------------------------------------------------------------------
  p_trig_addr : process (wb_ddr_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      trig_addr <= (others => '0');
    elsif rising_edge(wb_ddr_clk_i) then
      if wb_ddr_fifo_dout(64) = '1' and wb_ddr_fifo_valid = '1' then
        trig_addr <= "0000000" & std_logic_vector(ram_addr_cnt);
      end if;
    end if;
  end process p_trig_addr;

  ------------------------------------------------------------------------------
  -- Wishbone master (to DDR)
  ------------------------------------------------------------------------------
  p_wb_master : process (wb_ddr_clk_i, sys_rst_n_i)
  begin
    if sys_rst_n_i = '0' then
      wb_ddr_cyc_o   <= '0';
      wb_ddr_we_o    <= '0';
      wb_ddr_stb_o   <= '0';
      wb_ddr_adr_o   <= (others => '0');
      wb_ddr_dat_o   <= (others => '0');
      wb_ddr_stall_t <= '0';
    elsif rising_edge(wb_ddr_clk_i) then

      if wb_ddr_fifo_valid = '1' then   --if (wb_ddr_fifo_valid = '1') and (wb_ddr_stall_i = '0') then
        wb_ddr_stb_o <= '1';
        wb_ddr_adr_o <= "0000000" & std_logic_vector(ram_addr_cnt);
        if test_data_en = '1' then
          wb_ddr_dat_o <= x"00000000" & "0000000" & std_logic_vector(ram_addr_cnt);
        else
          wb_ddr_dat_o <= wb_ddr_fifo_dout(63 downto 0);
        end if;
      else
        wb_ddr_stb_o <= '0';
      end if;

      if wb_ddr_fifo_valid = '1' then
        wb_ddr_cyc_o <= '1';
        wb_ddr_we_o  <= '1';
        --elsif (wb_ddr_fifo_empty = '1') and (acq_end = '1') then
      elsif (wb_ddr_fifo_empty = '1') and (acq_fsm_state = "001") then
        wb_ddr_cyc_o <= '0';
        wb_ddr_we_o  <= '0';
      end if;

      wb_ddr_stall_t <= wb_ddr_stall_i;

    end if;
  end process p_wb_master;

  wb_ddr_sel_o <= X"FF";

end rtl;
