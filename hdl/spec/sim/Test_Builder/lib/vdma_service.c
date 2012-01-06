//***********************************************************************************************
//***********************************************************************************************
//**
//** Name:  vdma_service.c
//**
//** Description:  General-Purpose DMA Servicing Routines for a 3DW list and a 4DW list.
//**
//**  The following function calls will get invoked from a main program.  When the main program 
//**  is compiled and converted, it will result in a series of write cycles that the BFM 
//**  will write to the microcode descriptor memory. 
//**
//***********************************************************************************************


int data_address = 0;  //This will be used to track the data space

//***********************************************************************************************
//**
//** vdma_channel_service_3: This is a generic channel servicing function for 3DW list type. 
//**                         Should be called once for each channel.
//**
//***********************************************************************************************

void vdma_channel_service_3
(
	char *base_label,       //label to be used for this specific channel
	char direction,         //direction='l' for l2p or 'p' for p2l
	int event_reg,          //The event register bit to be used for interrupt generation
	int ext_cond,           //External condition used for this channel
	int condition,          //Set to either _EXT_COND_LO or _EXT_COND_HI
	int dynamic_list,       //set to non zero when the list will be updated dynamicaly
	int sg_size,            //SYS_ADDR step size of list entries that have a repeat count
	struct sg_entry_struct *sg_list
)
{
	int cmd_queue_full;
	int tmp_address;
	int i;

	if(direction == 'p')
		cmd_queue_full = _PDM_CMD_QUEUE_FULL_HI;
	else
		cmd_queue_full = _LDM_CMD_QUEUE_FULL_HI;

	//---------------------------------------------------------------------------------------------
	// Create the program microcode for this channel
	//---------------------------------------------------------------------------------------------
	vdma_label(base_label);
		vdma_jmp(condition, ext_cond, string_cat(base_label, "_END"));    //Skip if servicing not required
		vdma_jmp(cmd_queue_full, 0, string_cat(base_label, "_END"));      //Skip if dma is busy
		vdma_load_rb(string_cat(base_label, "_INDEX"));                   //Load the SG list pointer
		vdma_load_sys_addr(_RB,"0x0");                                    //Load system address from SG entry
		vdma_load_xfer_ctl(_RB,"0x2");                                    //Start DMA1
		vdma_jmp(_C_LO, 0, string_cat(base_label, "_NO_INT"));            //Need to assert an interrupt?

		vdma_sig_event(0, 1, 1<<event_reg);                               //Assert EVENT(event_reg)
		vdma_load_xfer_ctl(_IM,"ZERO");                                   //Clear C bit

	vdma_label(string_cat(base_label, "_NO_INT"));
		if(dynamic_list)
		{
			vdma_load_sys_addr(0,"ZERO");                                 //Clear the system address register
			vdma_store_sys_addr(_RB,"0x1");                               //Clear the VDMA_XFER_CTL entry in SG list
		}
		vdma_add_rb("THREE");                                             //Advance SG list pointer
		vdma_load_ra(string_cat(base_label, "_CNT"));                     //Load the SG list pointer
		vdma_add_ra("MINUS1");                                            //Subtract 1 from L2P SG list counter
		vdma_jmp(_RA_NEQZ, 0, string_cat(base_label, "_UPDATE"));         //See if the list needs to wrap around

		vdma_load_ra(string_cat(base_label, "_SIZE"));                    //Restart the list counter
		vdma_load_rb(string_cat(base_label, "_BASE"));                    //Restart the list pointer

	vdma_label(string_cat(base_label, "_UPDATE"));
		vdma_store_ra(string_cat(base_label, "_CNT"));                    //Update _CNT
		vdma_store_rb(string_cat(base_label, "_INDEX"));                  //Update _INDEX

	vdma_label(string_cat(base_label, "_END"));

	//---------------------------------------------------------------------------------------------
	// Create the data space for this channel
	//---------------------------------------------------------------------------------------------
	tmp_address = program_address;                  //Save away the current program address
	vdma_org(data_address);

	//-----------------------------------------------
	// Local constants
	//-----------------------------------------------
	vdma_label(string_cat(base_label, "_SIZE"));
		vdma_constant_n(sg_size);
	vdma_label(string_cat(base_label, "_BASE"));
		vdma_constant_l(string_cat(base_label, "_LIST"));
	//-----------------------------------------------
	// Local variables
	//-----------------------------------------------
	vdma_label(string_cat(base_label, "_INDEX"));
		vdma_constant_l(string_cat(base_label, "_LIST"));
	vdma_label(string_cat(base_label, "_CNT"));
		vdma_constant_n(sg_size);

	//-----------------------------------------------
	// SG List storage
	//-----------------------------------------------
	vdma_label(string_cat(base_label, "_LIST"));
		for(i=0; i<sg_size; i++)
		{
			vdma_constant_n64(sg_list[i].address);
			vdma_constant_n(  sg_list[i].vdma_xfer_ctl);
		}

	data_address = program_address;                 //Save back the current data address
	vdma_org(tmp_address);                          //Restore the program address
	
}

