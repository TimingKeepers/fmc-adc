/*----------------------------------------------------------------------------
  -- model.c : Generate BFM Commands from C
  --
  -- This module re-directs bus model commands to specific sub modules.
  --
  -- For Example:
  --    A system simulation that has both a pci32 model and an i960sx model
  --    can drive both models from a single file as follows:
  --
  -- 	model_map(0, "i960sx"); // model #0 is an i960sx
  --	model_map(1, "pci32");  // model #1 is a 32 bit PCI model
  -- 	model(0);               // Select the i960sx model
  --	memw32(0x100, 0x76543210);
  -- 	memv32(0x100);
  -- 	model(1);               // Select the PCI model
  --	memw32(0x200, 0x01234567);
  -- 	memv32(0x200);
  ----------------------------------------------------------------------------*/
#include <stdio.h>
//#include "emul.h"

#define U64			unsigned long long
//#define U64			unsigned long long
#define U32			unsigned long
#define U16			unsigned short
#define U8  		unsigned char
#define BYTE		unsigned char

#define MAX_MODEL_CHAN	20


int model_num  = 0;
int current_channel = 0;
int chan_init = 1;

//extern void set_chan(int chan);

/*----------------------------------------------------------------------------
  -- btype:  returns an ' ' if an address is at the end of a burst
  ----------------------------------------------------------------------------*/

char btype(U64 address)
{
	U32 mask;
	int burst_length, bus_width;
	burst_length = 4096;
	bus_width = 32;
	mask = burst_length - 1;
	mask ^= bus_width/8 - 1;
	if((address & mask) == mask) /* crosses a burst boundary */
		return(' ');
	else
		return('b');
}


/*----------------------------------------------------------------------------
  -- xwrite:  Write on a DW boundary with byte enables
  --          Primitive used for all writes
  ----------------------------------------------------------------------------*/

void xwrite(U64 address, BYTE be, U32 data, char burst)
{
	fprintf(stdout, "wr%c %016llX %X %08lX\n", burst, address, be, data);
}

/*----------------------------------------------------------------------------
  -- xread:   Read primitive - reads data ion a DW boundary with byte enables
  ----------------------------------------------------------------------------*/

void xread(U64 address, BYTE be, U32 data, U32 mask, char burst, char mode)
{
	fprintf(stdout, "rd%c %016llX %X %08lX %08lX\n", burst, address, be, data, mask);
}

/*----------------------------------------------------------------------------
  -- opr_prn:   prints out an array of read, write or verify commands
  ----------------------------------------------------------------------------*/
void opr_prn(U64 address, BYTE *be, U32 *d, U32 *m, char mode, char burst, int n)
{
	int i;
	char c;

	for(i = 0; i < n; i++)
	{
		if((n == 1) && (burst == ' '))
			c = ' '; 
		else if((i == (n-1)) && (burst != 'b'))
			c = ' '; 
		else
			c = btype(address);

		if(mode == 'r')
		{
			xread(address, be[i], d[i], m[i], c, mode);
		}
		else if(mode == 'v')
		{
			xread(address, be[i], d[i], m[i], c, mode);
		}
		else
		{
			xwrite(address, be[i], d[i], c);
		}

		address += 4;
	}
}


/*----------------------------------------------------------------------------
  -- xopr:  32 bit operations on a 32 bit boundary with byte enables, burst and non-burst
  ----------------------------------------------------------------------------*/

void xopr(U64 address, BYTE be, U32 data, U32 mask, char burst, char mode)
{
	U32 d[2], m[2];
	char c;
	BYTE b[2];
	int n = 1;
/*printf("-- xopr(address=0x%08lX, be=0x%X, data=0x%08lX, masks=0x%08lX, burst=%c, mode=%c)\n", address, be, data, mask, burst, mode);*/
	if(address & 3)
	{
		fprintf(stdout, "-- WARNING: address not 32 bit aligned and will be adjusted\n");
		address &= ~3;
	}
	c = burst;
	b[0] = be;
	d[0] = data;
	m[0] = mask;
	opr_prn(address, b, d, m, mode, burst, n);
}

/*----------------------------------------------------------------------------
  -- xwr:  Write 32 bits on a 32 bit boundary with byte enables, burst and non-burst
  ----------------------------------------------------------------------------*/

void xwr(U64 address, BYTE be, U32 data, char burst)
{
	xopr(address, be, data, 0, burst, 'w');
}

/*----------------------------------------------------------------------------
  -- xrd:  Read 32 bits on a 32 bit boundary with byte enables, burst and non-burst
  ----------------------------------------------------------------------------*/

void xrd(U64 address, BYTE be, U32 data, U32 mask, char burst)
{
	xopr(address, be, data, mask, burst, 'r');
}

