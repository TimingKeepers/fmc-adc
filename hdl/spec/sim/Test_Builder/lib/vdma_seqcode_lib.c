//---------------------------------------------------------------------------
/*
 * Name:  vdma_seqcode_lib.h
 *
 * Description:  FlexDMA sequencer functions used for the first pass compile.
 *
*/


// Data structure for a 3 or 4 word scatter/gather entry
struct sg_entry_struct 
{
	U64 address;
	U32 vdma_xfer_ctl;
	U32 vdma_xfer_rpt; /* in a 3-word SG entry this is unused */
};

 

//================================================================================================
//
// Note: all references are symbolic at this level
//
//================================================================================================

void next_address()
{
//fprintf(stderr, "program_address=0x%04X\n", program_address);
	program_address++;
	if(dram[program_address].label != NULL)
	{
		fprintf(stderr, "WARNING: next program_address 0x%04X has already been used\n", program_address);
	}
	sprintf(last_label, "%s ", "");
	if(program_address >= VDMA_DRAM_SIZE)
	{
		fprintf(stderr, "ERROR: descriptor RAM address (%d) exceeded maximum (max=%d)\n", program_address, VDMA_DRAM_SIZE);
		exit(-91);
	}
}

char *r_to_string(int r)
{
	switch(r)
	{
		case _IM:
			return("_IM");
			break;
		case _RA:
			return("_RA");
			break;
		case _RB:
			return("_RB");
			break;
		default:
			return("ERROR");
	}
}

char *c_to_string(int c)
{
	switch(c)
	{
		case _RA_EQZ:
			return("_RA_EQZ");
			break;
		case _RA_NEQZ:
			return("_RA_NEQZ");
			break;
		case _RB_EQZ:
			return("_RB_EQZ");
			break;
		case _RB_NEQZ:
			return("_RB_NEQZ");
			break;
		case _ALWAYS:
			return("_ALWAYS");
			break;
		case _NEVER:
			return("_NEVER");
			break;
		case _C_HI:
			return("_C_HI");
			break;
		case _C_LO:
			return("_C_LO");
			break;
		case _PDM_CMD_QUEUE_FULL_HI:
			return("_PDM_CMD_QUEUE_FULL_HI");
			break;
		case _PDM_CMD_QUEUE_FULL_LO:
			return("_PDM_CMD_QUEUE_FULL_LO");
			break;
		case _LDM_CMD_QUEUE_FULL_HI:
			return("_LDM_CMD_QUEUE_FULL_HI");
			break;
		case _LDM_CMD_QUEUE_FULL_LO:
			return("_LDM_CMD_QUEUE_FULL_LO");
			break;
		case _EXT_COND_HI:
			return("_EXT_COND_HI");
			break;
		case _EXT_COND_LO:
			return("_EXT_COND_LO");
			break;
		default:
			return("ERROR");
	}
}

char *ext_cond_to_string(int e, int c)
{
	static char estr[20];
	if((c == _EXT_COND_HI) || (c == _EXT_COND_LO))
	{
		switch(e)
		{
			case _PDM_IDLE:
				return("_PDM_IDLE");
				break;
			case _LDM_IDLE:
				return("_LDM_IDLE");
				break;
			default:
				if((e >= 0) && (e <= 15))
				{
					sprintf(estr, "_EVENT_%d", e);
					return(estr);
				} else if(e >= _EXT_COND_0)
				{
					sprintf(estr, "_EXT_COND_%d", e - _EXT_COND_0);
					return(estr);
				} else
				{
					return("ERROR");
				}
				break;
		}
	}
	return("NA");
}

//================================================================================================
//
// string_cat(char *base, char *extension): create a new string by concatenating two strings
//
//================================================================================================
char *string_cat(char *beginning, char *end)
{
	char *ptr;
	ptr = (char *) malloc(strlen(beginning)+strlen(end)+1);
	if(ptr == NULL)
	{
		fprintf(stderr, "ERROR: could not allocate memory in function string_cat\n");
		exit(111);
	}
	sprintf(ptr, "%s%s", beginning, end);
	return(ptr);
}

