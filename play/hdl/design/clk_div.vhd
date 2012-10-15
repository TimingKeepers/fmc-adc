----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:07 09/11/2012 
-- Design Name: 
-- Module Name:    clk_div - behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_div is
--  generic
--  (
--    g_DIV_RATE : integer := 1
--  );
  Port 
  ( 
    clk_i   : in  STD_LOGIC;
    reset_i : in  std_logic;
    clk_o   : out STD_LOGIC
  );
end clk_div;

architecture behavioral of clk_div is
  signal s_div_cnt : std_logic_vector(32 downto 0) := (others => '0');
  --signal s_clk_o   : 
  
begin
  
  clk_o <= s_div_cnt(23);
  
  p_div_count: process (reset_i, clk_i)
  begin
    if (reset_i = '1') then
      s_div_cnt <= (others => '0');
    elsif rising_edge(clk_i) then
      s_div_cnt <= s_div_cnt + 1;
    end if;
  end process p_div_count;

end behavioral;

