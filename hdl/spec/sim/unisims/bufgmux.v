// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/BUFGMUX.v,v 1.12 2007/05/23 21:43:33 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Global Clock Mux Buffer with Output State 0
// /___/   /\     Filename : BUFGMUX.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:14 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps

module BUFGMUX (O, I0, I1, S);

    output O;

    input  I0, I1, S;

    reg q0, q1;
    reg q0_enable, q1_enable;

    tri0 GSR = glbl.GSR;

    bufif1 B0 (O, I0, q0);
    bufif1 B1 (O, I1, q1);
    pulldown P1 (O);

	always @(GSR or I0 or S or q0_enable)
 	    if (GSR)
		q0 <= 1;
 	    else if (!I0)
		q0 <= !S && q0_enable;

	always @(GSR or I1 or S or q1_enable)
 	    if (GSR)
		q1 <= 0;
 	    else if (!I1)
		q1 <= S && q1_enable;

	always @(GSR or q1 or I0)
 	    if (GSR)
		q0_enable <= 1;
	    else if (q1)
		q0_enable <= 0;
	    else if (I0)
		q0_enable <= !q1;

	always @(GSR or q0 or I1)
 	    if (GSR)
		q1_enable <= 0;
	    else if (q0)
		q1_enable <= 0;
	    else if (I1)
		q1_enable <= !q0;

endmodule
