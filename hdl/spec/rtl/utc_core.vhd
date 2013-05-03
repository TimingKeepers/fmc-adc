--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- UTC core
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: utc_core (utc_core.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 18-11-2011
--
-- version: 1.0
--
-- description: Implements a UTC seconds counter and a 125MHz system clock ticks
--              counter to time-tag trigger, acquisition start and stop events.
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

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


--library UNISIM;
--use UNISIM.vcomponents.all;


entity utc_core is
  port (
    -- Clock, reset
    clk_i   : in std_logic;             -- Must be 125MHz
    rst_n_i : in std_logic;

    -- Input pulses to time-tag
    trigger_p_i   : in std_logic;
    acq_start_p_i : in std_logic;
    acq_stop_p_i  : in std_logic;
    acq_end_p_i   : in std_logic;

    -- Wishbone interface
    wb_adr_i : in  std_logic_vector(4 downto 0);
    wb_dat_i : in  std_logic_vector(31 downto 0);
    wb_dat_o : out std_logic_vector(31 downto 0);
    wb_cyc_i : in  std_logic;
    wb_sel_i : in  std_logic_vector(3 downto 0);
    wb_stb_i : in  std_logic;
    wb_we_i  : in  std_logic;
    wb_ack_o : out std_logic
    );
end utc_core;


architecture rtl of utc_core is


  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component utc_core_regs
    port (
      rst_n_i                          : in  std_logic;
      clk_sys_i                        : in  std_logic;
      wb_adr_i                         : in  std_logic_vector(4 downto 0);
      wb_dat_i                         : in  std_logic_vector(31 downto 0);
      wb_dat_o                         : out std_logic_vector(31 downto 0);
      wb_cyc_i                         : in  std_logic;
      wb_sel_i                         : in  std_logic_vector(3 downto 0);
      wb_stb_i                         : in  std_logic;
      wb_we_i                          : in  std_logic;
      wb_ack_o                         : out std_logic;
      wb_stall_o                       : out std_logic;
      utc_core_seconds_o               : out std_logic_vector(31 downto 0);
      utc_core_seconds_i               : in  std_logic_vector(31 downto 0);
      utc_core_seconds_load_o          : out std_logic;
      utc_core_coarse_o                : out std_logic_vector(31 downto 0);
      utc_core_coarse_i                : in  std_logic_vector(31 downto 0);
      utc_core_coarse_load_o           : out std_logic;
      utc_core_trig_tag_meta_i         : in  std_logic_vector(31 downto 0);
      utc_core_trig_tag_seconds_i      : in  std_logic_vector(31 downto 0);
      utc_core_trig_tag_coarse_i       : in  std_logic_vector(31 downto 0);
      utc_core_trig_tag_fine_i         : in  std_logic_vector(31 downto 0);
      utc_core_acq_start_tag_meta_i    : in  std_logic_vector(31 downto 0);
      utc_core_acq_start_tag_seconds_i : in  std_logic_vector(31 downto 0);
      utc_core_acq_start_tag_coarse_i  : in  std_logic_vector(31 downto 0);
      utc_core_acq_start_tag_fine_i    : in  std_logic_vector(31 downto 0);
      utc_core_acq_stop_tag_meta_i     : in  std_logic_vector(31 downto 0);
      utc_core_acq_stop_tag_seconds_i  : in  std_logic_vector(31 downto 0);
      utc_core_acq_stop_tag_coarse_i   : in  std_logic_vector(31 downto 0);
      utc_core_acq_stop_tag_fine_i     : in  std_logic_vector(31 downto 0);
      utc_core_acq_end_tag_meta_i      : in  std_logic_vector(31 downto 0);
      utc_core_acq_end_tag_seconds_i   : in  std_logic_vector(31 downto 0);
      utc_core_acq_end_tag_coarse_i    : in  std_logic_vector(31 downto 0);
      utc_core_acq_end_tag_fine_i      : in  std_logic_vector(31 downto 0)
      );
  end component utc_core_regs;

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------
  signal utc_seconds               : std_logic_vector(31 downto 0);
  signal utc_seconds_cnt           : unsigned(31 downto 0);
  signal utc_seconds_load_value    : std_logic_vector(31 downto 0);
  signal utc_seconds_load_en       : std_logic;
  signal utc_coarse                : std_logic_vector(31 downto 0);
  signal utc_coarse_cnt            : unsigned(31 downto 0);
  signal utc_coarse_load_value     : std_logic_vector(31 downto 0);
  signal utc_coarse_load_en        : std_logic;
  signal utc_trig_tag_meta         : std_logic_vector(31 downto 0);
  signal utc_trig_tag_seconds      : std_logic_vector(31 downto 0);
  signal utc_trig_tag_coarse       : std_logic_vector(31 downto 0);
  signal utc_trig_tag_fine         : std_logic_vector(31 downto 0);
  signal utc_acq_start_tag_meta    : std_logic_vector(31 downto 0);
  signal utc_acq_start_tag_seconds : std_logic_vector(31 downto 0);
  signal utc_acq_start_tag_coarse  : std_logic_vector(31 downto 0);
  signal utc_acq_start_tag_fine    : std_logic_vector(31 downto 0);
  signal utc_acq_stop_tag_meta     : std_logic_vector(31 downto 0);
  signal utc_acq_stop_tag_seconds  : std_logic_vector(31 downto 0);
  signal utc_acq_stop_tag_coarse   : std_logic_vector(31 downto 0);
  signal utc_acq_stop_tag_fine     : std_logic_vector(31 downto 0);
  signal utc_acq_end_tag_meta      : std_logic_vector(31 downto 0);
  signal utc_acq_end_tag_seconds   : std_logic_vector(31 downto 0);
  signal utc_acq_end_tag_coarse    : std_logic_vector(31 downto 0);
  signal utc_acq_end_tag_fine      : std_logic_vector(31 downto 0);

  signal local_pps : std_logic;



begin

  ------------------------------------------------------------------------------
  -- Wishbone interface to UTC core registers
  ------------------------------------------------------------------------------
  cmp_utc_core_regs : utc_core_regs
    port map(
      rst_n_i                          => rst_n_i,
      clk_sys_i                        => clk_i,
      wb_adr_i                         => wb_adr_i,
      wb_dat_i                         => wb_dat_i,
      wb_dat_o                         => wb_dat_o,
      wb_cyc_i                         => wb_cyc_i,
      wb_sel_i                         => wb_sel_i,
      wb_stb_i                         => wb_stb_i,
      wb_we_i                          => wb_we_i,
      wb_ack_o                         => wb_ack_o,
      wb_stall_o                       => open,
      utc_core_seconds_o               => utc_seconds_load_value,
      utc_core_seconds_i               => utc_seconds,
      utc_core_seconds_load_o          => utc_seconds_load_en,
      utc_core_coarse_o                => utc_coarse_load_value,
      utc_core_coarse_i                => utc_coarse,
      utc_core_coarse_load_o           => utc_coarse_load_en,
      utc_core_trig_tag_meta_i         => utc_trig_tag_meta,
      utc_core_trig_tag_seconds_i      => utc_trig_tag_seconds,
      utc_core_trig_tag_coarse_i       => utc_trig_tag_coarse,
      utc_core_trig_tag_fine_i         => utc_trig_tag_fine,
      utc_core_acq_start_tag_meta_i    => utc_acq_start_tag_meta,
      utc_core_acq_start_tag_seconds_i => utc_acq_start_tag_seconds,
      utc_core_acq_start_tag_coarse_i  => utc_acq_start_tag_coarse,
      utc_core_acq_start_tag_fine_i    => utc_acq_start_tag_fine,
      utc_core_acq_stop_tag_meta_i     => utc_acq_stop_tag_meta,
      utc_core_acq_stop_tag_seconds_i  => utc_acq_stop_tag_seconds,
      utc_core_acq_stop_tag_coarse_i   => utc_acq_stop_tag_coarse,
      utc_core_acq_stop_tag_fine_i     => utc_acq_stop_tag_fine,
      utc_core_acq_end_tag_meta_i      => utc_acq_end_tag_meta,
      utc_core_acq_end_tag_seconds_i   => utc_acq_end_tag_seconds,
      utc_core_acq_end_tag_coarse_i    => utc_acq_end_tag_coarse,
      utc_core_acq_end_tag_fine_i      => utc_acq_end_tag_fine
      );

  ------------------------------------------------------------------------------
  -- UTC seconds counter
  ------------------------------------------------------------------------------
  p_utc_seconds_cnt : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        utc_seconds_cnt <= (others => '0');
      elsif utc_seconds_load_en = '1' then
        utc_seconds_cnt <= unsigned(utc_seconds_load_value);
      elsif local_pps = '1' then
        utc_seconds_cnt <= utc_seconds_cnt + 1;
      end if;
    end if;
  end process p_utc_seconds_cnt;

  utc_seconds <= std_logic_vector(utc_seconds_cnt);

  ------------------------------------------------------------------------------
  -- UTC 125MHz clock ticks counter
  ------------------------------------------------------------------------------
  p_utc_coarse_cnt : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        utc_coarse_cnt <= (others => '0');
        local_pps      <= '0';
      elsif utc_coarse_load_en = '1' then
        utc_coarse_cnt <= unsigned(utc_coarse_load_value);
        local_pps      <= '0';
      elsif utc_coarse_cnt = to_unsigned(124999999, utc_coarse_cnt'length) then
        utc_coarse_cnt <= (others => '0');
        local_pps      <= '1';
      else
        utc_coarse_cnt <= utc_coarse_cnt + 1;
        local_pps      <= '0';
      end if;
    end if;
  end process p_utc_coarse_cnt;

  utc_coarse <= std_logic_vector(utc_coarse_cnt);

  ------------------------------------------------------------------------------
  -- Last trigger event time-tag
  ------------------------------------------------------------------------------
  p_trig_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        utc_trig_tag_seconds <= (others => '0');
        utc_trig_tag_coarse  <= (others => '0');
        utc_trig_tag_fine    <= (others => '0');
      elsif trigger_p_i = '1' then
        utc_trig_tag_seconds <= utc_seconds;
        utc_trig_tag_coarse  <= utc_coarse;
      end if;
    end if;
  end process p_trig_tag;

  utc_trig_tag_meta <= X"00000000";

  ------------------------------------------------------------------------------
  -- Last acquisition start event time-tag
  ------------------------------------------------------------------------------
  p_acq_start_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        utc_acq_start_tag_seconds <= (others => '0');
        utc_acq_start_tag_coarse  <= (others => '0');
        utc_acq_start_tag_fine    <= (others => '0');
      elsif acq_start_p_i = '1' then
        utc_acq_start_tag_seconds <= utc_seconds;
        utc_acq_start_tag_coarse  <= utc_coarse;
      end if;
    end if;
  end process p_acq_start_tag;

  utc_acq_start_tag_meta <= X"00000000";

  ------------------------------------------------------------------------------
  -- Last acquisition stop event time-tag
  ------------------------------------------------------------------------------
  p_acq_stop_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        utc_acq_stop_tag_seconds <= (others => '0');
        utc_acq_stop_tag_coarse  <= (others => '0');
        utc_acq_stop_tag_fine    <= (others => '0');
      elsif acq_stop_p_i = '1' then
        utc_acq_stop_tag_seconds <= utc_seconds;
        utc_acq_stop_tag_coarse  <= utc_coarse;
      end if;
    end if;
  end process p_acq_stop_tag;

  utc_acq_stop_tag_meta <= X"00000000";

  ------------------------------------------------------------------------------
  -- Last acquisition end event time-tag
  ------------------------------------------------------------------------------
  p_acq_end_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        utc_acq_end_tag_seconds <= (others => '0');
        utc_acq_end_tag_coarse  <= (others => '0');
        utc_acq_end_tag_fine    <= (others => '0');
      elsif acq_end_p_i = '1' then
        utc_acq_end_tag_seconds <= utc_seconds;
        utc_acq_end_tag_coarse  <= utc_coarse;
      end if;
    end if;
  end process p_acq_end_tag;

  utc_acq_end_tag_meta <= X"00000000";


end rtl;
