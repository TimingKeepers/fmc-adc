
-- file: adc_serdes.vhd
-- (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
------------------------------------------------------------------------------
-- User entered comments
------------------------------------------------------------------------------
-- None
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity adc_serdes is
generic
 (-- width of the data for the system
  sys_w       : integer := 9;
  -- width of the data for the device
  dev_w       : integer := 72);
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
         CLK_INB             : in  std_logic;
         CLK_OUT             : out std_logic;
         CLK_DIV_IN          : in  std_logic;  -- Slow clock from PLL/MMCM
         CLK_REF             : in  std_logic;
         LOCKED_IN           : in  std_logic;
         LOCKED_OUT          : out std_logic;
         CLK_RESET           : in  std_logic;  -- Reset signal for Clock circuit
         IO_RESET            : in  std_logic);   -- Reset signal for IO circuit);                   -- Reset signal for IO circuit
end adc_serdes;

architecture xilinx of adc_serdes is
   
  
  attribute CORE_GENERATION_INFO            : string;
  attribute CORE_GENERATION_INFO of xilinx  : architecture is "adc_serdes,selectio_wiz_v2_0,{component_name=adc_serdes,bus_dir=INPUTS,bus_sig_type=DIFF,bus_io_std=LVDS_25,use_serialization=true,use_phase_detector=false,serialization_factor=8,enable_bitslip=true,enable_train=false,system_data_width=9,bus_in_delay=NONE,bus_out_delay=NONE,clk_sig_type=SINGLE,clk_io_std=LVCMOS25,clk_buf=BUFPLL,active_edge=RISING,clk_delay=NONE,v6_bus_in_delay=NONE,v6_bus_out_delay=NONE,v6_clk_buf=BUFIO,v6_active_edge=NOT_APP,v6_ddr_alignment=SAME_EDGE_PIPELINED,v6_oddr_alignment=SAME_EDGE,ddr_alignment=C0,v6_interface_type=NETWORKING,interface_type=RETIMED,v6_bus_in_tap=0,v6_bus_out_tap=0,v6_clk_io_std=LVCMOS18,v6_clk_sig_type=DIFF}";
  constant clock_enable            : std_logic := '1';
  signal clk_in_int_buf            : std_logic;
  signal clk_div_in_int            : std_logic;
  
  signal adc_dco_p_buf             : std_logic;
  signal adc_dco_n_buf             : std_logic;


  -- After the buffer
  signal data_in_from_pins_int     : std_logic_vector(sys_w-1 downto 0);
  -- Between the delay and serdes
  signal data_in_from_pins_delay   : std_logic_vector(sys_w-1 downto 0);


  constant num_serial_bits         : integer := dev_w/sys_w;
  type serdarr is array (0 to 7) of std_logic_vector(sys_w-1 downto 0);
  -- Array to use intermediately from the serdes to the internal
  --  devices. bus "0" is the leftmost bus
  -- * fills in starting with 0
  signal iserdes_q                 : serdarr := (( others => (others => '0')));
  signal serdesstrobe             : std_logic;
  signal icascade                 : std_logic_vector(sys_w-1 downto 0);
  signal slave_shiftout           : std_logic_vector(sys_w-1 downto 0);
  signal serdes_rst               : std_logic;
  
  signal idelayctrl_rdy           : std_logic;
  
--  signal q1, q2, q3, q4, q5, q6, q7, q8 : std_logic_vector(sys_w-1 downto 0);
  
  attribute mark_debug : string;
  attribute mark_debug of idelayctrl_rdy : signal is "true";
  
--  attribute mark_debug of q1 : signal is "true";
--  attribute mark_debug of q2 : signal is "true";
--  attribute mark_debug of q3 : signal is "true";
--  attribute mark_debug of q4 : signal is "true";
--  attribute mark_debug of q5 : signal is "true";
--  attribute mark_debug of q6 : signal is "true";
--  attribute mark_debug of q7 : signal is "true";
--  attribute mark_debug of q8 : signal is "true";


begin



--  ibuf_adc_dco : IBUFGDS_DIFF_OUT
--  port map(
--    I  => clk_in,
--    IB => clk_inb,
--    O  => adc_dco_p_buf,
--    OB => adc_dco_n_buf
--    );


  -- Create the clock logic

--   bufpll_inst : BUFPLL
--    generic map (
--      DIVIDE        => 8)
--    port map (
--      IOCLK        => clk_in_int_buf,
--      LOCK         => LOCKED_OUT,
--      SERDESSTROBE => serdesstrobe,
--      GCLK         => CLK_DIV_IN,  -- GCLK pin must be driven by BUFG
--      LOCKED       => LOCKED_IN,
--      PLLIN        => CLK_IN);

  -- CLK_OUT <= CLK_IN;
  -- LOCKED_OUT <= LOCKED_IN;
  
