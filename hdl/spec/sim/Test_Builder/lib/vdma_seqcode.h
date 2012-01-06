//---------------------------------------------------------------------------
/*
 * Name:  vdma_seqcode.h
 *
 * Description:  FlexDMA sequencer instruction macros.
 *
*/

#ifndef _VDMA_SEQCODE_H_
#define _VDMA_SEQCODE_H_

//Warning message during compilation to indicate macros are used
#pragma message("***** VDMA_CODE_GEN_MACRO is defined *****")

#ifndef DWORD
#define DWORD unsigned long 
#endif

/*************************************************

    VDMA sequencer code Definitions

*************************************************/
#define _IM (0)
#define _RA (2)
#define _RB (3)

//Condition code for JMP instruction
#define _RA_EQZ (0x8)
#define _RA_NEQZ (0)
#define _RB_EQZ (0x9)
#define _RB_NEQZ (1)
#define _ALWAYS (0xA)
#define _NEVER (0x2)
#define _C_HI (0xB)
#define _C_LO (0x3)
#define _PDM_CMD_QUEUE_FULL_HI (0xC)
#define _PDM_CMD_QUEUE_FULL_LO (0x4)
#define _LDM_CMD_QUEUE_FULL_HI (0xD)
#define _LDM_CMD_QUEUE_FULL_LO (0x5)
#define _EXT_COND_HI (0xF)
#define _EXT_COND_LO (0x7)

//External condition select code for JMP instruction
#define _PDM_IDLE (32)
#define _LDM_IDLE (33)
#define _EXT_COND_0 (34)
#define _EXT_COND_1 (35)
#define _EXT_COND_2 (36)
#define _EXT_COND_3 (37)
#define _EXT_COND_4 (38)
#define _EXT_COND_5 (39)
#define _EXT_COND_6 (40)
#define _EXT_COND_7 (41)
#define _EXT_COND_8 (42)
#define _EXT_COND_9 (43)
#define _EXT_COND_10 (44)
#define _EXT_COND_11 (45)
#define _EXT_COND_12 (46)
#define _EXT_COND_13 (47)
#define _EXT_COND_14 (48)
#define _EXT_COND_15 (49)

// VDMA instructions
#define VDMA_NOP() \
    ((DWORD)0x0)

#define VDMA_LOAD_SYS_ADDR(R, ADDR) \
    ((DWORD)0x40000000 |    \
     ((DWORD)(R & 0x3) << 24) | \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_STORE_SYS_ADDR(R, ADDR) \
    ((DWORD)0x50000000 |    \
     ((DWORD)(R & 0x3) << 24) | \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_ADD_SYS_ADDR(DATA) \
    ((DWORD)0x60000000 |    \
     ((DWORD)(DATA & 0xFFFF)) \
    )

#define VDMA_ADD_SYS_ADDR_I(ADDR) \
    ((DWORD)0xE0000000 |    \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_LOAD_XFER_CTL(R, ADDR) \
    ((DWORD)0xF0000000 |    \
     ((DWORD)(R & 0x3) << 24) | \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_LOAD_RA(ADDR) \
    ((DWORD)0x20000000 |    \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_ADD_RA(ADDR) \
    ((DWORD)0x21000000 |    \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_LOAD_RB(ADDR) \
    ((DWORD)0x24000000 |    \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_ADD_RB(ADDR) \
    ((DWORD)0x25000000 |    \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_STORE_RA(ADDR) \
    ((DWORD)0xA2000000 |    \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_STORE_RB(ADDR) \
    ((DWORD)0xA3000000 |    \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_JMP(C, EXT_COND, ADDR) \
    ((DWORD)0x10000000 |    \
     (DWORD)((C & 0xF) << 24) | \
     (DWORD) ((EXT_COND & 0xFF) << 16) | \
     ((DWORD)(ADDR & 0xFFFF)) \
    )

#define VDMA_SIG_EVENT(S, A, EVENT_EN) \
    ((DWORD)0x80000000 |    \
     ((DWORD)(S & 0x1) << 27) | \
     ((DWORD)(A & 0x1) << 26) | \
     ((DWORD)(EVENT_EN & 0xFFFF)) \
    )

#define VDMA_WAIT_EVENT(EVENT_EN, EVENT_STATE) \
    ((DWORD)0x90000000 |    \
     ((DWORD)((EVENT_EN & 0xFFF) << 12)) | \
     ((DWORD)(EVENT_STATE & 0xFFF)) \
    )

#endif
