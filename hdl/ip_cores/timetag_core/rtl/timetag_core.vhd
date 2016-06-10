--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Time-tagging core
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: timetag_core (timetag_core.vhd)
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
use work.timetag_core_pkg.all;

--library UNISIM;
--use UNISIM.vcomponents.all;


entity timetag_core is
  port (
    -- Clock, reset
    clk_i   : in std_logic;             -- Must be 125MHz
    rst_n_i : in std_logic;

    -- Input pulses to time-tag
    trigger_p_i   : in std_logic;
    acq_start_p_i : in std_logic;
    acq_stop_p_i  : in std_logic;
    acq_end_p_i   : in std_logic;

    -- Trigger time-tag output
    trig_tag_o : out t_timetag;

    -- Wishbone interface
    wb_adr_i : in  std_logic_vector(4 downto 0);
    wb_dat_i : in  std_logic_vector(31 downto 0);
    wb_dat_o : out std_logic_vector(31 downto 0);
    wb_cyc_i : in  std_logic;
    wb_sel_i : in  std_logic_vector(3 downto 0);
    wb_stb_i : in  std_logic;
    wb_we_i  : in  std_logic;
    wb_ack_o : out std_logic;
    
    tm_tai_i    :   in  std_logic_vector(39 downto 0);
    tm_cycles_i :   in  std_logic_vector(27 downto 0)
    );
end timetag_core;


architecture rtl of timetag_core is


  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component timetag_core_regs
    port (
      rst_n_i                              : in  std_logic;
      clk_sys_i                            : in  std_logic;
      wb_adr_i                             : in  std_logic_vector(4 downto 0);
      wb_dat_i                             : in  std_logic_vector(31 downto 0);
      wb_dat_o                             : out std_logic_vector(31 downto 0);
      wb_cyc_i                             : in  std_logic;
      wb_sel_i                             : in  std_logic_vector(3 downto 0);
      wb_stb_i                             : in  std_logic;
      wb_we_i                              : in  std_logic;
      wb_ack_o                             : out std_logic;
      wb_stall_o                           : out std_logic;
      timetag_core_seconds_o               : out std_logic_vector(31 downto 0);
      timetag_core_seconds_i               : in  std_logic_vector(31 downto 0);
      timetag_core_seconds_load_o          : out std_logic;
      timetag_core_coarse_o                : out std_logic_vector(31 downto 0);
      timetag_core_coarse_i                : in  std_logic_vector(31 downto 0);
      timetag_core_coarse_load_o           : out std_logic;
      timetag_core_trig_tag_meta_i         : in  std_logic_vector(31 downto 0);
      timetag_core_trig_tag_seconds_i      : in  std_logic_vector(31 downto 0);
      timetag_core_trig_tag_coarse_i       : in  std_logic_vector(31 downto 0);
      timetag_core_trig_tag_fine_i         : in  std_logic_vector(31 downto 0);
      timetag_core_acq_start_tag_meta_i    : in  std_logic_vector(31 downto 0);
      timetag_core_acq_start_tag_seconds_i : in  std_logic_vector(31 downto 0);
      timetag_core_acq_start_tag_coarse_i  : in  std_logic_vector(31 downto 0);
      timetag_core_acq_start_tag_fine_i    : in  std_logic_vector(31 downto 0);
      timetag_core_acq_stop_tag_meta_i     : in  std_logic_vector(31 downto 0);
      timetag_core_acq_stop_tag_seconds_i  : in  std_logic_vector(31 downto 0);
      timetag_core_acq_stop_tag_coarse_i   : in  std_logic_vector(31 downto 0);
      timetag_core_acq_stop_tag_fine_i     : in  std_logic_vector(31 downto 0);
      timetag_core_acq_end_tag_meta_i      : in  std_logic_vector(31 downto 0);
      timetag_core_acq_end_tag_seconds_i   : in  std_logic_vector(31 downto 0);
      timetag_core_acq_end_tag_coarse_i    : in  std_logic_vector(31 downto 0);
      timetag_core_acq_end_tag_fine_i      : in  std_logic_vector(31 downto 0)
      );
  end component timetag_core_regs;

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  constant c_TRIG_TAG_META      : std_logic_vector(31 downto 0) := x"6fc8ad2d";
  constant c_ACQ_START_TAG_META : std_logic_vector(31 downto 0) := x"0d7c7c76";
  constant c_ACQ_STOP_TAG_META  : std_logic_vector(31 downto 0) := x"2b4e09ff";
  constant c_ACQ_END_TAG_META   : std_logic_vector(31 downto 0) := x"7f644cd2";

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------
  signal timetag_seconds            : std_logic_vector(31 downto 0);
  signal timetag_seconds_cnt        : unsigned(31 downto 0);
  signal timetag_seconds_load_value : std_logic_vector(31 downto 0);
  signal timetag_seconds_load_en    : std_logic;
  signal timetag_coarse             : std_logic_vector(31 downto 0);
  signal timetag_coarse_cnt         : unsigned(31 downto 0);
  signal timetag_coarse_load_value  : std_logic_vector(31 downto 0);
  signal timetag_coarse_load_en     : std_logic;
  signal trig_tag                   : t_timetag;
  signal acq_start_tag              : t_timetag;
  signal acq_stop_tag               : t_timetag;
  signal acq_end_tag                : t_timetag;

  signal local_pps : std_logic;