--  idelayctrl_inst : IDELAYCTRL
--  port map(
--    RST     => not LOCKED_IN,
--    REFCLK  => CLK_REF,
--    RDY     => idelayctrl_rdy
--  );

  process(clk_div_in)
  begin
    if(rising_edge(clk_div_in)) then
        
        if(locked_in = '1') then
            serdes_rst <= '0';
        else
            serdes_rst <= '1';
        end if;
        
        if serdes_rst = '1' then
            serdes_rst <= '0';
        end if;
           
    end if;  
  end process;


  -- We have multiple bits- step over every bit, instantiating the required elements
  pins: for pin_count in 0 to sys_w-1 generate 

   begin
    -- Instantiate the buffers
    ----------------------------------
    -- Instantiate a buffer for every bit of the data bus
     ibufds_inst : IBUFDS
       generic map (
         DIFF_TERM  => TRUE,             -- Differential termination
         IOSTANDARD => "LVDS_25")
       port map (
         I          => DATA_IN_FROM_PINS_P  (pin_count),
         IB         => DATA_IN_FROM_PINS_N  (pin_count),
         O          => data_in_from_pins_int(pin_count));


    -- Pass through the delay
    -----------------------------------
    
--    idelay_inst : IDELAYE2
--    generic map(
--        IDELAY_TYPE         => "FIXED",
--        DELAY_SRC           => "IDATAIN",
--        IDELAY_VALUE        => 8,
--        REFCLK_FREQUENCY    => 200.0        
--    )
--    port map(
--        C                   => CLK_REF,
--        REGRST              => '0',
--        LD                  => '0',
--        CE                  => '0',
--        INC                 => '0',
--        CINVCTRL            => '0',
--        CNTVALUEIN          => (OTHERS => '0'),
--        IDATAIN             => data_in_from_pins_int(pin_count),
--        DATAIN              => '0',
--        LDPIPEEN            => '0',
--        DATAOUT             => data_in_from_pins_delay(pin_count),
--        CNTVALUEOUT         => open);
    
    data_in_from_pins_delay(pin_count) <= data_in_from_pins_int(pin_count);

     -- Instantiate the serdes primitive
     ----------------------------------
     -- declare the iserdes
--     iserdes2_master : ISERDES2
--       generic map (
--         BITSLIP_ENABLE => TRUE,
--         DATA_RATE      => "SDR",
--         DATA_WIDTH     => 8,
--         INTERFACE_TYPE => "RETIMED",
--         SERDES_MODE    => "MASTER")
--       port map (
--         Q1         => iserdes_q(3)(pin_count),
--         Q2         => iserdes_q(2)(pin_count),
--         Q3         => iserdes_q(1)(pin_count),
--         Q4         => iserdes_q(0)(pin_count),
--         SHIFTOUT   => icascade(pin_count),
--         INCDEC     => open,
--         VALID      => open,
--         BITSLIP    => BITSLIP,       -- 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
--                                      -- The amount of bitslip is fixed by the DATA_WIDTH selection.
--         CE0        => clock_enable,   -- 1-bit Clock enable input
--         CLK0       => clk_in_int_buf, -- 1-bit IO Clock network input. Optionally Invertible. This is the primary clock
--                                       -- input used when the clock doubler circuit is not engaged (see DATA_RATE
--                                       -- attribute).
--         CLK1       => '0',
--         CLKDIV     => CLK_DIV_IN,
--         D          => data_in_from_pins_delay(pin_count), -- 1-bit Input signal from IOB.
--         IOCE       => serdesstrobe,                       -- 1-bit Data strobe signal derived from BUFIO CE. Strobes data capture for
--                                                          -- NETWORKING and NETWORKING_PIPELINES alignment modes.

--         RST        => IO_RESET,        -- 1-bit Asynchronous reset only.
--         SHIFTIN    => slave_shiftout(pin_count),


--        -- unused connections
--         FABRICOUT  => open,
--         CFB0       => open,
--         CFB1       => open,
--         DFB        => open);

