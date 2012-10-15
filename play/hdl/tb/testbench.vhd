--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:40:28 09/12/2012
-- Design Name:   
-- Module Name:   /home/tstana/Projects/play_fmcadc100m14b4cha/hdl/tb/testbench.vhd
-- Project Name:  play_fmcadc100m14b4cha
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: led_ctrl
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------  
  -- UUT
  COMPONENT led_ctrl
    PORT(
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
  END COMPONENT;

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

  -----------------------------------------------------------------------------
  -- Type definitions
  -----------------------------------------------------------------------------  
  type t_mst_fsm is (ST_IDLE, ST_WR1, ST_WR2, ST_RD1, ST_RD2, ST_DUMMY);
  type t_fsm_act is (ACT_WR, ACT_RD);  -- tells the master FSM what to do -- read/write
  
  -----------------------------------------------------------------------------
  -- Constants
  -----------------------------------------------------------------------------  
  constant c_CLK20_PER  : time := 50 ns;
  constant c_CLK125_PER : time :=  8 ns;
  
  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------  
  -- Clock, reset
  signal s_clk    : std_logic := '0';
  signal s_clk125 : std_logic := '0';
  signal s_rst    : std_logic := '0';
  signal s_rst_n  : std_logic := '1';
  
  -- Wishbone
  signal s_wb_dat   : std_logic_vector(31 downto 0) := (others => '0');
  signal s_wb_we    : std_logic := '0';
  signal s_wb_stb   : std_logic := '0';
  signal s_wb_cyc   : std_logic := '0';
  signal s_wb_dat_i : std_logic_vector(31 downto 0);
  signal s_wb_dat_o : std_logic_vector(31 downto 0);
  signal s_wb_adr   : std_logic_vector(31 downto 0);
  signal s_ack      : std_logic;

  -- Master FSM signals
  signal s_state    : t_mst_fsm;
  signal s_fsm_data : std_logic_vector(31 downto 0);
  signal s_fsm_ctrl : std_logic; -- 1 = write, 0 = read
  signal s_fsm_act  : t_fsm_act; -- FSM action

  -- Address decoder signals
  signal s_dec_cyc_o : std_logic_vector(1 downto 0);
  signal s_dec_ack_i : std_logic_vector(1 downto 0);
  signal s_dec_dat_i : std_logic_vector(63 downto 0);
  
  -- IRQ controller signals
  signal s_irq_p    : std_logic;
  signal s_leds_irq : std_logic_vector(1 downto 0);
  signal s_irq      : std_logic_vector(31 downto 0);

  signal s_leds : std_logic_vector(1 downto 0);
  
--=============================================================================
--  architecture begin
--=============================================================================
BEGIN
 
  -----------------------------------------------------------------------------
  -- Component instantiation
  -----------------------------------------------------------------------------
  -- Instantiate the Unit Under Test (UUT)
   uut: led_ctrl PORT MAP (
          clk_i    => s_clk,
          rst_i    => s_rst,
          wb_dat_i => s_wb_dat_o(0),
          wb_adr_i => s_wb_adr(0),
          wb_we_i  => s_wb_we,
          wb_stb_i => s_wb_stb,
          wb_cyc_i => s_dec_cyc_o(1),
          wb_ack_o => s_dec_ack_i(1),
          wb_dat_o => s_dec_dat_i(32),
          irq_o    => s_leds_irq,
          leds_o   => s_leds
        );

  -- IRQ controller
  cmp_irq_ctrl: irq_controller
    port map
    (
      clk_i       => s_clk125,
      rst_n_i     => s_rst_n,
      irq_src_p_i => s_irq,
      irq_p_o     => s_irq_p,
      wb_adr_i    => s_wb_adr(1 downto 0),
      wb_dat_i    => s_wb_dat_o,
      wb_dat_o    => s_dec_dat_i(31 downto 0),
      wb_cyc_i    => s_dec_cyc_o(0),
      wb_sel_i    => (others => '0'),
      wb_stb_i    => s_wb_stb,
      wb_we_i     => s_wb_we,
      wb_ack_o    => s_dec_ack_i(0)
    );
  
  s_irq(31 downto 2) <= (others => '0');
  s_irq(1 downto 0)  <= s_leds_irq;
  s_rst_n            <= not s_rst;
  
  -- Address decoder
  cmp_addr_dec : addr_dec
    port map (
      adr_i => s_wb_adr(2),
      cyc_i => s_wb_cyc,
      dat_i => s_dec_dat_i,
      ack_i => s_dec_ack_i,
      
      cyc_o => s_dec_cyc_o,
      ack_o => s_ack,
      dat_o => s_wb_dat_i
    );
  s_dec_dat_i(63 downto 33) <= (others => '0');
    -----------------------------------------------------------------------------
  -- Clock generation processes
  -----------------------------------------------------------------------------
   p_clk20: process
   begin
		 s_clk <= '0';
		 wait for c_CLK20_PER/2;
		 s_clk <= '1';
		 wait for c_CLK20_PER/2;
   end process p_clk20;
   
   p_clk125: process
   begin
     s_clk125 <= '0';
     wait for c_CLK125_PER/2;
     s_clk125 <= '1';
     wait for c_CLK125_PER/2;
   end process p_clk125;
   
  -----------------------------------------------------------------------------
  -- Stimulus process
  -----------------------------------------------------------------------------
  p_stim_irq: process is
  begin

    s_rst      <= '1';
    s_fsm_ctrl <= '0';
    s_fsm_act  <= ACT_WR;
    s_fsm_data <= x"00000000";
    s_wb_adr   <= x"00000000";
    -- hold reset state for 100 ns.
    wait for 100 ns;	
    s_rst <= '0';
    --wait for c_CLK20_PER*10;
    wait for 10 ns;
 
    -- IRQ_EN_MASK reg write
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_WR;
    s_wb_adr   <= x"00000002";
    s_fsm_data <= x"00000001";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- IRQ_EN_MASK reg read
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_RD;
    s_wb_adr   <= x"00000002";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- LED R0 read
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_RD;
    s_wb_adr   <= x"00000004";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- LED R1 read
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_RD;
    s_wb_adr   <= x"00000005";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- LED R0 write
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_WR;
    s_wb_adr   <= x"00000004";
    s_fsm_data <= x"00000001";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- LED R0 read
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_RD;
    s_wb_adr   <= x"00000004";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- IRQ_SRC read
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_RD;
    s_wb_adr   <= x"00000001";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';

    -- IRQ_SRC write
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_WR;
    s_wb_adr   <= x"00000001";
    s_fsm_data <= x"00000001";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- LED R1 write
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_WR;
    s_wb_adr   <= x"00000005";
    s_fsm_data <= x"00000001";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';
    
    -- LED R1 read
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_RD;
    s_wb_adr   <= x"00000005";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';

    -- IRQ_SRC read
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_RD;
    s_wb_adr   <= x"00000001";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';

    -- IRQ_SRC write
    wait for c_CLK20_PER * 5;
    s_fsm_ctrl <= '1';
    s_fsm_act  <= ACT_WR;
    s_wb_adr   <= x"00000001";
    s_fsm_data <= x"00000001";
    wait for c_CLK20_PER;
    s_fsm_ctrl <= '0';

    
    -- WAIT INDEFINITELY
    wait;    
    
  end process p_stim_irq;
   
   
   
   -- -- Stimulus process
   -- stim_proc: process
   -- begin	

      -- s_rst      <= '1';
      -- s_fsm_ctrl <= '0';
      -- s_fsm_act  <= ACT_WR;
      -- s_fsm_data <= x"00000000";
      -- s_wb_adr   <= x"00000000";
      -- -- hold reset state for 100 ns.
      -- wait for 100 ns;	
      -- s_rst <= '0';
      -- --wait for c_CLK20_PER*10;
      -- wait for 10 ns;
      
      -- -- insert stimulus here 
      
      -- -- WR 1 -> R0
      -- s_fsm_ctrl <= '1';
      -- s_fsm_act  <= ACT_WR;
      -- s_wb_adr   <= x"00000000";
      -- s_fsm_data <= x"00000001";
      -- wait for c_CLK20_PER;
      -- s_fsm_ctrl <= '0';
      
      -- -- RD R0
      -- wait for c_CLK20_PER * 5;
      -- s_fsm_ctrl <= '1';
      -- s_fsm_act  <= ACT_RD;
      -- s_wb_adr   <= x"00000000";
      -- wait for c_CLK20_PER;
      -- s_fsm_ctrl <= '0';
      
      -- -- RD R1
      -- wait for c_CLK20_PER * 5;
      -- s_fsm_ctrl <= '1';
      -- s_fsm_act  <= ACT_RD;
      -- s_wb_adr   <= x"00000001";
      -- wait for c_CLK20_PER;
      -- s_fsm_ctrl <= '0';

      -- -- WR 1 -> R1
      -- wait for c_CLK20_PER * 5;
      -- s_fsm_ctrl <= '1';
      -- s_fsm_act  <= ACT_WR;
      -- s_wb_adr   <= x"00000001";
      -- s_fsm_data <= x"00000001";
      -- wait for c_CLK20_PER;
      -- s_fsm_ctrl <= '0';

      -- -- RD R1
      -- wait for c_CLK20_PER * 5;
      -- s_fsm_ctrl <= '1';
      -- s_fsm_act  <= ACT_RD;
      -- s_wb_adr   <= x"00000001";
      -- -- s_fsm_data <= x"00000001";
      -- wait for c_CLK20_PER;
      -- s_fsm_ctrl <= '0';

      -- -- WR 0 -> R0
      -- wait for c_CLK20_PER * 5;
      -- s_fsm_ctrl <= '1';
      -- s_fsm_act  <= ACT_WR;
      -- s_wb_adr   <= x"00000000";
      -- s_fsm_data <= x"00000000";
      -- wait for c_CLK20_PER;
      -- s_fsm_ctrl <= '0';

      -- -- RD R0
      -- wait for c_CLK20_PER * 5;
      -- s_fsm_ctrl <= '1';
      -- s_fsm_act  <= ACT_RD;
      -- s_wb_adr   <= x"00000000";
      -- -- s_fsm_data <= x"00000001";
      -- wait for c_CLK20_PER;
      -- s_fsm_ctrl <= '0';
      
      
      -- -- WAIT INDEFINITELY
      -- wait;
   -- end process;

  -----------------------------------------------------------------------------
  -- FSM process
  -----------------------------------------------------------------------------
  p_fsm: process (s_clk, s_rst, s_state) is
  begin
    if rising_edge(s_clk) then
      if (s_rst = '1') then
        s_state    <= ST_IDLE;
        s_wb_we    <= '0';
        s_wb_stb   <= '0';
        s_wb_cyc   <= '0';
        s_wb_dat_o <= (others => '0');
        
      else
      
        case s_state is
          
          when ST_IDLE =>
            s_wb_we  <= '0';
            s_wb_stb <= '0';
            s_wb_cyc <= '0';
            if (s_fsm_ctrl = '1') then
              if (s_fsm_act = ACT_WR) then
                s_state <= ST_WR1;
              else
                s_state <= ST_RD1;
              end if;
            end if;
          
          when ST_WR1 =>
            s_wb_dat_o <= s_fsm_data;
            s_wb_we    <= '1';
            s_wb_stb   <= '1';
            s_wb_cyc   <= '1';
            s_state    <= ST_WR2;
            
          when ST_WR2 =>
            if (s_ack = '1') then
              s_wb_we  <= '0';
              s_wb_stb <= '0';
              s_wb_cyc <= '0';
              s_state  <= ST_IDLE;
            end if;
            
          when ST_RD1 =>
            s_wb_we  <= '0';
            s_wb_stb <= '1';
            s_wb_cyc <= '1';
            s_state  <= ST_RD2;
            
          when ST_RD2 =>
            if (s_ack = '1') then
              s_wb_stb <= '0';
              s_wb_cyc <= '0';
              s_state  <= ST_IDLE;
            end if;
            
          when ST_DUMMY =>
            s_wb_dat <= (others => '0');
            s_state <= ST_IDLE;
            
          when others =>
            s_state <= ST_IDLE;
            
        end case;
      
      end if;
    end if;
  end process p_fsm;
  -----------------------------------------------------------------------------
END;
--=============================================================================
--  architecture end
--=============================================================================
