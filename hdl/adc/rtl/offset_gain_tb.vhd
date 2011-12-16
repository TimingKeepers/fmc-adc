--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   11:48:27 02/05/2010
-- Design Name:
-- Module Name:   C:/mcattin/fpga_design/cvorb_cvorg/sources/offsetgain_tb.vhd
-- Project Name:  cvorg_v3
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

entity offsetgain_tb is
end offsetgain_tb;

architecture behavior of offsetgain_tb is

  -- Component Declaration for the Unit Under Test (UUT)

  component offset_gain
    port (
      rst_n_i  : in  std_logic;                      --! Reset (active low)
      clk_i    : in  std_logic;                      --! Clock
      offset_i : in  std_logic_vector(16 downto 0);  --! Signed offset input (two's complement)
      gain_i   : in  std_logic_vector(15 downto 0);  --! Unsigned gain input
      data_i   : in  std_logic_vector(15 downto 0);  --! Unsigned data input
      data_o   : out std_logic_vector(15 downto 0)   --! Unsigned data output
      );
  end component offset_gain;

  --Inputs
  signal rst_n_i  : std_logic                     := '0';
  signal clk_i    : std_logic                     := '0';
  signal offset_i : std_logic_vector(16 downto 0) := (others => '0');
  signal gain_i   : std_logic_vector(15 downto 0) := (others => '0');
  signal data_i   : std_logic_vector(15 downto 0) := (others => '0');

  --Outputs
  signal data_o : std_logic_vector(15 downto 0);

  -- Clock period definitions
  constant clk_i_period : time := 8 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : offset_gain port map (
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
    offset_i <= std_logic_vector(to_signed(0, 17));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_unsigned(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    data_i <= std_logic_vector(to_unsigned(1, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    data_i <= std_logic_vector(to_unsigned(3, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    data_i <= std_logic_vector(to_unsigned(32768, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 17));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_unsigned(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(10, 17));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_unsigned(65535, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-10, 17));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_unsigned(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(10, 17));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_unsigned(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 17));
    gain_i   <= std_logic_vector(to_unsigned(32000, 16));
    data_i   <= std_logic_vector(to_unsigned(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 17));
    gain_i   <= std_logic_vector(to_unsigned(34000, 16));
    data_i   <= std_logic_vector(to_unsigned(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(32768, 17));
    gain_i   <= std_logic_vector(to_unsigned(32768, 16));
    data_i   <= std_logic_vector(to_unsigned(32768, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-32768, 17));
    gain_i   <= std_logic_vector(to_unsigned(33768, 16));
    data_i   <= std_logic_vector(to_unsigned(0, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(-298, 17));
    gain_i   <= std_logic_vector(to_unsigned(32090, 16));
    data_i   <= std_logic_vector(to_unsigned(60857, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= std_logic_vector(to_signed(0, 17));
    gain_i   <= std_logic_vector(to_unsigned(16384, 16));
    data_i   <= std_logic_vector(to_unsigned(1000, 16));

    wait for 1 us;

    wait until rising_edge(clk_i);
--    offset_i <= "010000000000000";
    offset_i <= "01111111111111111";
    gain_i   <= X"8000";
    data_i   <= (others => '1');

    wait for 1 us;

    wait until rising_edge(clk_i);
    offset_i <= "10000000000000000";
--    offset_i <= "011111111111111";
    gain_i   <= X"8000";
    data_i   <= (others => '0');

    wait;
  end process;

end;
