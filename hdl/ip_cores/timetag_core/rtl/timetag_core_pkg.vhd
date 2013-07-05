--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Timetag core package
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: timetag_core_pkg.vhd (timetag_core_pkg.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 05-07-2013
--
-- version: 1.0
--
-- description: Package for timetag core
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

package timetag_core_pkg is

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------


  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component timetag_core
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
end component timetag_core;


end timetag_core_pkg;

package body timetag_core_pkg is



end timetag_core_pkg;
