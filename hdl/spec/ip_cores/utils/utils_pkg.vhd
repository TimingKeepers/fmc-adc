--=============================================================================
-- @file utils_pkg.vhd
--=============================================================================
--! Standard library
library IEEE;
--library unisim;
--! Standard packages
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--use unisim.vcomponents.all;
--! Specific packages
-------------------------------------------------------------------------------
-- --
-- CERN, BE-CO-HT, 
-- --
-------------------------------------------------------------------------------
--
-- Unit name: 
--
--! @brief 
--!
--
--! @author Matthieu Cattin (matthieu dot cattin at cern dot ch)
--
--! @date 22\10\2009
--
--! @version v.0.1
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! None
--!
--! <b>References:</b>\n
--!
--!
--! <b>Modified by:</b>\n
--! Author:
-------------------------------------------------------------------------------
--! \n\n<b>Last changes:</b>\n
--! 22.10.2009    mcattin     Creation
--! 07.03.2011    mcattin     Fix bug in log2_ceil function
-------------------------------------------------------------------------------
--! @todo
--
-------------------------------------------------------------------------------


--=============================================================================
--! Package declaration for utils_pkg
--=============================================================================
package utils_pkg is

  -- Functions
  function log2_ceil(N : natural) return positive;

end utils_pkg;


--=============================================================================
--! Body declaration for utils_pkg
--=============================================================================
package body utils_pkg is

  --*****************************************************************************
  --! Function : Returns log of 2 of a natural number
  --*****************************************************************************
  function log2_ceil(N : natural) return positive is
  begin
    if N <= 2 then
      return 1;
    elsif N mod 2 = 0 then
      return 1 + log2_ceil(N/2);
    else
      return 1 + log2_ceil((N+1)/2);
    end if;
  end;

end utils_pkg;