//================================================================================================
//
// vdma_org(int address): change the program pointer to address
//
//================================================================================================
void vdma_org(int address)
{
	program_address = address; 
}



//================================================================================================
//
// vdma_label_lookup(char *str, int *value): find a label and store its value at *value.
//
//================================================================================================
int vdma_label_lookup(char *str, int *value)
{
	int i;
	for(i = 0; i < label_pointer; i++)
	{
		if(label_compare(str, vdma_labels[i].label))
		{
			*value = vdma_labels[i].address;
			return(1);
		}
	}
	return(0);
}

//================================================================================================
//
// vdma_label(char *label): set a label at the current address
//
//================================================================================================
void vdma_label(char *label)
{
	int i;
fprintf(stderr, "Label[%d]: %s=0x%04X\n", label_pointer, label, program_address);
	if(strlen(label) > MAX_LABEL_SIZE)
	{
		fprintf(stderr, "ERROR: label \"%s\" exceedes the maximum length of %d\n", label, MAX_LABEL_SIZE);
		exit(-89);
	}
	if(label_pointer !=0)
	{
		/* make sure the label has not been previously declared */
		for(i = 0; i < label_pointer; i++)
		{
//fprintf(stderr, "label_compare(label=%s, vdma_labels[i=%d].label=%s)\n", label, i, vdma_labels[i].label);
			if(label_compare(label, vdma_labels[i].label))
			{
//fprintf(stderr, "label_compare(label=%s, vdma_labels[i=%d].label=%s)\n", label, i, vdma_labels[i].label);
				fprintf(stderr, "ERROR: the label \"%s\" has already been declared at label[%d] with address=0x%04X\n", label, i, vdma_labels[i].address);
				break;
			}
		}
	}

	vdma_labels[label_pointer].address = program_address;
	vdma_labels[label_pointer].label   = label;
	sprintf(last_label, "%s:", label);
	label_pointer++;
	if(label_pointer >= MAX_LABELS)
	{
		fprintf(stderr, "ERROR: to many labels specified (max=%d)\n", MAX_LABELS);
		exit(-90);
	}
}

//================================================================================================
//
// vdma_constant_l(char *label): set a constant to equal the address value of a label
//
//================================================================================================
void vdma_constant_l(char *label)
{
	dram[program_address].data    = 0;
	dram[program_address].label   = label;
	sprintf(dram[program_address].comment, "%24s vdma_constant_l(\"%s\")", last_label, label);
	next_address();
}

//================================================================================================
//
// vdma_constant_n(DWORD data): set a constant to a numerical value at the current address
//
//================================================================================================
void vdma_constant_n(DWORD data)
{
	dram[program_address].data  = data;
	dram[program_address].label = "";
	sprintf(dram[program_address].comment, "%24s vdma_constant_n(0x%08lX)", last_label, data);
	next_address();
}

//================================================================================================
//
// vdma_constant_n64(U64 data): same as vdma_constant_n except for 64-bit data 
//
//================================================================================================
void vdma_constant_n64(U64 data)
{
	DWORD d32;
	d32 = data & 0xFFFFFFFF;
	dram[program_address].data  = d32;
	dram[program_address].label = "";
	sprintf(dram[program_address].comment, "%24s vdma_constant_n64(0x%016llX)", last_label, data);
	next_address();


	d32 = (DWORD)(data >> (U64) 32);
	dram[program_address].data  = d32;
	dram[program_address].label = "";
	sprintf(dram[program_address].comment, "%24s // vdma_constant_n64 - upper data", last_label);
	next_address();
}

//================================================================================================
//
// vdma_array(DWORD data, int n): initializes an array of data at the current address with the same data
//
//================================================================================================
void vdma_array(DWORD data, int n)
{
	int i;
	for(i=0; i<n; i++)
	{
		dram[program_address].data  = data;
		dram[program_address].label = "";
		if(i==0)
			sprintf(dram[program_address].comment, "%24s vdma_array(0x%lX, %d)", last_label, data, n);
		else
			sprintf(dram[program_address].comment, "%24s // %s[%d]", "", vdma_labels[label_pointer-1].label, i);
		next_address();
	}
}