begin

  ------------------------------------------------------------------------------
  -- Wishbone interface to UTC core registers
  ------------------------------------------------------------------------------
  cmp_timetag_core_regs : timetag_core_regs
    port map(
      rst_n_i                              => rst_n_i,
      clk_sys_i                            => clk_i,
      wb_adr_i                             => wb_adr_i,
      wb_dat_i                             => wb_dat_i,
      wb_dat_o                             => wb_dat_o,
      wb_cyc_i                             => wb_cyc_i,
      wb_sel_i                             => wb_sel_i,
      wb_stb_i                             => wb_stb_i,
      wb_we_i                              => wb_we_i,
      wb_ack_o                             => wb_ack_o,
      wb_stall_o                           => open,
      timetag_core_seconds_o               => timetag_seconds_load_value,
      timetag_core_seconds_i               => timetag_seconds,
      timetag_core_seconds_load_o          => timetag_seconds_load_en,
      timetag_core_coarse_o                => timetag_coarse_load_value,
      timetag_core_coarse_i                => timetag_coarse,
      timetag_core_coarse_load_o           => timetag_coarse_load_en,
      timetag_core_trig_tag_meta_i         => trig_tag.meta,
      timetag_core_trig_tag_seconds_i      => trig_tag.seconds,
      timetag_core_trig_tag_coarse_i       => trig_tag.coarse,
      timetag_core_trig_tag_fine_i         => trig_tag.fine,
      timetag_core_acq_start_tag_meta_i    => acq_start_tag.meta,
      timetag_core_acq_start_tag_seconds_i => acq_start_tag.seconds,
      timetag_core_acq_start_tag_coarse_i  => acq_start_tag.coarse,
      timetag_core_acq_start_tag_fine_i    => acq_start_tag.fine,
      timetag_core_acq_stop_tag_meta_i     => acq_stop_tag.meta,
      timetag_core_acq_stop_tag_seconds_i  => acq_stop_tag.seconds,
      timetag_core_acq_stop_tag_coarse_i   => acq_stop_tag.coarse,
      timetag_core_acq_stop_tag_fine_i     => acq_stop_tag.fine,
      timetag_core_acq_end_tag_meta_i      => acq_end_tag.meta,
      timetag_core_acq_end_tag_seconds_i   => acq_end_tag.seconds,
      timetag_core_acq_end_tag_coarse_i    => acq_end_tag.coarse,
      timetag_core_acq_end_tag_fine_i      => acq_end_tag.fine
      );

  ------------------------------------------------------------------------------
  -- UTC seconds counter
  ------------------------------------------------------------------------------
  p_timetag_seconds_cnt : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        timetag_seconds_cnt <= (others => '0');
      elsif timetag_seconds_load_en = '1' then
        timetag_seconds_cnt <= unsigned(timetag_seconds_load_value);
      elsif local_pps = '1' then
        timetag_seconds_cnt <= timetag_seconds_cnt + 1;
      end if;
    end if;
  end process p_timetag_seconds_cnt;

  timetag_seconds <= tm_tai_i(31 downto 0); --std_logic_vector(timetag_seconds_cnt);

  ------------------------------------------------------------------------------
  -- UTC 62.5MHz clock ticks counter
  ------------------------------------------------------------------------------
  p_timetag_coarse_cnt : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        timetag_coarse_cnt <= (others => '0');
        local_pps          <= '0';
      elsif timetag_coarse_load_en = '1' then
        timetag_coarse_cnt <= unsigned(timetag_coarse_load_value);
        local_pps          <= '0';
      elsif timetag_coarse_cnt = to_unsigned(62499999, timetag_coarse_cnt'length) then
        timetag_coarse_cnt <= (others => '0');
        local_pps          <= '1';
      else
        timetag_coarse_cnt <= timetag_coarse_cnt + 1;
        local_pps          <= '0';
      end if;
    end if;
  end process p_timetag_coarse_cnt;

  timetag_coarse <= "0000" & tm_cycles_i; --std_logic_vector(timetag_coarse_cnt);

  ------------------------------------------------------------------------------
  -- Last trigger event time-tag
  ------------------------------------------------------------------------------
  p_trig_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        trig_tag.seconds <= (others => '0');
        trig_tag.coarse  <= (others => '0');
        trig_tag.fine    <= (others => '0');
      elsif trigger_p_i = '1' then
        trig_tag.seconds <= timetag_seconds;
        trig_tag.coarse  <= timetag_coarse;
      end if;
    end if;
  end process p_trig_tag;

  trig_tag.meta <= c_TRIG_TAG_META;
  trig_tag_o    <= trig_tag;

  ------------------------------------------------------------------------------
  -- Last acquisition start event time-tag
  ------------------------------------------------------------------------------
  p_acq_start_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        acq_start_tag.seconds <= (others => '0');
        acq_start_tag.coarse  <= (others => '0');
        acq_start_tag.fine    <= (others => '0');
      elsif acq_start_p_i = '1' then
        acq_start_tag.seconds <= timetag_seconds;
        acq_start_tag.coarse  <= timetag_coarse;
      end if;
    end if;
  end process p_acq_start_tag;

  acq_start_tag.meta <= c_ACQ_START_TAG_META;

  ------------------------------------------------------------------------------
  -- Last acquisition stop event time-tag
  ------------------------------------------------------------------------------
  p_acq_stop_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        acq_stop_tag.seconds <= (others => '0');
        acq_stop_tag.coarse  <= (others => '0');
        acq_stop_tag.fine    <= (others => '0');
      elsif acq_stop_p_i = '1' then
        acq_stop_tag.seconds <= timetag_seconds;
        acq_stop_tag.coarse  <= timetag_coarse;
      end if;
    end if;
  end process p_acq_stop_tag;

  acq_stop_tag.meta <= c_ACQ_STOP_TAG_META;

  ------------------------------------------------------------------------------
  -- Last acquisition end event time-tag
  ------------------------------------------------------------------------------
  p_acq_end_tag : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        acq_end_tag.seconds <= (others => '0');
        acq_end_tag.coarse  <= (others => '0');
        acq_end_tag.fine    <= (others => '0');
      elsif acq_end_p_i = '1' then
        acq_end_tag.seconds <= timetag_seconds;
        acq_end_tag.coarse  <= timetag_coarse;
      end if;
    end if;
  end process p_acq_end_tag;

  acq_end_tag.meta <= c_ACQ_END_TAG_META;


end rtl;
