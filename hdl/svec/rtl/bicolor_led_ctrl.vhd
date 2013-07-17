--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Bi-color LED controller
-- http://www.ohwr.org/projects/svec
--------------------------------------------------------------------------------
--
-- unit name: bicolor_led_ctrl
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 11-07-2012
--
-- version: 1.0
--
-- description: Bi-color LED controller. It controls a matrix of bi-color LED.
--              The FPGA ouputs for the columns (C) are connected to buffers
--              and serial resistances and then to the LEDs. The FPGA outputs
--              for lines (L) are connected to tri-state buffers and the to
--              the LEDs. The FPGA outputs for lines output enable (L_OEN) are
--              connected to the output enable of the tri-state buffers.
--
--   Example with three lines and two columns:
--
--              |<refresh period>|
--
--   L1/L2/L3   __|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__|--|__
--
--   L1_OEN     -----|___________|-----|___________|-----|___________|-----|___________|--
--
--   L2_OEN     _____|-----|___________|-----|___________|-----|___________|-----|________
--
--   L3_OEN     ___________|-----|___________|-----|___________|-----|___________|-----|__
--
--   Cn         __|--|__|--|__|--|_________________|-----------------|--|__|--|__|--|__|--
--
--   LED Ln/Cn         OFF       |     color_1     |     color_2     |   both_colors   |
--
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
-- last changes: see log.
--------------------------------------------------------------------------------
-- TODO: - 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.bicolor_led_ctrl_pkg.all;


entity bicolor_led_ctrl is
  generic(
    g_NB_COLUMN    : natural := 4;
    g_NB_LINE      : natural := 2;
    g_CLK_FREQ     : natural := 125000000;  -- in Hz
    g_REFRESH_RATE : natural := 250         -- in Hz
    );
  port
    (
      rst_n_i : in std_logic;
      clk_i   : in std_logic;

      led_intensity_i : in std_logic_vector(6 downto 0);

      led_state_i : in std_logic_vector((g_NB_LINE * g_NB_COLUMN * 2) - 1 downto 0);

      column_o   : out std_logic_vector(g_NB_COLUMN - 1 downto 0);
      line_o     : out std_logic_vector(g_NB_LINE - 1 downto 0);
      line_oen_o : out std_logic_vector(g_NB_LINE - 1 downto 0)
      );
end bicolor_led_ctrl;



architecture rtl of bicolor_led_ctrl is

  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  constant c_REFRESH_CNT_INIT     : natural := natural(g_CLK_FREQ/(2 * g_NB_LINE * g_REFRESH_RATE)) - 1;
  constant c_REFRESH_CNT_NB_BITS  : natural := log2_ceil(c_REFRESH_CNT_INIT);
  constant c_LINE_OEN_CNT_NB_BITS : natural := log2_ceil(g_NB_LINE);


  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------
  signal refresh_rate_cnt   : unsigned(c_REFRESH_CNT_NB_BITS - 1 downto 0);
  signal refresh_rate       : std_logic;
  signal line_ctrl          : std_logic;
  signal intensity_ctrl_cnt : unsigned(c_REFRESH_CNT_NB_BITS - 1 downto 0);
  signal intensity_ctrl     : std_logic;
  signal line_oen_cnt       : unsigned(c_LINE_OEN_CNT_NB_BITS - 1 downto 0);
  signal line_oen           : std_logic_vector(2**c_LINE_OEN_CNT_NB_BITS - 1 downto 0);
  signal led_state          : std_logic_vector((g_NB_LINE * g_NB_COLUMN) -1 downto 0);