--     iserdes2_slave : ISERDES2
--       generic map (
--         BITSLIP_ENABLE => TRUE,
--         DATA_RATE      => "SDR",
--         DATA_WIDTH     => 8,
--         INTERFACE_TYPE => "RETIMED",
--         SERDES_MODE    => "SLAVE")
--       port map (
--        Q1         => iserdes_q(7)(pin_count),
--        Q2         => iserdes_q(6)(pin_count),
--        Q3         => iserdes_q(5)(pin_count),
--        Q4         => iserdes_q(4)(pin_count),
--        SHIFTOUT   => slave_shiftout(pin_count),
--        BITSLIP    => BITSLIP,      -- 1-bit Invoke Bitslip. This can be used with any DATA_WIDTH, cascaded or not.
--                                    -- The amount of bitslip is fixed by the DATA_WIDTH selection.
--        CE0        => clock_enable,   -- 1-bit Clock enable input
--        CLK0       => clk_in_int_buf, -- 1-bit IO Clock network input. Optionally Invertible. This is the primary clock
--                                      -- input used when the clock doubler circuit is not engaged (see DATA_RATE
--                                      -- attribute).
--        CLK1       => '0',
--        CLKDIV     => CLK_DIV_IN,
--        D          => '0',            -- 1-bit Input signal from IOB.
--        IOCE       => serdesstrobe,   -- 1-bit Data strobe signal derived from BUFIO CE. Strobes data capture for
--                                      -- NETWORKING and NETWORKING_PIPELINES alignment modes.

--        RST        => IO_RESET,       -- 1-bit Asynchronous reset only.
--        SHIFTIN    => icascade(pin_count),
--        -- unused connections
--        FABRICOUT  => open,
--        CFB0       => open,
--        CFB1       => open,
--        DFB        => open);
        
   -- ISERDESE2: Input SERial/DESerializer with Bitslip
   --            Artix-7
   -- Xilinx HDL Language Template, version 2015.4

   ISERDESE2_inst : ISERDESE2
   generic map (
      DATA_RATE => "SDR",           -- DDR, SDR
      DATA_WIDTH => 8,              -- Parallel data width (2-8,10,14)
      DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
      DYN_CLK_INV_EN => "FALSE",    -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
      -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
      INIT_Q1 => '0',
      INIT_Q2 => '0',
      INIT_Q3 => '0',
      INIT_Q4 => '0',
      INTERFACE_TYPE => "NETWORKING",   -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
      IOBDELAY => "NONE",           -- NONE, BOTH, IBUF, IFD
      NUM_CE => 1,                  -- Number of clock enables (1,2)
      OFB_USED => "FALSE",          -- Select OFB path (FALSE, TRUE)
      SERDES_MODE => "MASTER",      -- MASTER, SLAVE
      -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
      SRVAL_Q1 => '0',
      SRVAL_Q2 => '0',
      SRVAL_Q3 => '0',
      SRVAL_Q4 => '0' 
   )
   port map (
      O => open,                       -- 1-bit output: Combinatorial output
      -- Q1 - Q8: 1-bit (each) output: Registered data outputs
      Q1 => iserdes_q(7)(pin_count),
      Q2 => iserdes_q(6)(pin_count),
      Q3 => iserdes_q(5)(pin_count),
      Q4 => iserdes_q(4)(pin_count),
      Q5 => iserdes_q(3)(pin_count),
      Q6 => iserdes_q(2)(pin_count),
      Q7 => iserdes_q(1)(pin_count),
      Q8 => iserdes_q(0)(pin_count),
      -- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
      SHIFTOUT1 => open,
      SHIFTOUT2 => open,
      BITSLIP => BITSLIP,           -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
                                    -- CLKDIV when asserted (active High). Subsequently, the data seen on the
                                    -- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
                                    -- position every time Bitslip is invoked (DDR operation is different from
                                    -- SDR).

      -- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
      CE1 => clock_enable,
      CE2 => '0',
      CLKDIVP => '0',           -- 1-bit input: TBD
      -- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
      CLK => CLK_IN,                   -- 1-bit input: High-speed clock
      CLKB => CLK_INB,                 -- 1-bit input: High-speed secondary clock
      CLKDIV => CLK_DIV_IN,             -- 1-bit input: Divided clock
      OCLK => '0',                 -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY" 
      -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
      DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
      DYNCLKSEL => '0',       -- 1-bit input: Dynamic CLK/CLKB inversion
      -- Input Data: 1-bit (each) input: ISERDESE2 data input ports
      D => data_in_from_pins_delay(pin_count),                       -- 1-bit input: Data input
      DDLY => '0',                 -- 1-bit input: Serial data from IDELAYE2
      OFB => '0',                   -- 1-bit input: Data feedback from OSERDESE2
      OCLKB => '0',               -- 1-bit input: High speed negative edge output clock
      RST => serdes_rst,                   -- 1-bit input: Active high asynchronous reset
      -- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
      SHIFTIN1 => '0',
      SHIFTIN2 => '0' 
   );

   -- End of ISERDESE2_inst instantiation
   

     -- Concatenate the serdes outputs together. Keep the timesliced
     --   bits together, and placing the earliest bits on the right
     --   ie, if data comes in 0, 1, 2, 3, 4, 5, 6, 7, ...
     --       the output will be 3210, 7654, ...
     -------------------------------------------------------------

     in_slices: for slice_count in 0 to num_serial_bits-1 generate begin
        -- This places the first data in time on the right
        --DATA_IN_TO_DEVICE(slice_count*sys_w+sys_w-1 downto slice_count*sys_w) <=
        --  iserdes_q(num_serial_bits-slice_count-1);
        -- To place the first data in time on the left, use the
        --   following code, instead
         DATA_IN_TO_DEVICE(slice_count*sys_w+sys_w-1 downto slice_count*sys_w) <=
           iserdes_q(slice_count);
     end generate in_slices;
     
--     q1 <= iserdes_q(7);
--     q2 <= iserdes_q(6);
--     q3 <= iserdes_q(5);
--     q4 <= iserdes_q(4);
--     q5 <= iserdes_q(3);
--     q6 <= iserdes_q(2);
--     q7 <= iserdes_q(1);
--     q8 <= iserdes_q(0);


  end generate pins;






end xilinx;