/*----------------------------------------------------------------------------
  -- xrv:  Verify 32 bits on a 32 bit boundary with byte enables, burst and non-burst
  ----------------------------------------------------------------------------*/

void xrv(U64 address, BYTE be, char burst)
{
	xopr(address, be, 0, 0, burst, 'v');
}




//***********************************************************************************************
//**
//** Commands Specific to the Command Router
//**
//***********************************************************************************************

/*----------------------------------------------------------------------------
  -- comment: put a comment in the command file.
  ----------------------------------------------------------------------------*/
void comment(char *str)
{
	while(*str == '\n')
	{
		printf("\n");
		str++;
	}
	if(*str != '\0')
	{
		if(*str == '-')
			printf("--%s\n", str);
		else
			printf("-- %s\n", str);
	}
}

/*----------------------------------------------------------------------------
  -- sync: does the sync command.
  ----------------------------------------------------------------------------*/
void sync()
{
	printf("sync\n");
}

/*----------------------------------------------------------------------------
  -- gsync: does the gsync command.
  ----------------------------------------------------------------------------*/
void gsync()
{
	printf("gsync\n");
}

/*----------------------------------------------------------------------------
  -- model: Select a model.
  ----------------------------------------------------------------------------*/
void model(int model)
{
	printf("model %%d%d\n", model);
}

/*----------------------------------------------------------------------------
  -- ckoff: Turn off the models clock.
  ----------------------------------------------------------------------------*/

void ckoff()
{
	printf("ckoff  \n");
}

/*----------------------------------------------------------------------------
  -- ckon: Turn on the models clock.
  ----------------------------------------------------------------------------*/

void ckon()
{
	printf("ckon  \n");
}


//***********************************************************************************************
//**
//** Model Commands
//**
//***********************************************************************************************

/*----------------------------------------------------------------------------
  -- init: Initalize a model.
  ----------------------------------------------------------------------------*/
void init()
{
	printf("init\n");
}

/*----------------------------------------------------------------------------
  -- reset: Initalize a model.
  ----------------------------------------------------------------------------*/
void reset(int n)
{
	printf("reset %%d%d\n", n);
}

/*----------------------------------------------------------------------------
  -- lclk: lclk period.
  ----------------------------------------------------------------------------*/
void lclk(int n)
{
	printf("lclk %%d%d\n", n);
}

/*----------------------------------------------------------------------------
  -- base: base period.
  ----------------------------------------------------------------------------*/
void base(int n)
{
	if((n==2)||(n==10)||(n==16))
	{
		printf("base %%d%d\n", n);
	}
	else
	{
		fprintf(stderr, "ERROR: invalid base specified: %d\n", n);
		printf("--ERROR: base \%d%d\n", n);
	}
}

/*----------------------------------------------------------------------------
  -- bar BAR ADDR SIZE VC TC S
  ----------------------------------------------------------------------------*/
void bar(int bar, U64 addr, U32 size, int vc, int tc, int s)
{
	if(bar != 0) bar = 1;
	if(s   != 0) s   = 1;
	if(vc  != 0) vc  = 1;
	if((tc < 0)||(tc > 7)) tc = 0;
	
	printf("bar     %d %016llX %08X %X %X %X\n", bar, addr, size, vc, tc, s);
}

/*----------------------------------------------------------------------------
  -- bfm_bar BAR ADDR SIZE
  ----------------------------------------------------------------------------*/
void bfm_bar(int bar, U64 addr, U32 size)
{
	if(bar != 0) bar = 1;
	
	printf("bfm_bar %d %016llX %08X\n", bar, addr, size);
}

/*----------------------------------------------------------------------------
  -- wait:  Do nothing for N CLK cycles
  ----------------------------------------------------------------------------*/
void wait(int n)
{
	fprintf(stdout, "wait   %%d%d\n", n);
}

/*----------------------------------------------------------------------------
  -- flush:  Wait until all outstanding read requests have been completed or 
  --         N local bus clocks, whichever comes first.  
  ----------------------------------------------------------------------------*/
void flush(int n)
{
	fprintf(stdout, "flush  %%d%d\n", n);
}

/*----------------------------------------------------------------------------
  -- rd_outstanding_in:  Number of outstanding read commands allowed incoming to the model
  --         
  ----------------------------------------------------------------------------*/
void rd_outstanding_in(int n)
{
	if((n < 1)||(n > 4)) n = 3;
	fprintf(stdout, "rd_outstanding_in  %%d%d\n", n);
}

/*----------------------------------------------------------------------------
  -- rd_outstanding_out:  Number of outstanding read before the BFM will stall
  --         
  ----------------------------------------------------------------------------*/
