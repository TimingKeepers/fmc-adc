//***********************************************************************************************
//***********************************************************************************************
//**
//** Name:  cont_block_dma.c
//**
//** Description:  DMA scenario for a 2MB contiguous block of memory.
//**
//**
//***********************************************************************************************
//***********************************************************************************************

//===============================================================================================
// This provides the framework for creating tests for the testbench as described in 
// GN412x Simulation Test Bench User Guide
//===============================================================================================
#include "lib/maketest.c" 

//===============================================================================================
// This provides the framework for creating microcode for the 3 or 4DW list type described in 
// the application note: "Implementing Multi-channel DMA with the GN412x IP"
//===============================================================================================
#include "lib/vdma_service.c" 

//===============================================================================================
// lambo.h contains the address map for the Lambo project
//===============================================================================================
#include "lambo.h"


//===============================================================================================
// Define the Memory Map
//===============================================================================================
#define BAR0_BASE     0xFF00000010000000ll
#define BAR1_BASE     0xFF000000A0000000ll
#define BFM_BAR0_BASE 0x87654321F0000000ll
#define BFM_BAR1_BASE 0xBB00000040000000ll

#define CHAN0_DESC_LIST_SIZE 3

#define L2P_CHAN0_SUB_DMA_LENGTH 0x1000
#define L2P_CHAN0_XFER_CTL 0x00010000

//===============================================================================================
// Define the SG List
//===============================================================================================
struct sg_entry_struct sg_list_chan0[] =
{
	{ BFM_BAR0_BASE|0xFF1000C8, L2P_CHAN0_XFER_CTL | 0xF38, 1 },
	{ BFM_BAR0_BASE|0xFF101000, L2P_CHAN0_XFER_CTL | (L2P_CHAN0_SUB_DMA_LENGTH & 0xFFF), 511 },
	{ BFM_BAR0_BASE|0xFF300000, L2P_CHAN0_XFER_CTL | 0x0C8 | 0x80000000, 1 }, //Assert an interrupt
	{ 0x0ll, 0, 0 }
};

//***********************************************************************************************
//**
//** vdma_main: This will insert the DMA microcode and data into the test script 
//**
//**  The last function call, vdma_process(), will cross reference all of the labels in the
//**  source code so that you end up with the proper hexadecimal values that need to be written
//**  to descriptor RAM.
//**
//***********************************************************************************************

void vdma_main()
{

	vdma_org(0x0000);		    //This initializes the program address counter
	data_address = 0x200;       //This initializes the data space address counter
	vdma_label("START");
		vdma_nop();	//do nothing

//===============================================================================================
// START of the main program loop
//===============================================================================================
	vdma_label("MAIN");
		vdma_channel_service_4
		(
			"L2P_CHAN0",              //label to be used for this specific channel
			'l',                      //direction='l' for l2p or 'p' for p2l
			0,                        //The event register bit to be used for interrupt generation
			_EXT_COND_0,              //External condition used for this channel
			_EXT_COND_LO,             //Set to either _EXT_COND_LO or _EXT_COND_HI
			0,                        //set to non zero when the list will be updated dynamicaly
			CHAN0_DESC_LIST_SIZE,     //SYS_ADDR step size of list entries that have a repeat count
			L2P_CHAN0_SUB_DMA_LENGTH, //Step size of list entries that have a repeat count
			sg_list_chan0             //SG List itself
		);

		vdma_nop();	// This is not required (can be replaced with more channel servicing)
		vdma_jmp(_ALWAYS, 0,"MAIN");	//loop forever

//===============================================================================================
// END of the main program loop
//===============================================================================================

//-----------------------------------------------------------------------------------------------
// Global Constants 
//-----------------------------------------------------------------------------------------------
	vdma_org(0x0100);
	vdma_label("ZERO");
		vdma_constant_n64(0);          //The constant 0
	vdma_label("MINUS1");
		vdma_constant_n(0xFFFFFFFF);   //The constant -1
	vdma_label("THREE");
		vdma_constant_n(3);            //The constant 3
	vdma_label("FOUR");
		vdma_constant_n(4);            //The constant 4

//===============================================================================================
// Must run vdma_process to resolve the cross-references and generate the microcode
//===============================================================================================
	vdma_process(BAR0_BASE + 0x4000);

}

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
	int offset=0, i;

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

	bar(0, BAR0_BASE, 0x20000000, 0, 7, 0);
	bar(1, BAR1_BASE, 0x10000000, 1, 5, 0);

	comment("\nThis allocates a RAM block inside the BFM for the FPGA to access");
	comment("bfm_bar BAR ADDR SIZE");
	bfm_bar(0, BFM_BAR0_BASE, 0x10000000);
	bfm_bar(1, BFM_BAR1_BASE, 0x20000000);

	comment("\nWait until the FPGA is un-reset and ready for traffic on the local bus");
	wait(64);

	comment("\n-------------------------------------------------------------------------------");
	comment("DO some setup");
	comment("-------------------------------------------------------------------------------");
	comment("Lambo setup...");

	rd(BAR0_BASE + DMA_SEQ_CSR_REG,       0xF, 0x00000000, 0xFFFFFFFF);
	flush(0x100);
	wr(BAR0_BASE + DMA_SEQ_DPTR_REG,      0xF, 0x0);
	wr(BAR0_BASE + DMA_SEQ_EVENT_EN_REG,  0xF, 0x3);
	wr(BAR0_BASE + DMA_SEQ_EVENT_CLR_REG, 0xF, 0xFFFFFFFF);
	wr(BAR0_BASE + APP_CFG,               0xF, 0x6);
	wr(BAR0_BASE + APP_CFG,               0xF, 0x0);
	wr(BAR0_BASE + DMA_CFG,               0xF, 0x1F);
	wr(BAR0_BASE + DMA_CFG,               0xF, 0x7);
	wr(BAR0_BASE + APP_GEN_COUNT,         0xF, 0x0);
	wr(BAR0_BASE + APP_RCV_COUNT,         0xF, 0x0);
	wr(BAR0_BASE + APP_RCV_ERR_COUNT,     0xF, 0x0);
	wr(BAR0_BASE + DMA_PAYLOAD_SIZE,      0xF, 0x8020);

	comment("\n-------------------------------------------------------------------------------");
	comment("Setup the DMA microcode");
	comment("-------------------------------------------------------------------------------");
	vdma_main();


	comment("\nStart VDMA");
	wr(BAR0_BASE + DMA_SEQ_CSR_REG,  0xF, 0x1);

	comment("\n-------------------------------------------------------------------------------");
	comment("Wait for an Interrupt for Channel 0");
	comment("-------------------------------------------------------------------------------");
	gpio_wait(8000, 0x0001, 0x0001);

	comment("Clear the interrupt");

	wr(BAR0_BASE + DMA_SEQ_EVENT_CLR_REG, 0xF, 0x00000001);


	comment("\nRead VDMA idle status");
	rd(BAR0_BASE + DMA_SEQ_CSR_REG,  0xF, 0x00000000, 0xFFFFFFFF);

	flush(5000);

	wait(16);

//================================================================================================
//== END of user script
//================================================================================================



	fclose(outfp);
	exit(0);


}