begin

  ------------------------------------------------------------------------------
  -- Refresh rate counter
  ------------------------------------------------------------------------------
  p_refresh_rate_cnt : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        refresh_rate_cnt <= (others => '0');
        refresh_rate     <= '0';
      elsif refresh_rate_cnt = 0 then
        refresh_rate_cnt <= to_unsigned(c_REFRESH_CNT_INIT, c_REFRESH_CNT_NB_BITS);
        refresh_rate     <= '1';
      else
        refresh_rate_cnt <= refresh_rate_cnt - 1;
        refresh_rate     <= '0';
      end if;
    end if;
  end process p_refresh_rate_cnt;


  ------------------------------------------------------------------------------
  -- Intensity control
  ------------------------------------------------------------------------------
  p_intensity_ctrl_cnt : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        intensity_ctrl_cnt <= (others => '0');
      elsif refresh_rate = '1' then
        intensity_ctrl_cnt <= to_unsigned(natural(c_REFRESH_CNT_INIT/100) * to_integer(unsigned(led_intensity_i)), c_REFRESH_CNT_NB_BITS);
      else
        intensity_ctrl_cnt <= intensity_ctrl_cnt - 1;
      end if;
    end if;
  end process p_intensity_ctrl_cnt;

  p_intensity_ctrl : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        intensity_ctrl <= '0';
      elsif refresh_rate = '1' then
        intensity_ctrl <= '1';
      elsif intensity_ctrl_cnt = 0 then
        intensity_ctrl <= '0';
      end if;
    end if;
  end process p_intensity_ctrl;


  ------------------------------------------------------------------------------
  -- Lines ouput
  ------------------------------------------------------------------------------
  p_line_ctrl : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        line_ctrl <= '0';
      elsif refresh_rate = '1' then
        line_ctrl <= not(line_ctrl);
      end if;
    end if;
  end process p_line_ctrl;

  f_line_o : for I in 0 to g_NB_LINE - 1 generate
    line_o(I) <= line_ctrl and intensity_ctrl;
  end generate f_line_o;

  ------------------------------------------------------------------------------
  -- Lines output enable
  ------------------------------------------------------------------------------
  p_line_oen_cnt : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        line_oen_cnt <= (others => '0');
      elsif line_ctrl = '1' and refresh_rate = '1' then
        if line_oen_cnt = 0 then
          line_oen_cnt <= to_unsigned(g_NB_LINE - 1, c_LINE_OEN_CNT_NB_BITS);
        else
          line_oen_cnt <= line_oen_cnt - 1;
        end if;
      end if;
    end if;
  end process p_line_oen_cnt;

  p_line_oen_decode : process(line_oen_cnt)
    variable v_onehot : std_logic_vector((2**line_oen_cnt'length)-1 downto 0);
    variable v_index  : integer range 0 to (2**line_oen_cnt'length)-1;
  begin
    v_onehot := (others => '0');
    v_index  := 0;
    for i in line_oen_cnt'range loop
      if (line_oen_cnt(i) = '1') then
        v_index := 2*v_index+1;
      else
        v_index := 2*v_index;
      end if;
    end loop;
    v_onehot(v_index) := '1';
    line_oen          <= v_onehot;
  end process p_line_oen_decode;

  line_oen_o <= line_oen(line_oen_o'left downto 0);


  ------------------------------------------------------------------------------
  -- Columns output
  ------------------------------------------------------------------------------
  f_led_state : for I in 0 to (g_NB_COLUMN * g_NB_LINE) - 1 generate
    led_state(I) <= '0' when led_state_i(2 * I + 1 downto 2 * I) = c_LED_RED else
                    '1'                               when led_state_i(2 * I + 1 downto 2 * I) = c_LED_GREEN else
                    (line_ctrl and intensity_ctrl)    when led_state_i(2 * I + 1 downto 2 * I) = c_LED_OFF   else
                    not(line_ctrl and intensity_ctrl) when led_state_i(2 * I + 1 downto 2 * I) = c_LED_RED_GREEN;
  end generate f_led_state;

  f_column_o : for C in 0 to g_NB_COLUMN - 1 generate
    column_o(C) <= led_state(g_NB_COLUMN * to_integer(line_oen_cnt) + C);
  end generate f_column_o;


end rtl;
