library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package sdb_meta_pkg is

  ------------------------------------------------------------------------------
  -- Meta-information sdb records
  ------------------------------------------------------------------------------

  -- Top module repository url (64 bytes)
  constant c_REPO_URL : t_sdb_repo_url := (
    -- url (utf-8, 63 bytes)
    repo_url => "git://ohwr.org/fmc-projects/fmc-adc-100m14b4cha.git            ");

  -- Synthesis informations (64 bytes)
  constant c_SYNTHESIS : t_sdb_synthesis := (
    -- Top module name (utf-8, 16 bytes)
    syn_module_name  => "spec_top_fmc_adc",
    -- Commit ID (hex string, 128-bit = 32 char)
    syn_commit_id    => "150b83db8fa9e0ff9050166b7695ee9a",
    -- Synthesis tool name (utf-8, 8 bytes)
    syn_tool_name    => "ISE     ",
    -- Synthesis tool version (bcd encoded, 32-bit)
    syn_tool_version => x"00000133",
    -- Synthesis date (bcd encoded, 32-bit)
    syn_date         => x"20130307",
    -- Synthesised by (utf-8, 15 bytes)
    syn_username     => "mcattin        ");

end sdb_meta_pkg;


package body sdb_meta_pkg is
end sdb_meta_pkg;
