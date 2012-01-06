library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

--library std_developerskit;
--use std_developerskit.std_iopak.all;

use work.util.all;
use work.textutil.all;


--==========================================================================--
--
-- *MODULE << cmd_router >>
--
-- *Description : This module routes commands to all command driven modules
--               in the simulation. It instanciates N_FILES instances of
--               cmd_router1 and agregates the outputs to control N_BFM BFMs.
--
-- *History: M. Alford (originaly created 1993 with subsequent updates)
--
--==========================================================================--

--==========================================================================--
-- Operation
--
-- This module opens a text file and passes commands to individual vhdl models.
-- 
--==========================================================================--

entity cmd_router is
	generic( N_BFM      : integer := 8;
	         N_FILES    : integer := 3;
	         FIFO_DEPTH : integer := 16;
	         STRING_MAX : integer := 256
	       );
	port( CMD                : out    string(1 to STRING_MAX);
	      CMD_REQ            : out    bit_vector(N_BFM-1 downto 0);
	      CMD_ACK            : in     bit_vector(N_BFM-1 downto 0);
	      CMD_ERR            : in     bit_vector(N_BFM-1 downto 0);
	      CMD_CLOCK_EN       : out    boolean
	    );
end cmd_router;

architecture MODEL of cmd_router is

component cmd_router1
	generic( N_BFM      : integer := 8;
	         FIFO_DEPTH : integer := 8;
	         STRING_MAX : integer := 256;
	         FILENAME   : string :="cmdfile.vec"
	       );
	port( CMD                : out    STRING(1 to STRING_MAX);
	      CMD_REQ            : out    bit_vector(N_BFM-1 downto 0);
	      CMD_ACK            : in     bit_vector(N_BFM-1 downto 0);
	      CMD_ERR            : in     bit_vector(N_BFM-1 downto 0);
	      CMD_CLOCK_EN       : out    boolean;
	      CMD_DONE_IN        : in     boolean;
	      CMD_DONE_OUT       : out    boolean
	    );
end component; -- cmd_router1


	type FILE_ARRAY     is array (natural range <>) of string(1 to 8);
	type CMD_ARRAY      is array (natural range <>) of string(CMD'range);
	type CMD_REQ_ARRAY  is array (natural range <>) of bit_vector(N_BFM-1 downto 0);
	type integer_vector is array (natural range <>) of integer; 
	type boolean_vector is array (natural range <>) of boolean; 

	constant MAX_FILES         : integer := 10;
	constant FILENAMES         : FILE_ARRAY(0 to MAX_FILES-1) := ( "cmd0.vec", "cmd1.vec", 
	                                                               "cmd2.vec", "cmd3.vec", 
	                                                               "cmd4.vec", "cmd5.vec", 
	                                                               "cmd6.vec", "cmd7.vec", 
	                                                               "cmd8.vec", "cmd9.vec" );

	signal	CMDo               : CMD_ARRAY(N_FILES-1 downto 0);
	signal	REQ                : bit_vector(CMD_REQ'range);
	signal	CMD_REQo           : CMD_REQ_ARRAY(N_FILES-1 downto 0);
	signal	CMD_ACKi           : CMD_REQ_ARRAY(N_FILES-1 downto 0);
	signal	CMD_ACK_MASK       : CMD_REQ_ARRAY(N_FILES-1 downto 0); -- 1 bit_vector per file to mask CMD_ACK
	signal	CMD_CLOCK_ENo      : boolean_vector(N_FILES-1 downto 0);
	signal	CMD_ALL_DONE       : boolean;
	signal	CMD_DONE_OUT       : boolean_vector(N_FILES-1 downto 0);

    function or_reduce(ARG: bit_vector) return bit is
	variable result: bit;
    begin
		result := '0';
		for i in ARG'range loop
		    result := result or ARG(i);
		end loop;
		return result;
    end;

    function or_reduce(ARG: boolean_vector) return boolean is
	variable result: boolean;
    begin
		result := FALSE;
		for i in ARG'range loop
		    result := result or ARG(i);
		end loop;
		return result;
    end;

    function and_reduce(ARG: boolean_vector) return boolean is
	variable result: boolean;
    begin
		result := TRUE;
		for i in ARG'range loop
		    result := result and ARG(i);
		end loop;
		return result;
    end;


begin

-----------------------------------------------------------------------------
-- Instanciate 1 cmd_router1 per file to be processed
-----------------------------------------------------------------------------
	G1 : for i in 0 to N_FILES-1 generate
		U1 : cmd_router1
		generic map
		    ( N_BFM      => N_BFM,
		      FIFO_DEPTH => FIFO_DEPTH, 
		      STRING_MAX => STRING_MAX, 
		      FILENAME   => FILENAMES(i)
		    )
		port map
		    ( CMD           => CMDo(i), 
		      CMD_REQ       => CMD_REQo(i), 
		      CMD_ACK       => CMD_ACKi(i), 
		      CMD_ERR       => CMD_ERR, 
		      CMD_CLOCK_EN  => CMD_CLOCK_ENo(i), 
		      CMD_DONE_IN   => CMD_ALL_DONE, 
		      CMD_DONE_OUT  => CMD_DONE_OUT(i)
		    );
	end generate;

-----------------------------------------------------------------------------
-- Multiplex the commands from the cmd_router1 modules
-----------------------------------------------------------------------------

	process
	variable vDONE : boolean;
	begin
		CMD <= (others => '0');
		wait on CMD_REQo;
		vDONE := FALSE;
		while(not vDONE) loop
		vDONE := TRUE;
		for i in 0 to N_FILES-1 loop             -- Loop on each file
			if(or_reduce(CMD_REQo(i)) = '1') then -- this file wants to do a command
				vDONE := FALSE;
				--
				-- if the ACK is already on from another cmd_router1
				--
				while(or_reduce(CMD_REQo(i) and CMD_ACK) = '1') loop
					wait on CMD_ACK;
				end loop;
				--
				-- Do the request
				--
				CMD      <= CMDo(i);
				REQ      <= CMD_REQo(i);
				--
				-- Wait for the ACK
				--
				wait until(CMD_ACK'event and (or_reduce(CMD_ACK and REQ) = '1'));
				-- 
				-- send the ack to the proper file
				--
				for j in 0 to N_FILES-1 loop
					if(i = j) then -- enable this one
						CMD_ACK_MASK(j) <= CMD_ACK_MASK(j) or REQ;
					else
						CMD_ACK_MASK(j) <= CMD_ACK_MASK(j) and not REQ;
					end if;
				end loop;
				--
				-- Wait for the request to de-assert
				--
				while(or_reduce(CMD_REQo(i) and REQ) = '1') loop
					wait on CMD_REQo;
				end loop;
				REQ      <= (others => '0');
			end if;
		end loop;
	end loop;
	end process;

	process(CMD_ACK, CMD_ACK_MASK)
	begin
		for i in 0 to N_FILES-1 loop             -- Loop on each file
			CMD_ACKi(i) <= CMD_ACK and CMD_ACK_MASK(i);
		end loop;
	end process;
	

	CMD_REQ <= REQ;

	CMD_ALL_DONE <= and_reduce(CMD_DONE_OUT);

	CMD_CLOCK_EN <= CMD_CLOCK_ENo(0);

end MODEL;

