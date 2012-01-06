//***********************************************************************************************
//***********************************************************************************************
//**
//** Name:  simple_dma.c
//**
//** Description:  This is an example test source code used to drive the Lambo TestBench.
//**
//**
//***********************************************************************************************
//***********************************************************************************************

#include "lib/maketest.c" //This inserts the Test_Builder C framework
#include "lambo.h"        //This is for the project specific registers

//===============================================================================================
// Define the Memory Map for the Simulation
//===============================================================================================
#define BAR0_BASE      0xFF00000010000000ll   //rd/wr here generate LB cycles
#define BAR1_BASE      0xFF000000A0000000ll
#define BFM_BAR0_BASE  0x8765432120000000ll   //rd/wr here accesses internal BFM memory
#define BFM_BAR1_BASE  0xBB00000040000000ll
#define VDMA_DRAM_BASE (BAR0_BASE + 0x4000ll) //This is where the microcode will be written

//***********************************************************************************************
//**
//** VDMA Sequencer Microcode:
//**
//**  The following microcode will get compiled and converted into a series of write cycles
//**  so that the BFM will write the microcode into descriptor memory. The last function call
//**  vdma_process() will cross reference all of the labels in the source code so that you
//**  end up with the proper hexadecimal values that need to be written to descriptor RAM.
//**
//***********************************************************************************************
void vdma_main()
{

//===============================================================================================
// START of the main program loop
//===============================================================================================

// Example source code to be compiled into VDMA binarys or test bench script
	vdma_org(0x0000);
	vdma_label("MAIN");
		vdma_nop();
	vdma_label("DO_L2P0");
		vdma_load_sys_addr(_IM,"L2P0_SYS_ADDR");  //Load system address from SG entry
		vdma_load_xfer_ctl(_IM,"L2P0_XFER_CTL");  //Start DMA0
	vdma_label("DO_L2P1");
		vdma_load_sys_addr(_IM,"L2P1_SYS_ADDR");  //Load system address from SG entry
		vdma_load_xfer_ctl(_IM,"L2P1_XFER_CTL");  //Start DMA1
	vdma_label("WAIT4IDLE");
		vdma_jmp(_EXT_COND_LO,_LDM_IDLE,"WAIT4IDLE"); //Loop until DMA idle
		vdma_sig_event(0, 1, 0x0001);
	vdma_label("FOREVER");
		vdma_nop();
		vdma_jmp(_ALWAYS, 0,"FOREVER");	          //Loop forever

//===============================================================================================
// END of the main program loop
//===============================================================================================

// 
//-----------------------------------------------------------------------------------------------
// Constants
//-----------------------------------------------------------------------------------------------
	vdma_org(0x0100);
	vdma_label("L2P0_SYS_ADDR");
		vdma_constant_n64(BFM_BAR0_BASE+0x200); //L2P0 system address low/hi
	vdma_label("L2P0_XFER_CTL");
		vdma_constant_n(0x00010080);	//L2P0 transfer control: 128B, STREAM_ID=1
	vdma_label("L2P1_SYS_ADDR");
		vdma_constant_n64(BFM_BAR1_BASE+0x200); //L2P1 system address low/hi
	vdma_label("L2P1_XFER_CTL");
		vdma_constant_n(0x00040080);	//L2P1 transfer control: 128B, STREAM_ID=4

//===============================================================================================
// Must run vdma_process to resolve the cross-references and generate the memory writes
//===============================================================================================
	vdma_process(VDMA_DRAM_BASE);  // This actually printfs the data to the file

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

	comment("\n-------------------------------------------------------------------------------");
	comment("DO some setup");
	comment("-------------------------------------------------------------------------------");
	comment("Lambo setup...");

	rd(BAR0_BASE + DMA_SEQ_CSR_REG,       0xF, 0x00000000, 0xFFFFFFFF);
	flush(0x100);
	wr(BAR0_BASE + DMA_SEQ_DPTR_REG,      0xF, 0x0);
	wr(BAR0_BASE + DMA_SEQ_EVENT_EN_REG,  0xF, 0x1);
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

	gpio_wait(300, 0x0001, 0x0001);

	comment("\nRead VDMA idle status");
	rd(BAR0_BASE + DMA_SEQ_CSR_REG,  0xF, 0x00000000, 0xFFFFFFFF);

	flush(256);
	wait(16);
//================================================================================================
//== END of user script
//================================================================================================
	fclose(outfp);
	exit(0);

}