//***********************************************************************************************
//**
//** vdma_channel_service4: This is a generic channel servicing function for use with 4DW list type. 
//**
//***********************************************************************************************

void vdma_channel_service_4
(
	char *base_label,       //label to be used for this specific channel
	char direction,         //direction='l' for l2p or 'p' for p2l
	int event_reg,          //The event register bit to be used for interrupt generation
	int ext_cond,           //External condition used for this channel
	int condition,          //Set to either _EXT_COND_LO or _EXT_COND_HI
	int dynamic_list,       //set to non zero when the list will be updated dynamicaly
	int sg_size,            //SYS_ADDR step size of list entries that have a repeat count
	int sys_addr_increment, //Step size of list entries that have a repeat count
	struct sg_entry_struct *sg_list
)
{
	int cmd_queue_full;
	int tmp_address;
	int i;

	if(direction == 'p')
		cmd_queue_full = _PDM_CMD_QUEUE_FULL_HI;
	else
		cmd_queue_full = _LDM_CMD_QUEUE_FULL_HI;

	//---------------------------------------------------------------------------------------------
	// Create the program microcode for this channel
	//---------------------------------------------------------------------------------------------
	vdma_label(base_label);
		vdma_jmp(_EXT_COND_LO, ext_cond, string_cat(base_label, "_END")); //Skip if servicing not required
		vdma_jmp(cmd_queue_full, 0, string_cat(base_label, "_END"));      //Skip if dma is busy



		vdma_load_rb(string_cat(base_label, "_INDEX"));                   //Load the SG list pointer
		vdma_load_ra(string_cat(base_label, "_RPT"));                     //Load the previous repeat counter
		vdma_jmp(_RA_NEQZ, 0, string_cat(base_label, "_RPT_NOT_DONE"));   //jmp if previous repeat not done

		vdma_load_sys_addr(_RB,"0x3");                                    //Load repeat count from SG entry
		vdma_store_sys_addr(_IM,string_cat(base_label, "_RPT"));          //Store to repeat count variable
		vdma_load_ra(string_cat(base_label, "_RPT"));                     //Load the new repeat counter
		vdma_jmp(_RA_EQZ, 0, string_cat(base_label, "_NEXT_DESC"));       //jmp if the rpt=0

		vdma_load_sys_addr(_RB,"0x0");                                    //Load system address from SG entry
		vdma_store_sys_addr(_IM,string_cat(base_label, "_SYSA"));         //Store sys address to local variable

	vdma_label(string_cat(base_label, "_RPT_NOT_DONE"));
		vdma_add_ra("MINUS1");                                            //Decrement the repeat counter
		vdma_load_sys_addr(_IM,string_cat(base_label, "_SYSA"));          //Load system address from local variable
		vdma_load_xfer_ctl(_RB,"0x2");                                    //Start DMA1
		vdma_jmp(_C_LO, 0, string_cat(base_label, "_NO_INT"));            //No interrupt if C=0 
		vdma_jmp(_RA_NEQZ, 0, string_cat(base_label, "_NO_INT"));         //No interrupt if RA!=0

		vdma_sig_event(0, 1, 1<<event_reg);                               //Assert EVENT(event_reg)
		vdma_load_xfer_ctl(_IM,"ZERO");                                   //Clear C bit

	vdma_label(string_cat(base_label, "_NO_INT"));
		vdma_store_ra(string_cat(base_label, "_RPT"));                    //Update _RPT
		vdma_add_sys_addr(sys_addr_increment);                            //update the system address
		vdma_store_sys_addr(_IM,string_cat(base_label, "_SYSA"));         //Store updated sys address to local variable

		vdma_jmp(_RA_NEQZ, 0, string_cat(base_label, "_UPDATE_B"));       //jmp if repeat count not done

		if(dynamic_list)
		{
			vdma_load_sys_addr(0,"ZERO");                                 //Clear the system address register
			vdma_store_sys_addr(_RB,"0x2");                               //Clear the VDMA_XFER_CTL entry in SG list
		}

	vdma_label(string_cat(base_label, "_NEXT_DESC"));
		vdma_add_rb("FOUR");                                              //Advance SG list pointer
		vdma_load_ra(string_cat(base_label, "_CNT"));                     //Load the SG list counter
		vdma_add_ra("MINUS1");                                            //Subtract 1 from L2P SG list counter
		vdma_jmp(_RA_NEQZ, 0, string_cat(base_label, "_UPDATE"));         //See if the list needs to wrap around
		vdma_load_ra(string_cat(base_label, "_SIZE"));                    //Restart the list counter
		vdma_load_rb(string_cat(base_label, "_BASE"));                    //Restart the list pointer

	vdma_label(string_cat(base_label, "_UPDATE"));
		vdma_store_ra(string_cat(base_label, "_CNT"));                    //Update _CNT
	vdma_label(string_cat(base_label, "_UPDATE_B"));
		vdma_store_rb(string_cat(base_label, "_INDEX"));                  //Update _INDEX

	vdma_label(string_cat(base_label, "_END"));

	//---------------------------------------------------------------------------------------------
	// Create the data space for this channel
	//---------------------------------------------------------------------------------------------
	tmp_address = program_address;                  //Save away the current program address
	vdma_org(data_address);

	
	//-----------------------------------------------
	// Local constants
	//-----------------------------------------------
	vdma_label(string_cat(base_label, "_SIZE"));
		vdma_constant_n(sg_size);
	vdma_label(string_cat(base_label, "_BASE"));
		vdma_constant_l(string_cat(base_label, "_LIST"));
	//-----------------------------------------------
	// Local variables
	//-----------------------------------------------
	vdma_label(string_cat(base_label, "_INDEX"));
		vdma_constant_l(string_cat(base_label, "_LIST"));
	vdma_label(string_cat(base_label, "_CNT"));
		vdma_constant_n(sg_size);
	vdma_label(string_cat(base_label, "_RPT"));
		vdma_constant_n(0);
		vdma_constant_n(0); //Need to pad out the repeat count
	vdma_label(string_cat(base_label, "_SYSA"));
		vdma_constant_n64(0);

	//-----------------------------------------------
	// SG List storage
	//-----------------------------------------------
	vdma_label(string_cat(base_label, "_LIST"));
		for(i=0; i<sg_size; i++)
		{
			vdma_constant_n64(sg_list[i].address);
			vdma_constant_n(  sg_list[i].vdma_xfer_ctl);
			vdma_constant_n(  sg_list[i].vdma_xfer_rpt);
		}


	data_address = program_address;                 //Save back the current data address
	vdma_org(tmp_address);                          //Restore the program address
	
}


