--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Variable saturation, signed data input and output (two's complement)
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: var_sat_s (var_sat_s.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 14-03-2013
--
-- version: 1.0
--
-- description: Variable saturation.
--              Latency = 1
--
--                           ________
--                          |        |
--              data_i ---->|saturate|--> data_o
--                          |________|
--                              ^
--                              |
--                            sat_i
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
-- TODO: - 
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


library UNISIM;
use UNISIM.vcomponents.all;

library UNIMACRO;
use UNIMACRO.vcomponents.all;


------------------------------------------------------------------------------
-- Entity declaration
------------------------------------------------------------------------------
entity var_sat_s is
  port (
    rst_n_i : in  std_logic;                      --! Reset (active low)
    clk_i   : in  std_logic;                      --! Clock
    sat_i   : in  std_logic_vector(14 downto 0);  --! Unsigned saturation value input
    data_i  : in  std_logic_vector(15 downto 0);  --! Signed data input (two's complement)
    data_o  : out std_logic_vector(15 downto 0)   --! Signed data output (two's complement)
    );
end entity var_sat_s;


------------------------------------------------------------------------------
-- Architecture declaration
------------------------------------------------------------------------------
architecture rtl of var_sat_s is

  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  constant c_one : signed(15 downto 0) := X"0001";

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------
  signal pos_sat : signed(15 downto 0);
  signal neg_sat : signed(15 downto 0);


begin

  pos_sat <= signed('0' & sat_i);
  neg_sat <= signed(not('0' & sat_i))+c_one;

  ------------------------------------------------------------------------------
  -- Saturate
  ------------------------------------------------------------------------------
  p_saturate : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        data_o <= (others => '0');
      elsif signed(data_i) >= pos_sat then
        data_o <= std_logic_vector(pos_sat);  -- saturate positive
      elsif signed(data_i) <= neg_sat then
        data_o <= std_logic_vector(neg_sat);  -- saturate negative
      else
        data_o <= data_i;
      end if;
    end if;
  end process p_saturate;


end architecture rtl;
