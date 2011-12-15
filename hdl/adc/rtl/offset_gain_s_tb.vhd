--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   11:48:27 02/05/2010
-- Design Name:
-- Module Name:   offset_gain_s_tb.vhd
-- Project Name:
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: offsetgain
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity offset_gain_s_tb is
end offset_gain_s_tb;

architecture behavior of offset_gain_s_tb is

  -- Component Declaration for the Unit Under Test (UUT)

  component offset_gain_s
    port (
      rst_n_i  : in  std_logic;                      --! Reset (active low)
      clk_i    : in  std_logic;                      --! Clock
      offset_i : in  std_logic_vector(15 downto 0);  --! Signed offset input (two's complement)
      gain_i   : in  std_logic_vector(15 downto 0);  --! Unsigned gain input
      data_i   : in  std_logic_vector(15 downto 0);  --! Unsigned data input
      data_o   : out std_logic_vector(15 downto 0)   --! Unsigned data output
      );
  end component offset_gain_s;

  --Inputs
  signal rst_n_i  : std_logic                     := '0';
  signal clk_i    : std_logic                     := '0';
  signal offset_i : std_logic_vector(15 downto 0) := (others => '0');
  signal gain_i   : std_logic_vector(15 downto 0) := (others => '0');
  signal data_i   : std_logic_vector(15 downto 0) := (others => '0');

  --Outputs
  signal data_o : std_logic_vector(15 downto 0);

  -- Clock period definitions
  constant clk_i_period : time := 8 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : offset_gain_s port map (
    rst_n_i  => rst_n_i,
    clk_i    => clk_i,
    offset_i => offset_i,
    gain_i   => gain_i,
    data_i   => data_i,
    data_o   => data_o
    );

  -- Clock process definitions
  clk_i_process : process
  begin
    clk_i <= '0';
    wait for clk_i_period/2;
    clk_i <= '1';
    wait for clk_i_period/2;
  end process;


  -- Stimulus process
  stim_proc : process
  begin
    -- hold reset state
    rst_n_i <= '0';
    wait for 10 us;
    rst_n_i <= '1';

    wait for clk_i_period*10;

    -- insert stimulus here

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(1000, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));  -- gain = 1
    data_i   <= std_logic_vector(to_signed(32700, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-1000, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 1
    data_i   <= std_logic_vector(to_signed(-32700, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(10000, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 1
    data_i   <= std_logic_vector(to_signed(32700, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10000, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 1
    data_i   <= std_logic_vector(to_signed(-32700, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(0, 16));
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));  -- gain = 1
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(10, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_signed(-1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(10, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 16));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(-1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(10, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(10, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(-1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(-1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 16));
    gain_i   <= std_logic_vector(to_unsigned(49152, 16));  -- gain = 1.5
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 0.5
    data_i   <= std_logic_vector(to_signed(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 0.5
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 0.5
    data_i   <= std_logic_vector(to_signed(-1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 0.5
    data_i   <= std_logic_vector(to_signed(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 16));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));  -- gain = 0.5
    data_i   <= std_logic_vector(to_signed(-1000, 16));

    wait for 1 us;

    wait;
  end process;

end;
