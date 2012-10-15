----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:01:04 09/11/2012 
-- Design Name: 
-- Module Name:    leds_sm - Behavioral 
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

--==================================================================================
--  Entity declaration for LEDs state machine
--==================================================================================
entity leds_sm is
    Port 
    ( 
      -- global input signals
      clk_i   : in   STD_LOGIC;
      reset_i : in   STD_LOGIC;
      
      -- global output signals
      led1a_o : out  STD_LOGIC; -- LED1A, '1' = on
                                --        '0' = off
      led1b_o : out  STD_LOGIC  -- LED1B, '1' = on
                                --        '0' = off
    );
end leds_sm;
--==================================================================================

----==================================================================================
----  Architecture declaration for leds_sm
----==================================================================================
architecture behavioral of leds_sm is
  signal s_cnt : std_logic_vector(1 downto 0) := (others => '0');
  
----==================================================================================
----  architecture begin
----==================================================================================
begin
  
  ----------------------------------------------------------------
  -- Entity input and output logic
  ----------------------------------------------------------------
  led1a_o <= s_cnt(0);
  led1b_o <= s_cnt(1);
  ----------------------------------------------------------------
  
  ----------------------------------------------------------------
  -- Counter process
  ----------------------------------------------------------------
  p_count: process (clk_i, reset_i)
  begin
    if (reset_i = '1') then
      s_cnt <= "00";
    elsif rising_edge(clk_i) then
      s_cnt <= s_cnt + 1;
    end if;
  end process p_count;
  ----------------------------------------------------------------
  
end;
----==================================================================================
----  architecture end
----==================================================================================










----==================================================================================
----  Architecture declaration for leds_sm
----==================================================================================
--architecture behavioral of leds_sm is
--
---------------------------------------------------------------------
---- LED state machine type and signal declaration
---------------------------------------------------------------------
--  type t_state_mach is (ST_IDLE, ST_LED1A, ST_LED1B);
--  
--  signal s_state_pres : t_state_mach;
---------------------------------------------------------------------
--
---------------------------------------------------------------------
---- Internal signals for entity outputs
---------------------------------------------------------------------
--  signal s_led1a, s_led1b : std_logic;
---------------------------------------------------------------------
--
--    
----==================================================================================
----  architecture begin
----==================================================================================
--begin
--
--  ----------------------------------------------------------------
--  -- Entity input and output logic
--  ----------------------------------------------------------------
--  led1a_o <= s_led1a;
--  led1b_o <= s_led1b;
--  ----------------------------------------------------------------
--
--  ----------------------------------------------------------------
--  -- State logic for LED FSM
--  ----------------------------------------------------------------
--  fsm_proc: process (reset_i, clk_i)
--  begin
--  
--    if (reset_i = '1') then
--      s_state_pres <= ST_IDLE;
--      
--    elsif rising_edge(clk_i) then
--      
--      case s_state_pres is
--        
--        when ST_IDLE =>
--          s_state_pres <= ST_LED1A;
--          
--        when ST_LED1A =>
--          s_state_pres <= ST_LED1B;
--          
--        when ST_LED1B =>
--          s_state_pres <= ST_IDLE;
--          
--        when others =>
--          s_state_pres <= ST_IDLE;
--          
--      end case;
--      
--    end if;
--    
--  end process fsm_proc;
--  ----------------------------------------------------------------
--
--  ----------------------------------------------------------------
--  -- Output logic for LED FSM
--  ----------------------------------------------------------------
--  fsm_proc: process (reset_i, clk_i)
--  begin
--  
--    if (reset_i = '1') then
--      s_led1a      <= '0';
--      s_led1b      <= '0';
--      
--    elsif rising_edge(clk_i) then
--      
--      case s_state_pres is
--        
--        when ST_IDLE =>
--          s_led1a <= '0';
--          s_led1b <= '0';
--          
--        when ST_LED1A =>
--          s_led1a <= '1';
--          s_led1b <= '0';
--          
--        when ST_LED1B =>
--          s_led1a <= '0';
--          s_led1b <= '1';
--          
--        when others =>
--          s_led1a <= '1';
--          s_led1b <= '1';
--          
--      end case;
--      
--    end if;
--    
--  end process fsm_proc;
--  ----------------------------------------------------------------
--
--end Behavioral;
----==================================================================================
----  architecture end
----==================================================================================

