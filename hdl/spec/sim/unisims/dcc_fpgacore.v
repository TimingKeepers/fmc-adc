// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/DCC_FPGACORE.v,v 1.7 2007/05/23 23:44:42 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Digital Configuration Controller for FPGACORE
// /___/   /\     Filename : DCC_FPGACORE.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:15 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Added wire declaration for internal signals.

`timescale 1 ns / 1 ps 

module DCC_FPGACORE (
	BCLK,
	DONEOUT,
	DOUT0,
	DOUT1,
	DOUT2,
	DOUT3,
	DOUT4,
	DOUT5,
	DOUT6,
	DOUT7,
	GSR,
	GTS,
	GWE,
	INITBOUT,
	TDO,
	CCLK,
	CSB,
	DIN0,
	DIN1,
	DIN2,
	DIN3,
	DIN4,
	DIN5,
	DIN6,
	DIN7,
	DONEIN,
	LBISTISOLATEB,
	M0,
	M1,
	M2,
	PROGB,
	TCK,
	TDI,
	TMS,
	WRITEB
);

parameter DEVICE_SIZE = 9'd10;

output BCLK;
output DONEOUT;
output DOUT0;
output DOUT1;
output DOUT2;
output DOUT3;
output DOUT4;
output DOUT5;
output DOUT6;
output DOUT7;
output GSR;
output GTS;
output GWE;
output INITBOUT;
output TDO;

reg BCLK_REG;
reg DONEOUT_REG;
reg DOUT0_REG;
reg DOUT1_REG;
reg DOUT2_REG;
reg DOUT3_REG;
reg DOUT4_REG;
reg DOUT5_REG;
reg DOUT6_REG;
reg DOUT7_REG;
reg GSR_REG;
reg GTS_REG;
reg GWE_REG;
reg INITBOUT_REG;
reg TDO_REG;

input CCLK;
input CSB;
input DIN0;
input DIN1;
input DIN2;
input DIN3;
input DIN4;
input DIN5;
input DIN6;
input DIN7;
input DONEIN;
input LBISTISOLATEB;
input M0;
input M1;
input M2;
input PROGB;
input TCK;
input TDI;
input TMS;
input WRITEB;

wire CCLK_IN;
wire CSB_IN;
wire DIN0_IN;
wire DIN1_IN;
wire DIN2_IN;
wire DIN3_IN;
wire DIN4_IN;
wire DIN5_IN;
wire DIN6_IN;
wire DIN7_IN;
wire DONEIN_IN;
wire LBISTISOLATEB_IN;
wire M0_IN;
wire M1_IN;
wire M2_IN;
wire PROGB_IN;
wire TCK_IN;
wire TDI_IN;
wire TMS_IN;
wire WRITEB_IN;

wire BCLK_OUT;
wire DONEOUT_OUT;
wire DOUT0_OUT;
wire DOUT1_OUT;
wire DOUT2_OUT;
wire DOUT3_OUT;
wire DOUT4_OUT;
wire DOUT5_OUT;
wire DOUT6_OUT;
wire DOUT7_OUT;
wire GSR_OUT;
wire GTS_OUT;
wire GWE_OUT;
wire INITBOUT_OUT;
wire TDO_OUT;

reg notifier;

initial begin
        case (DEVICE_SIZE)
                10 : ;
                20 : ;
                40 : ;
                default : begin
                        $display("Attribute Syntax Error : The Attribute DEVICE_SIZE on X_DCC_FPGACORE instance %m is set to %d.  Legal values for this attribute are 10, 20 or 40.", DEVICE_SIZE);
                        $finish;
                end
        endcase

end

buf B_BCLK (BCLK, BCLK_REG);
buf B_DONEOUT (DONEOUT, DONEOUT_REG);
buf B_DOUT0 (DOUT0, DOUT0_REG);
buf B_DOUT1 (DOUT1, DOUT1_REG);
buf B_DOUT2 (DOUT2, DOUT2_REG);
buf B_DOUT3 (DOUT3, DOUT3_REG);
buf B_DOUT4 (DOUT4, DOUT4_REG);
buf B_DOUT5 (DOUT5, DOUT5_REG);
buf B_DOUT6 (DOUT6, DOUT6_REG);
buf B_DOUT7 (DOUT7, DOUT7_REG);
buf B_GSR (GSR, GSR_REG);
buf B_GTS (GTS, GTS_REG);
buf B_GWE (GWE, GWE_REG);
buf B_INITBOUT (INITBOUT, INITBOUT_REG);
buf B_TDO (TDO, TDO_REG);

buf B_CCLK (CCLK_IN, CCLK);
buf B_CSB (CSB_IN, CSB);
buf B_DIN0 (DIN0_IN, DIN0);
buf B_DIN1 (DIN1_IN, DIN1);
buf B_DIN2 (DIN2_IN, DIN2);
buf B_DIN3 (DIN3_IN, DIN3);
buf B_DIN4 (DIN4_IN, DIN4);
buf B_DIN5 (DIN5_IN, DIN5);
buf B_DIN6 (DIN6_IN, DIN6);
buf B_DIN7 (DIN7_IN, DIN7);
buf B_DONEIN (DONEIN_IN, DONEIN);
buf B_LBISTISOLATEB (LBISTISOLATEB_IN, LBISTISOLATEB);
buf B_M0 (M0_IN, M0);
buf B_M1 (M1_IN, M1);
buf B_M2 (M2_IN, M2);
buf B_PROGB (PROGB_IN, PROGB);
buf B_TCK (TCK_IN, TCK);
buf B_TDI (TDI_IN, TDI);
buf B_TMS (TMS_IN, TMS);
buf B_WRITEB (WRITEB_IN, WRITEB);

DCC_FPGACORE_SWIFT dcc_fpgacore_swift_1 (
	.CCLK (CCLK_IN),
	.CSB (CSB_IN),
	.DIN0 (DIN0_IN),
	.DIN1 (DIN1_IN),
	.DIN2 (DIN2_IN),
	.DIN3 (DIN3_IN),
	.DIN4 (DIN4_IN),
	.DIN5 (DIN5_IN),
	.DIN6 (DIN6_IN),
	.DIN7 (DIN7_IN),
	.DONEIN (DONEIN_IN),
	.LBISTISOLATEB (LBISTISOLATEB_IN),
	.M0 (M0_IN),
	.M1 (M1_IN),
	.M2 (M2_IN),
	.PROGB (PROGB_IN),
	.TCK (TCK_IN),
	.TDI (TDI_IN),
	.TMS (TMS_IN),
	.WRITEB (WRITEB_IN),
	.XBID (DEVICE_SIZE),
	.BCLK (BCLK_OUT),
	.DONEOUT (DONEOUT_OUT),
	.DOUT0 (DOUT0_OUT),
	.DOUT1 (DOUT1_OUT),
	.DOUT2 (DOUT2_OUT),
	.DOUT3 (DOUT3_OUT),
	.DOUT4 (DOUT4_OUT),
	.DOUT5 (DOUT5_OUT),
	.DOUT6 (DOUT6_OUT),
	.DOUT7 (DOUT7_OUT),
	.GSR (GSR_OUT),
	.GTS (GTS_OUT),
	.GWE (GWE_OUT),
	.INITBOUT (INITBOUT_OUT),
	.TDO (TDO_OUT)
);

always @(M0 or M1 or M2) begin
	if (PROGB == 1'b1)
	        $display("Timing Violation Error : The M0, M1 and M2 inputs has changed during configuration, when PROGB input is high.  The Mode pins must remain stable to ensure correct configuration.");
end

always @(BCLK_OUT) begin
	BCLK_REG <= BCLK_OUT;
end

always @(DONEOUT_OUT) begin
	DONEOUT_REG <= DONEOUT_OUT;
end

always @(DOUT0_OUT) begin
	DOUT0_REG <= DOUT0_OUT;
end

always @(DOUT1_OUT) begin
	DOUT1_REG <= DOUT1_OUT;
end

always @(DOUT2_OUT) begin
	DOUT2_REG <= DOUT2_OUT;
end

always @(DOUT3_OUT) begin
	DOUT3_REG <= DOUT3_OUT;
end

always @(DOUT4_OUT) begin
	DOUT4_REG <= DOUT4_OUT;
end

always @(DOUT5_OUT) begin
	DOUT5_REG <= DOUT5_OUT;
end

always @(DOUT6_OUT) begin
	DOUT6_REG <= DOUT6_OUT;
end

always @(DOUT7_OUT) begin
	DOUT7_REG <= DOUT7_OUT;
end

always @(GSR_OUT) begin
	GSR_REG <= GSR_OUT;
end

always @(GTS_OUT) begin
	GTS_REG <= GTS_OUT;
end

always @(GWE_OUT) begin
	GWE_REG <= GWE_OUT;
end

always @(INITBOUT_OUT) begin
	INITBOUT_REG <= INITBOUT_OUT;
end

always @(TDO_OUT) begin
	TDO_REG <= TDO_OUT;
end


endmodule
