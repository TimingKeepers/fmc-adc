--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Top level entity for Simple PCIe FMC Carrier
-- http://www.ohwr.org/projects/spec
--------------------------------------------------------------------------------
--
-- unit name: Address decoder (addr_dec.vhd)
--
-- author: Theodor Stana (t.stana@cern.ch)
--
-- date of creation: 2011-09-21
--
-- version: 1.0
--
-- description: Top entity for LED control project
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=============================================================================
--  Entity declaration for address decoder
--=============================================================================
entity addr_dec is
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
end entity;
--=============================================================================

--=============================================================================
--  Architecture declaration for address decoder
--=============================================================================
architecture behavioral of addr_dec is

--=============================================================================
--  architecture begin
--=============================================================================
begin

  cyc_o(0) <= cyc_i when (adr_i = '0') else '0';
  cyc_o(1) <= cyc_i when (adr_i = '1') else '0';
  
  -- cyc_o(to_integer(unsigned(adr_i))) <= cyc_i;
  
  ack_o <= ack_i(0) when (adr_i = '0') else
           ack_i(1); --(to_integer(unsigned(adr_i));
  
  dat_o <= dat_i(31 downto 0) when (adr_i = '0') else
           dat_i(63 downto 32);
  
end architecture;
--=============================================================================
--  architecture end
--=============================================================================
