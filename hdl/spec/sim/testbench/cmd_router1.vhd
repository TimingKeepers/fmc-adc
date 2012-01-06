library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

--library std_developerskit;
--use std_developerskit.std_iopak.all;

use work.util.all;
use work.textutil.all;

--==========================================================================--
--
-- *MODULE << model1 >>
--
-- *Description : This module routes commands to all command driven modules
--               in the simulation.
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

entity cmd_router1 is
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
end cmd_router1;

architecture MODEL of cmd_router1 is


	type STRING_ARRAY   is array (FIFO_DEPTH-1 downto 0) of STRING(1 to STRING_MAX);
	type FD_ARRAY       is array (N_BFM-1 downto 0) of STRING_ARRAY;
	type integer_vector is array (natural range <>) of integer; 

	signal	FD                 : FD_ARRAY;
	signal  ERR_CNT            : integer;
	signal	PUSH_PTR           : integer_vector(N_BFM-1 downto 0);
	signal	POP_PTR            : integer_vector(N_BFM-1 downto 0);
	signal  SET_CHAN           : std_ulogic;
	signal  POP_INIT           : std_ulogic;
	signal	CMD_REQo           : bit_vector(CMD_REQ'range);
	signal	LINE_NUM           : integer;

begin
	PUSH_PROCESS : process
	file FOUT : text open write_mode is "usc.lst";

	file        stim_file   : text open read_mode is FILENAME;
	file        out_file    : text open write_mode is "STD_OUTPUT";

-------- For VHDL-87
--	file        stim_file   : text is in FILENAME;
--	file        out_file    : text is out "STD_OUTPUT";

	variable	input_line  : line;
	variable	output_line : line;
	variable	tmp_lout    : line;
	variable	command     : string(1 to 8);
	variable	tmp_str     : string(1 to STRING_MAX);
	variable	input_str   : string(1 to STRING_MAX);
	variable	i           : integer;
	variable	CHANNEL     : integer;
	variable	S_PTR       : integer;
	variable	vLINE_NUM   : integer;
	variable	vPUSH_PTR   : integer_vector(N_BFM-1 downto 0);
	variable	DONE        : boolean;
	variable	EOS         : integer;
	variable	ERR         : integer;



	begin

-----------------------------------------------------------------------------
-- Main Loop
-----------------------------------------------------------------------------
		vLINE_NUM := 0;
		PUSH_PTR  <= (others => 0);
		vPUSH_PTR := (others => 0);
		CHANNEL := 0;
		CMD_CLOCK_EN <= TRUE;
		SET_CHAN <= '0';
		CMD_DONE_OUT <= FALSE;
		if(POP_INIT /= '1') then
			wait until(POP_INIT'event and (POP_INIT = '1'));
		end if;
		
		ST_LOOP: while not endfile(stim_file) loop
			readline(stim_file, input_line);
			S_PTR := 1;
			vLINE_NUM := vLINE_NUM + 1;
			LINE_NUM <= vLINE_NUM;

-- Copy the line
			input_str := (others => ' ');
			input_str(1 to 6) := To_Strn(vLINE_NUM, 6);
			input_str(7 to 8) := string'(": ");
			input_str(9 to input_line'length+8) := string'(input_line.all);
			while(input_str(S_PTR) /= ':') loop
				S_PTR := S_PTR + 1;
			end loop;
			S_PTR := S_PTR + 1;

			sget_token(input_str, S_PTR, command);

			SET_CHAN <= '1';

			for j in STRING_MAX downto 1 loop
				if(input_str(j) /= ' ') then
					EOS := j;
					exit;
				end if;
			end loop;


			---------------------------
			-- "model" command ?
			---------------------------
			if(command(1 to 5) = "model") then
				sget_int(input_str, S_PTR, i);
				write(tmp_lout, FILENAME);
				write(tmp_lout, input_str(1 to EOS));
				writeline(out_file, tmp_lout);
				if((i >= N_BFM) or (i < 0)) then
					CHANNEL := N_BFM-1;
					write(tmp_lout, string'("ERROR: Invalid Channel "));
					write(tmp_lout, i);
					writeline(out_file, tmp_lout);
				else
					CHANNEL := i;
				end if;

			---------------------------
			-- "sync" command ?
			---------------------------
			elsif(command(1 to 4) = "sync") then
				loop
					DONE := TRUE;
					for i in PUSH_PTR'reverse_range loop
						if((vPUSH_PTR(i) /= POP_PTR(i)) or (CMD_ACK(i) /= '0')) then
							DONE := FALSE;
						end if;
					end loop;
					if(DONE) then
						exit;
					end if;
					wait on POP_PTR, CMD_ACK;
				end loop;
				write(tmp_lout, FILENAME);
				write(tmp_lout, input_str(1 to EOS));
				writeline(out_file, tmp_lout);

			---------------------------
			-- "gsync" and "ckoff" command ?
			---------------------------
			elsif((command(1 to 5) = "gsync") or (command(1 to 5) = "ckoff")) then
write(tmp_lout, FILENAME);
write(tmp_lout, string'(": entering the gsync command"));
writeline(out_file, tmp_lout);
				loop
					DONE := TRUE;
					for i in PUSH_PTR'reverse_range loop
						if((vPUSH_PTR(i) /= POP_PTR(i)) or (CMD_ACK(i) /= '0')) then
							DONE := FALSE;
						end if;
					end loop;
					if(DONE) then
						exit;
					end if;
					wait on POP_PTR, CMD_ACK;
				end loop;
				CMD_DONE_OUT <= TRUE;
				-- wait for the external CMD_DONE_IN to be done
				while (not CMD_DONE_IN) loop
					wait on CMD_DONE_IN;
				end loop;
				CMD_DONE_OUT <= FALSE;
				write(tmp_lout, FILENAME);
				write(tmp_lout, input_str(1 to EOS));
				writeline(out_file, tmp_lout);
				if (command(1 to 5) = "ckoff") then
					CMD_CLOCK_EN <= FALSE;
				end if;
write(tmp_lout, FILENAME);
write(tmp_lout, string'(": gsync command is DONE"));
writeline(out_file, tmp_lout);

			--------------------
			-- ckon
			--------------------
			elsif (command(1 to 4) = "ckon") then
				CMD_CLOCK_EN <= TRUE;
				write(tmp_lout, FILENAME);
				write(tmp_lout, input_str(1 to EOS));
				writeline(out_file, tmp_lout);

			---------------------------
			-- put the line in the FIFO
			---------------------------
			else


				FD(CHANNEL)(vPUSH_PTR(CHANNEL)) <= input_str;

				vPUSH_PTR(CHANNEL) := vPUSH_PTR(CHANNEL) + 1;

				if(vPUSH_PTR(CHANNEL) >= FIFO_DEPTH) then
					vPUSH_PTR(CHANNEL) := 0;
				end if;

				if(vPUSH_PTR(CHANNEL) = POP_PTR(CHANNEL)) then -- The FIFO is full
					wait until(POP_PTR'event and (vPUSH_PTR(CHANNEL) /= POP_PTR(CHANNEL)));
				end if;

				PUSH_PTR(CHANNEL) <= vPUSH_PTR(CHANNEL);

			end if;
		
		end loop;

		loop
			DONE := TRUE;
			for i in POP_PTR'reverse_range loop
				if((POP_PTR(i) /= vPUSH_PTR(i)) or (CMD_ACK(i) = '1')) then -- FIFO channel not empty
					DONE := FALSE;
				end if;
			end loop;
			if(DONE) then
				exit;
			end if;
			wait on CMD_ACK, POP_PTR;
		end loop;

		CMD_DONE_OUT <= TRUE;

		write(output_line, string'("******************************* Test Finished *******************************"));
		writeline(out_file, output_line);
		write(output_line, string'("* Total Errors for "));
		write(output_line, FILENAME);
		write(output_line, string'(": "));
		write(output_line, err_cnt);
		writeline(out_file, output_line);
		write(output_line, string'("*****************************************************************************"));
		writeline(out_file, output_line);

		file_close(stim_file); -- Close File

		loop
			wait for 100000 us;
		end loop;

	end process;

-----------------------------------------------------------------------------
-- POP Process
-----------------------------------------------------------------------------
	POP_PROCESS : process
	variable	vPOP_PTR   : integer_vector(POP_PTR'range);
	variable	DONE       : boolean;

	file        out_file    : text open write_mode is "STD_OUTPUT";

-------- For VHDL-87
--	file        out_file    : text is out "STD_OUTPUT";

	variable	tmp_lout    : line;
	
	
	variable    CHAR_PTR    : integer;
	variable    EOS         : integer;
	
	begin
		CHAR_PTR := 1;
		ERR_CNT  <= 0;
		POP_PTR  <= (others => 0);
		vPOP_PTR := (others => 0);
		CMD_REQo  <= (others => '0');
		POP_INIT  <= '1';
		if(SET_CHAN /= '1') then
			wait until(SET_CHAN'event and (SET_CHAN = '1'));
		end if;

		loop
			DONE := FALSE;
			loop
				DONE := TRUE;
				for i in POP_PTR'reverse_range loop
					if((vPOP_PTR(i) /= PUSH_PTR(i)) and (CMD_ACK(i) = '0')) then -- FIFO channel not empty
						CMD <= FD(i)(vPOP_PTR(i));
						CMD_REQo(i) <= '1';
						for j in STRING_MAX downto 1 loop
							if(FD(i)(vPOP_PTR(i))(j) /= ' ') then
								EOS := j;
								exit;
							end if;
						end loop;
						write(tmp_lout, FILENAME);
						write(tmp_lout, FD(i)(vPOP_PTR(i))(1 to EOS));
						writeline(out_file, tmp_lout);
						if(CMD_ACK(i) /= '1') then
							wait until(CMD_ACK'event and (CMD_ACK(i) = '1'));
						end if;
						CMD_REQo(i) <= '0';
						DONE := FALSE;
						vPOP_PTR(i) := vPOP_PTR(i) + 1;
						if(vPOP_PTR(i) >= FIFO_DEPTH) then
							vPOP_PTR(i) := 0;
						end if;
						POP_PTR(i) <= vPOP_PTR(i);
					end if;
				end loop;
				if(DONE) then
					exit;
				end if;
			end loop;
			
			
			
			wait on PUSH_PTR, CMD_ACK;

		end loop;

	end process;

	CMD_REQ <= CMD_REQo;

end MODEL;

