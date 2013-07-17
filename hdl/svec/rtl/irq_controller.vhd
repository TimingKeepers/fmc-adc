--------------------------------------------------------------------------------
-- CERN (BE-CO-HT)
-- IRQ controller
-- http://www.ohwr.org/projects/fmc-adc-100m14b4cha
--------------------------------------------------------------------------------
--
-- unit name: irq_controller (irq_controller.vhd)
--
-- author: Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 18-11-2011
--
-- version: 1.0
--
-- description: 
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


entity irq_controller is
  port (
    -- Clock, reset
    clk_i   : in std_logic;
    rst_n_i : in std_logic;

    -- Interrupt sources input, must be 1 clk_i tick long
    irq_src_p_i : in std_logic_vector(31 downto 0);

    -- IRQ pulse output
    irq_p_o : out std_logic;

    -- Wishbone interface
    wb_adr_i : in  std_logic_vector(1 downto 0);
    wb_dat_i : in  std_logic_vector(31 downto 0);
    wb_dat_o : out std_logic_vector(31 downto 0);
    wb_cyc_i : in  std_logic;
    wb_sel_i : in  std_logic_vector(3 downto 0);
    wb_stb_i : in  std_logic;
    wb_we_i  : in  std_logic;
    wb_ack_o : out std_logic
    );
end irq_controller;


architecture rtl of irq_controller is


  ------------------------------------------------------------------------------
  -- Components declaration
  ------------------------------------------------------------------------------
  component irq_controller_regs
    port (
      rst_n_i                   : in  std_logic;
      clk_sys_i                 : in  std_logic;
      wb_adr_i                  : in  std_logic_vector(1 downto 0);
      wb_dat_i                  : in  std_logic_vector(31 downto 0);
      wb_dat_o                  : out std_logic_vector(31 downto 0);
      wb_cyc_i                  : in  std_logic;
      wb_sel_i                  : in  std_logic_vector(3 downto 0);
      wb_stb_i                  : in  std_logic;
      wb_we_i                   : in  std_logic;
      wb_ack_o                  : out std_logic;
      wb_stall_o                  : out std_logic;
      irq_ctrl_multi_irq_o      : out std_logic_vector(31 downto 0);
      irq_ctrl_multi_irq_i      : in  std_logic_vector(31 downto 0);
      irq_ctrl_multi_irq_load_o : out std_logic;
      irq_ctrl_src_o            : out std_logic_vector(31 downto 0);
      irq_ctrl_src_i            : in  std_logic_vector(31 downto 0);
      irq_ctrl_src_load_o       : out std_logic;
      irq_ctrl_en_mask_o        : out std_logic_vector(31 downto 0)
      );
  end component irq_controller_regs;

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------
  signal irq_en_mask      : std_logic_vector(31 downto 0);
  signal irq_pending      : std_logic_vector(31 downto 0);
  signal irq_pending_d    : std_logic_vector(31 downto 0);
  signal irq_pending_re   : std_logic_vector(31 downto 0);
  signal irq_src_rst      : std_logic_vector(31 downto 0);
  signal irq_src_rst_en   : std_logic;
  signal multi_irq        : std_logic_vector(31 downto 0);
  signal multi_irq_rst    : std_logic_vector(31 downto 0);
  signal multi_irq_rst_en : std_logic;
  signal irq_p_or         : std_logic_vector(32 downto 0);


begin

  ------------------------------------------------------------------------------
  -- Wishbone interface to IRQ controller registers
  ------------------------------------------------------------------------------
  cmp_irq_controller_regs : irq_controller_regs
    port map(
      rst_n_i                   => rst_n_i,
      clk_sys_i                 => clk_i,
      wb_adr_i                  => wb_adr_i,
      wb_dat_i                  => wb_dat_i,
      wb_dat_o                  => wb_dat_o,
      wb_cyc_i                  => wb_cyc_i,
      wb_sel_i                  => wb_sel_i,
      wb_stb_i                  => wb_stb_i,
      wb_we_i                   => wb_we_i,
      wb_ack_o                  => wb_ack_o,
      wb_stall_o                => open,
      irq_ctrl_multi_irq_o      => multi_irq_rst,
      irq_ctrl_multi_irq_load_o => multi_irq_rst_en,
      irq_ctrl_multi_irq_i      => multi_irq,
      irq_ctrl_src_o            => irq_src_rst,
      irq_ctrl_src_i            => irq_pending,
      irq_ctrl_src_load_o       => irq_src_rst_en,
      irq_ctrl_en_mask_o        => irq_en_mask
      );

  ------------------------------------------------------------------------------
  -- Register interrupt sources
  -- IRQ is pending until a '1' is written to the corresponding bit
  ------------------------------------------------------------------------------
  p_irq_src : process (clk_i)
  begin
    if rising_edge(clk_i) then
      for I in 0 to irq_pending'length-1 loop
        if rst_n_i = '0' then
          irq_pending(I) <= '0';
        elsif irq_src_p_i(I) = '1' and irq_en_mask(I) = '1' then
          irq_pending(I) <= '1';
        elsif irq_src_rst_en = '1' and irq_src_rst(I) = '1' then
          irq_pending(I) <= '0';
        end if;
      end loop;  -- I
    end if;
  end process p_irq_src;

  ------------------------------------------------------------------------------
  -- Multiple interrupt detection
  -- Rise a flag if an interrupt occurs while an irq is still pending
  -- Write '1' to the flag to clear it
  ------------------------------------------------------------------------------
  p_multi_irq_detect : process (clk_i)
  begin
    if rising_edge(clk_i) then
      for I in 0 to multi_irq'length-1 loop
        if rst_n_i = '0' then
          multi_irq(I) <= '0';
        elsif irq_src_p_i(I) = '1' and irq_pending(I) = '1' then
          multi_irq(I) <= '1';
        elsif multi_irq_rst_en = '1' and multi_irq_rst(I) = '1' then
          multi_irq(I) <= '0';
        end if;
      end loop;  -- I
    end if;
  end process p_multi_irq_detect;

  ------------------------------------------------------------------------------
  -- Generate IRQ output pulse
  ------------------------------------------------------------------------------
  irq_p_or(0) <= '0';
  l_irq_out_pulse : for I in 0 to irq_src_p_i'length-1 generate
    irq_p_or(I+1) <= irq_p_or(I) or (irq_src_p_i(I) and irq_en_mask(I));
  end generate l_irq_out_pulse;

  p_irq_out_pulse : process (clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        irq_p_o <= '0';
      else
        irq_p_o <= irq_p_or(32);
      end if;
    end if;
  end process p_irq_out_pulse;


end rtl;
