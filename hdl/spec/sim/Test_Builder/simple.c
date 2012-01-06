//***********************************************************************************************
//***********************************************************************************************
//**
//** Name:  simple.c
//**
//** Description:  This is an example test source code used to drive the Lambo TestBench.
//**
//***********************************************************************************************
//***********************************************************************************************

#include "lib/maketest.c"

#define BAR0_BASE     0xFF00000010000000ll
#define BAR1_BASE     0xFF000000A0000000ll
#define BFM_BAR0_BASE 0x8765432120000000ll
#define BFM_BAR1_BASE 0xBB00000040000000ll

//***********************************************************************************************
//**
//** Main: 
//**
//**  Edit the program below to create your own test script.
//**
//***********************************************************************************************

main(argc,argv)
int argc;
char *argv[];
{

//-----------------------------------------------------------------------------------------------
// Always call maketest_init at the beginning of a test program
//-----------------------------------------------------------------------------------------------
	maketest_init(argc,argv);

//================================================================================================
//== START of user script
//================================================================================================

	comment("-----------------------------------------------------------------------------");
	comment("Generated from: simple.c - do not edit the vec file directly as it is not the source!");
	comment("Short example of using the lambo TestBench");
	comment("-----------------------------------------------------------------------------");

	comment("Select the GN4124 Primary BFM");
	model(0);

	comment("Initialize the BFM to its default state");
	init();

	comment("\nDrive reset to the FPGA");
	reset(16);

	comment("\n");
	comment("-----------------------------------------------------------------------------");
	comment("Initialize the Primary GN412x BFM model");
	comment("-----------------------------------------------------------------------------");
	comment("These address ranges will generate traffic from the BFM to the FPGA");
	comment("bar BAR ADDR SIZE VC TC S");

	bar(0, BAR0_BASE, 0x08000000, 0, 7, 0);
	bar(1, BAR1_BASE, 0x10000000, 1, 5, 0);

	comment("\nThis allocates a RAM block inside the BFM for the FPGA to access");
	comment("bfm_bar BAR ADDR SIZE");
	bfm_bar(0, BFM_BAR0_BASE, 0x20000000);
	bfm_bar(1, BFM_BAR1_BASE, 0x20000000);

	comment("\nWait until the FPGA is un-reset and ready for traffic on the local bus");
	wait(64);

	comment("\n-----------------------------------------------------------------------------");
	comment("Access the descriptor memory in the Lambo design");
	comment("-----------------------------------------------------------------------------");
	comment("the following three writes will go out in a single packet");
	wrb(BAR0_BASE+0x4000, 0xF, 0x87654321);
	wrb(BAR0_BASE+0x4004, 0xF, 0xFEEDFACE);
	wr( BAR0_BASE+0x4008, 0xF, 0xDEADBEEF);

	comment("\nNow read back what was just written");
	comment("the following three reads will go out as a single request");
	rdb(BAR0_BASE+0x4000, 0xF, 0x87654321, 0xFFFFFFFF);
	rdb(BAR0_BASE+0x4004, 0xF, 0xFEEDFACE, 0xFFFFFFFF);
	rd( BAR0_BASE+0x4008, 0xF, 0xDEADBEEF, 0xFFFFFFFF);
	comment("\n");
	flush(256);
	comment("\n");
	wait(16);
	comment("\n");
	sync();

//================================================================================================
//== END of user script
//================================================================================================

	exit(0);

}