void rd_outstanding_out(int n)
{
	if((n < 1)||(n > 4)) n = 3;
	fprintf(stdout, "rd_outstanding_out %%d%d\n", n);
}

/*----------------------------------------------------------------------------
  -- response_delay: Delay the return of response data by N local bus clock intervals
  --         
  ----------------------------------------------------------------------------*/
void response_delay(int n, int vc)
{
	if(vc  != 0) vc  = 1;
	fprintf(stdout, "response_delay %%d%d %d\n", n, vc);
}

/*----------------------------------------------------------------------------
  -- burst_length: Sets the burst length that read/write packets will get truncated to.  
  --         
  ----------------------------------------------------------------------------*/
void burst_length(int n, int bar)
{
	if(bar  != 0) bar  = 1;
	fprintf(stdout, "burst_length %%d%d %d\n", n, bar);
}

/*----------------------------------------------------------------------------
  -- burst_modulo: Sets the burst length that read/write packets will get truncated to.  
  --         
  ----------------------------------------------------------------------------*/
void burst_modulo(int n, int bar)
{
	if(bar  != 0) bar  = 1;
	fprintf(stdout, "burst_modulo %%d%d %d\n", n, bar);
}

/*----------------------------------------------------------------------------
  -- cpl_modulo: Sets the burst length that read/write packets will get truncated to.  
  --         
  ----------------------------------------------------------------------------*/
void cpl_modulo(int n)
{
	fprintf(stdout, "cpl_modulo %%d%d\n", n);
}

/*----------------------------------------------------------------------------
  -- cpl_order: Sets the burst length that read/write packets will get truncated to.  
  --         
  ----------------------------------------------------------------------------*/
void cpl_order(int n)
{
	fprintf(stdout, "cpl_order %%d%d\n", n);
}


/*----------------------------------------------------------------------------
  -- iwait_random: Initiator random wait state insertion
  --         
  ----------------------------------------------------------------------------*/
void iwait_random(int p, int n)
{
	if((p < 0)||(p > 100)) p = 0;
	if(p==0)
		fprintf(stdout, "iwait_random %%d%d 0 -- Initiator random wait states disabled\n", p);
	else
		fprintf(stdout, "iwait_random %%d%d %%d%d -- Initiator random wait states: probability=%d%% max duration= %d\n", p, n, p, n);
	
}

/*----------------------------------------------------------------------------
  -- gpio_wait N P MASK: Wait for N local bus clock intervals for GPIO to reach a defined state.
  --         
  ----------------------------------------------------------------------------*/
void gpio_wait(int n, U32 p, U32 mask)
{
	fprintf(stdout, "gpio_wait %%d%d %04lX %04lX -- gpio_wait N P MASK\n", n, p, mask);
}

/*----------------------------------------------------------------------------
  -- l2p_rdy STATE DURATION R: Drive the L2P_RDY signal to STATE for 
  --                           duration DURATION as a number of local bus 
  --                           clock intervals.  
  --         
  ----------------------------------------------------------------------------*/
void l2p_rdy(char state, int duration, int r)
{
	fprintf(stdout, "l2p_rdy %c %%%d %%%d -- l2p_rdy STATE DURATION RESTART\n", state, duration, r);
}

/*----------------------------------------------------------------------------
  -- vc VC: Set the virtual channel number for subsequent P2L read/write 
  --        requests on the local bus.  
  --         
  ----------------------------------------------------------------------------*/
void vc(int vc)
{
	fprintf(stdout, "vc %X\n", vc);
}

//l_wr_rdy FILL DRAIN

/*----------------------------------------------------------------------------
  -- ************************** User Visible Functions ***********************
  --
  -- The following functions are to be used in the user source code
  ----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------
  -- wr:  Non-Burst Write 32 bits on a 32 bit boundary with byte enables
  ----------------------------------------------------------------------------*/

void wr(U64 address, BYTE be, U32 data)
{
	xwr(address, be, data, ' ');
}

/*----------------------------------------------------------------------------
  -- rd:  Non-Burst Read 32 bits on a 32 bit boundary with byte enables
  ----------------------------------------------------------------------------*/

void rd(U64 address, BYTE be, U32 data, U32 mask)
{
	xrd(address, be, data, mask, ' ');
}

/*----------------------------------------------------------------------------
  -- rv:  Non-Burst Read Verify 32 bits on a 32 bit boundary with byte enables
  ----------------------------------------------------------------------------*/

void rv(U64 address, BYTE be)
{
	xrv(address, be, ' ');
}

/*----------------------------------------------------------------------------
  -- wrb:  Burst Write 32 bits on a 32 bit boundary with byte enables
  ----------------------------------------------------------------------------*/

void wrb(U64 address, BYTE be, U32 data)
{
	xwr(address, be, data, 'b');
}