//************************************************************************************************
//
// all functions from here on map directly to the VDMA instructions documented in the 
// GN412x FlexDMA Sequencer Design Guide except that all addresses are specified using labels.
//
//************************************************************************************************
void vdma_nop()
{
	dram[program_address].data  = VDMA_NOP();
	dram[program_address].label = "";
	sprintf(dram[program_address].comment, "%24s vdma_nop()", last_label);
	next_address();
}

 void vdma_load_sys_addr(int r, char *label)
{
	dram[program_address].data  = VDMA_LOAD_SYS_ADDR(r, 0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_load_sys_addr(r=%s, \"%s\")", last_label, r_to_string(r), label);
	next_address();
}
 void vdma_store_sys_addr(int r, char *label)
{
	dram[program_address].data  = VDMA_STORE_SYS_ADDR(r, 0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_store_sys_addr(r=%s, \"%s\")", last_label, r_to_string(r), label);
	next_address();
}
 void vdma_add_sys_addr(int data)
{
	dram[program_address].data  = VDMA_ADD_SYS_ADDR(data);
	dram[program_address].label = "";
	sprintf(dram[program_address].comment, "%24s vdma_add_sys_addr(%d)", last_label, data);
	next_address();
}
 void vdma_add_sys_addr_i(char *label)
{
	dram[program_address].data  = VDMA_ADD_SYS_ADDR_I(0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_add_sys_addr_i(\"%s\")", last_label, label);
	next_address();
}
 void vdma_load_xfer_ctl(int r, char *label)
{
	dram[program_address].data  = VDMA_LOAD_XFER_CTL(r, 0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_load_xfer_ctl(%s, \"%s\")", last_label, r_to_string(r), label);
	next_address();
}
 void vdma_load_ra(char *label)
{
	dram[program_address].data  = VDMA_LOAD_RA(0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_load_ra(\"%s\")", last_label, label);
	next_address();
}
 void vdma_add_ra(char *label)
{
	dram[program_address].data  = VDMA_ADD_RA(0);
	sprintf(dram[program_address].comment, "%24s vdma_add_ra(\"%s\")", last_label, label);
	dram[program_address].label = label;
	next_address();
}
 void vdma_load_rb(char *label)
{
	dram[program_address].data  = VDMA_LOAD_RB(0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_load_rb(\"%s\")", last_label, label);
	next_address();
}
 void vdma_add_rb(char *label)
{
	dram[program_address].data  = VDMA_ADD_RB(0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_add_rb(\"%s\")", last_label, label);
	next_address();
}
 void vdma_store_ra(char *label)
{
	dram[program_address].data  = VDMA_STORE_RA(0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_store_ra(\"%s\")", last_label, label);
	next_address();
}
 void vdma_store_rb(char *label)
{
	dram[program_address].data  = VDMA_STORE_RB(0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_store_rb(\"%s\")", last_label, label);
	next_address();
}
 void vdma_jmp(int c, int ext_cond, char *label)
{
	dram[program_address].data  = VDMA_JMP(c, ext_cond, 0);
	dram[program_address].label = label;
	sprintf(dram[program_address].comment, "%24s vdma_jmp(c=%s, ext_cond=%s, \"%s\")", last_label, c_to_string(c), ext_cond_to_string(ext_cond, c), label);
	next_address();
}
 void vdma_sig_event(int s, int a, int event_en)
{
	dram[program_address].data  = VDMA_SIG_EVENT(s, a, event_en);
	dram[program_address].label = "";
	sprintf(dram[program_address].comment, "%24s vdma_sig_event(s=%d, a=%d, event_en=0x%04X)", last_label, s, a, event_en);
	next_address();
}
 void vdma_wait_event(int event_en, int event_state)
{
	dram[program_address].data  = VDMA_WAIT_EVENT(event_en, event_state);
	dram[program_address].label = "";
	sprintf(dram[program_address].comment, "%24s vdma_sig_event(event_en=0x%04X, event_state=0x%04X)", last_label, event_en, event_state);
	next_address();
}


