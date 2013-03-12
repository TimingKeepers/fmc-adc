library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.wishbone_pkg.all;

package sdb_meta_pkg is

  ------------------------------------------------------------------------------
  -- Meta-information sdb records
  ------------------------------------------------------------------------------

  -- Top module repository url
  constant c_REPO_URL : t_sdb_repo_url := (
    -- url (string, 63 char)
    repo_url => "git://ohwr.org/fmc-projects/fmc-adc-100m14b4cha.git            ");

  -- Synthesis informations
  constant c_SYNTHESIS : t_sdb_synthesis := (
    -- Top module name (string, 16 char)
    syn_module_name  => "spec_top_fmc_adc",
    -- Commit ID (hex string, 128-bit = 32 char)
    -- git log -1 --format="%H" | cut -c1-32
    syn_commit_id    => "baa41197a02acc5cbdfbc5c893849b40",
    -- Synthesis tool name (string, 8 char)
    syn_tool_name    => "ISE     ",
    -- Synthesis tool version (bcd encoded, 32-bit)
    syn_tool_version => x"00000133",
    -- Synthesis date (bcd encoded, 32-bit)
    syn_date         => x"20130312",
    -- Synthesised by (string, 15 char)
    syn_username     => "mcattin        ");

  -- Integration record
  constant c_INTEGRATION : t_sdb_integration := (
    product     => (
      vendor_id => x"000000000000CE42",  -- CERN
      device_id => x"47c786a2",          -- echo "spec_fmc-adc-100m14b4cha" | md5sum | cut -c1-8
      version   => x"00010000",          -- bcd encoded, [31:16] = major, [15:0] = minor
      date      => x"20130312",          -- yyyymmdd
      name      => "spec_fmcadc100m14b "));


end sdb_meta_pkg;


package body sdb_meta_pkg is
end sdb_meta_pkg;