/*----------------------------------------------------------------------------
  -- rdb:  Burst Read 32 bits on a 32 bit boundary with byte enables
  ----------------------------------------------------------------------------*/

void rdb(U64 address, BYTE be, U32 data, U32 mask)
{
	xrd(address, be, data, mask, 'b');
}

/*----------------------------------------------------------------------------
  -- rvb: Burst Read Verify 32 bits on a 32 bit boundary with byte enables
  ----------------------------------------------------------------------------*/

void rvb(U64 address, BYTE be)
{
	xrv(address, be, 'b');
}

/*----------------------------------------------------------------------------
  -- opr32:  Primitive for 32 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void opr32(U64 address, U32 data, U32 mask, char mode)
{
	U32 d[2], m[2], step;
	BYTE be[2];
	int n, i;
	char c;
	step = 4;
	if((address & 0x3) != 0) /* on an odd word boundary */
	{
		d[0]  = data << (8 * (address & 3));
		d[1]  = data >> (8 * (4 - (address & 3)));
		m[0]  = mask << (8 * (address & 3));
		m[1]  = mask >> (8 * (4 - (address & 3)));
		be[0] = (0xF <<    (address & 3) ) & 0xF;
		be[1] = (0xF >> (4-(address & 3))) & 0xF;
		address &= ~3;	
		n = 2;
	}
	else /* even boundary */
	{
		d[0]  = data;
		m[0]  = mask;
		be[0] = 0xF;
		n = 1;
	}
	opr_prn(address, be, d, m, mode, ' ', n);
}

/*----------------------------------------------------------------------------
  -- wr32:  Write 32 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void wr32(U64 address, U32 data)
{
	opr32(address, data, 0, 'w');
}

/*----------------------------------------------------------------------------
  -- rd32:  Read 32 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void rd32(U64 address, U32 data, U32 mask)
{
	opr32(address, data, mask, 'r');
}

/*----------------------------------------------------------------------------
  -- opr16:  Primitive for 16 bit operations on any byte boundary
  ----------------------------------------------------------------------------*/

void opr16(U64 address, U16 data, U16 mask, char mode)
{
	U32 d[2], m[2];
	BYTE be[2];
	int n;
	if((address & 0x3) == 0x3) /* on an odd word boundary */
	{
		d[0] = (U32) data << 24;
		d[1] = (U32) data >> 8;
		m[0] = (U32) mask << 24;
		m[1] = (U32) mask >> 8;
		be[0] = 0x8;
		be[1] = 0x1;
		address &= ~3;
		n = 2;
	}
	else /* even boundary */
	{
		d[0]  = (U32) data << (8 * (address & 0x3));
		m[0]  = (U32) mask << (8 * (address & 0x3));
		be[0] = 3 << (address & 0x3);
		address &= ~3;
		n   = 1;
	}
	opr_prn(address, be, d, m, mode, ' ', n);
}

/*----------------------------------------------------------------------------
  -- wr16:  Write 16 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void wr16(U64 address, U16 data)
{
	opr16(address, data, 0, 'w');
}

/*----------------------------------------------------------------------------
  -- rd16:  Read 16 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void rd16(U64 address, U16 data, U16 mask)
{
	opr16(address, data, mask, 'r');
}

/*----------------------------------------------------------------------------
  -- opr8:  adjust 8 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void opr8(U64 address, U16 data, U16 mask, char mode)
{
	U32 a, d, m;
	BYTE be;
	U64 amask;
	amask = 3;
	d  = ((U32) data & 0xFF) << (8 * (address & amask));
	m  = ((U32) mask & 0xFF) << (8 * (address & amask));
	be = 1 << (address & amask);
	a  = address & (~amask);

	opr_prn(a, &be, &d, &m, mode, ' ', 1);
}

/*----------------------------------------------------------------------------
  -- wr8:  Write 8 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void wr8(U64 address, U16 data)
{
	opr8(address, data, 0, 'w');
}

/*----------------------------------------------------------------------------
  -- rd8:  Read 8 bits on any byte boundary
  ----------------------------------------------------------------------------*/

void rd8(U64 address, U16 data, U16 mask)
{
	opr8(address, data, mask, 'r');
}

/*----------------------------------------------------------------------------
  -- swap8:  8 bit swap on 32 bit data
  ----------------------------------------------------------------------------*/

U32 swap8(U32 data)
{
	data = (data << 24) | ((data << 8) & 0x00ff0000) | ((data >> 8) & 0x0000ff00) | (data >> 24);
	return data;
}

/*----------------------------------------------------------------------------
  -- swap16:  16 bit swap on 32 bit data
  ----------------------------------------------------------------------------*/

U32 swap16(U32 data)
{
	data = (data << 16) | (data >> 16);
	return data;
}
