--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- Top level entity for Simple PCIe FMC Carrier
-- http://www.ohwr.org/projects/spec
--------------------------------------------------------------------------------
--
-- unit name: LED control (led_ctrl.vhd)
--
-- author: Theodor Stana (t.stana@cern.ch)
--
-- date of creation: 2011-09-14
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--=============================================================================
--  Entity declaration for LED control
--=============================================================================
entity led_ctrl is
    Port (
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
end led_ctrl;
--=============================================================================

--=============================================================================
--  Architecture declaration for leds_sm
--=============================================================================
architecture behavioral of led_ctrl is
  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  signal s_ctrl_reg : std_logic_vector(1 downto 0);
  -- signal s_adr      : std_logic;
  signal s_dat      : std_logic;
  signal s_irq      : std_logic_vector(1 downto 0);
  
--=============================================================================
--  architecture begin
--=============================================================================
begin
 
  -----------------------------------------------------------------------------
  -- Input and output logic
  -----------------------------------------------------------------------------
  
  -- output logic
  leds_o                <= s_ctrl_reg;
  wb_dat_o              <= s_dat;  
  irq_o                 <= s_irq;

  -----------------------------------------------------------------------------
  -- WISHBONE registers process
  -----------------------------------------------------------------------------
  p_wb_reg: process (clk_i, rst_i) is
  begin
    if rising_edge(clk_i) then
      if (rst_i = '1') then
        wb_ack_o   <= '0';
        s_dat      <= '0';
        s_ctrl_reg <= "00";
        s_irq      <= "00";
      else
        wb_ack_o <= '0';
        s_irq    <= "00";
        if (wb_stb_i = '1') and (wb_cyc_i = '1') then
          wb_ack_o   <= '1';
          if (wb_we_i = '1') then
            -- s_irq <= '1'; -- IRQ on write to any of the registers
            if (wb_adr_i = '0') then
              s_ctrl_reg(0) <= wb_dat_i;
              s_irq(0)      <= '1';
            else
              s_ctrl_reg(1) <= wb_dat_i;
              s_irq(1)      <= '1';
            end if;
          else
            if (wb_adr_i = '0') then
              s_dat <= s_ctrl_reg(0);
            else
              s_dat <= s_ctrl_reg(1);
            end if;
          end if;
        end if;
      end if;
    end if;
  end process p_wb_reg;
  -----------------------------------------------------------------------------
    
end behavioral;
--==================================================================================
--  architecture end
--==================================================================================

