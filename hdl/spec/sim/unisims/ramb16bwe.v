///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  16K-Bit Data and 2K-Bit Parity Dual Port Block RAM
// /___/   /\     Filename : RAMB16BWE.v
// \   \  /  \    Timestamp : Mon Oct 10 14:55:34 PDT 2005
//  \___\/\___\
//
// Revision:
//    10/10/05 - Initial version.
//    03/08/06 - CR 226003 -- Added Parameter Types (integer/real)
// End Revision

`timescale 1 ps/1 ps

module RAMB16BWE (DOA, DOB, DOPA, DOPB, 
		 ADDRA, ADDRB, CLKA, CLKB, DIA, DIB, DIPA, DIPB, ENA, ENB, SSRA, SSRB, WEA, WEB);

    parameter integer DATA_WIDTH_A = 0;
    parameter integer DATA_WIDTH_B = 0;
    parameter INIT_A = 36'h0;
    parameter INIT_B = 36'h0;
    parameter SIM_COLLISION_CHECK = "ALL";
    parameter SRVAL_A = 36'h0;
    parameter SRVAL_B = 36'h0;
    parameter WRITE_MODE_A = "WRITE_FIRST";
    parameter WRITE_MODE_B = "WRITE_FIRST";
    localparam SETUP_ALL = 1000;
    localparam SETUP_READ_FIRST = 3000;
    
    parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_20 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_21 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_22 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_23 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_24 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_25 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_26 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_27 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_28 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_29 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_2F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_30 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_31 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_32 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_33 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_34 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_35 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_36 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_37 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_38 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_39 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_3F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;

    output [31:0] DOA;
    output [31:0] DOB;
    output [3:0] DOPA;
    output [3:0] DOPB;
    input ENA, CLKA, SSRA;
    input ENB, CLKB, SSRB;
    tri0 GSR = glbl.GSR;
    input [13:0] ADDRA;
    input [13:0] ADDRB;
    input [31:0] DIA;
    input [31:0] DIB;
    input [3:0] DIPA;
    input [3:0] DIPB;
    input [3:0] WEA;
    input [3:0] WEB;


    integer diaw, diaw_1, dipaw, dipaw_1, doaw;
    integer dibw, dibw_1, dipbw, dipbw_1, dobw;
    integer doa_index, dopa_index, dob_index, dopb_index;
    integer doaw_1, dopaw, dopaw_1;
    integer dobw_1, dopbw, dopbw_1;
    integer i_1, i_2, i_3, i_4, i_6, i_7, i_8, i_9, i_10;
    integer i_1p, i_2p, i_3p, i_4p, i_6p, i_7p, i_8p, i_9p, i_10p;
    integer ib_1, ib_2, ib_3, ib_4, ib_6, ib_7, ib_8, ib_9;
    integer ib_1p, ib_2p, ib_3p, ib_4p, ib_6p, ib_7p, ib_8p, ib_9p;
    integer outr1_gsr, outr2_gsr, outrr1_gsr, outrr2_gsr;
    integer outrb1, outrb2, outrbr1_gsr, outrbr2_gsr, outrbr1, outrbr2;   
    integer outrb1_gsr, outrb2_gsr, outrr1, outrr2, outr1, outr2;      
    integer wea_index, web_index;
    reg [10:0] address_parity_read_a_reg, address_parity_read_b_reg;
    reg [10:0] address_parity_write_a_reg, address_parity_write_b_reg;
    reg [13:0] address_read_a_reg, address_read_b_reg;
    reg [13:0] address_write_a_reg, address_write_b_reg;
    reg [2:0]  col_msg_flag;
    reg [31:0] dia_reg, dib_reg;
    reg [31:0] doa_out_col, dob_out_col;
    reg [31:0] out_curr, out_reg;
    reg [3:0] dipa_reg, dipb_reg;
    reg [3:0] dopa_out_col, dopb_out_col;
    reg [3:0] outp_curr, outp_reg;
    reg [3:0] wea_in_sampled_reg, web_in_sampled_reg;
    reg ena_reg, enb_reg;
    time curr_time, prev_time;    
    
    reg [10:0] address_parity_read_a, address_parity_read_b;
    reg [10:0] address_parity_write_a, address_parity_write_b;
    reg [10:0] zero_parity_read_a, zero_parity_read_b;
    reg [10:0] zero_parity_write_a, zero_parity_write_b;
    reg [13:0] address_read_a, address_read_b;
    reg [13:0] address_write_a, address_write_b;
    reg [13:0] zero_read_a, zero_read_b;
    reg [13:0] zero_write_a, zero_write_b;
    reg [18431:0] mem;
    reg [1:0]  wr_mode_a, wr_mode_b;
    reg [31:0] doa_out;
    reg [31:0] doa_out_buf, dob_out_buf;
    reg [31:0] dob_out;
    reg [3:0]  dopa_out_buf, dopb_out_buf;
    reg [3:0] dopa_out;
    reg [3:0] dopb_out;
    reg [8:0] count;
    reg notifier, notifier_a, notifier_b;
    reg ssra_reg, ssrb_reg;
    reg ssra_reg_col, ssrb_reg_col;

    wire [14:0] addra_in;
    wire [14:0] addrb_in;
    wire [31:0] dia_in;
    wire [31:0] dib_in;
    wire [3:0] dipa_in;
    wire [3:0] dipb_in;
    wire [3:0] wea_in, web_in;
    wire [3:0] wea_in_sampled, web_in_sampled;
    wire addra_in_14, addrb_in_14;
    wire clka_in, ena_in, ssra_in;
    wire clkb_in, enb_in, ssrb_in;
    wire dia0_enable = ena_in && wea_in[0];
    wire dia1_enable = ena_in && wea_in[1];
    wire dia2_enable = ena_in && wea_in[2];
    wire dia3_enable = ena_in && wea_in[3];
    wire dib0_enable = enb_in && web_in[0];
    wire dib1_enable = enb_in && web_in[1];
    wire dib2_enable = enb_in && web_in[2];
    wire dib3_enable = enb_in && web_in[3];
    wire doa_out0, doa_out1, doa_out2, doa_out3, doa_out4, doa_out5, doa_out6, doa_out7, doa_out8, doa_out9, doa_out10, doa_out11, doa_out12, doa_out13, doa_out14, doa_out15, doa_out16, doa_out17, doa_out18, doa_out19, doa_out20, doa_out21, doa_out22, doa_out23, doa_out24, doa_out25, doa_out26, doa_out27, doa_out28, doa_out29, doa_out30, doa_out31;
    wire dob_out0, dob_out1, dob_out2, dob_out3, dob_out4, dob_out5, dob_out6, dob_out7, dob_out8, dob_out9, dob_out10, dob_out11, dob_out12, dob_out13, dob_out14, dob_out15, dob_out16, dob_out17, dob_out18, dob_out19, dob_out20, dob_out21, dob_out22, dob_out23, dob_out24, dob_out25, dob_out26, dob_out27, dob_out28, dob_out29, dob_out30, dob_out31;
    wire dopa_out0, dopa_out1, dopa_out2, dopa_out3;
    wire dopb_out0, dopb_out1, dopb_out2, dopb_out3;
    wire gsr_in;
    
    buf b_addra_0 (addra_in[0], ADDRA[0]);
    buf b_addra_1 (addra_in[1], ADDRA[1]);
    buf b_addra_10 (addra_in[10], ADDRA[10]);
    buf b_addra_11 (addra_in[11], ADDRA[11]);
    buf b_addra_12 (addra_in[12], ADDRA[12]);
    buf b_addra_13 (addra_in[13], ADDRA[13]);
    buf b_addra_14 (addra_in[14], 1'b0);
    buf b_addra_2 (addra_in[2], ADDRA[2]);
    buf b_addra_3 (addra_in[3], ADDRA[3]);
    buf b_addra_4 (addra_in[4], ADDRA[4]);
    buf b_addra_5 (addra_in[5], ADDRA[5]);
    buf b_addra_6 (addra_in[6], ADDRA[6]);
    buf b_addra_7 (addra_in[7], ADDRA[7]);
    buf b_addra_8 (addra_in[8], ADDRA[8]);
    buf b_addra_9 (addra_in[9], ADDRA[9]);
    buf b_addrb_0 (addrb_in[0], ADDRB[0]);
    buf b_addrb_1 (addrb_in[1], ADDRB[1]);
    buf b_addrb_10 (addrb_in[10], ADDRB[10]);
    buf b_addrb_11 (addrb_in[11], ADDRB[11]);
    buf b_addrb_12 (addrb_in[12], ADDRB[12]);
    buf b_addrb_13 (addrb_in[13], ADDRB[13]);
    buf b_addrb_14 (addrb_in[14], 1'b0);
    buf b_addrb_2 (addrb_in[2], ADDRB[2]);
    buf b_addrb_3 (addrb_in[3], ADDRB[3]);
    buf b_addrb_4 (addrb_in[4], ADDRB[4]);
    buf b_addrb_5 (addrb_in[5], ADDRB[5]);
    buf b_addrb_6 (addrb_in[6], ADDRB[6]);
    buf b_addrb_7 (addrb_in[7], ADDRB[7]);
    buf b_addrb_8 (addrb_in[8], ADDRB[8]);
    buf b_addrb_9 (addrb_in[9], ADDRB[9]);
    buf b_clka (clka_in, CLKA);
    buf b_clkb (clkb_in, CLKB);
    buf b_dia_0 (dia_in[0], DIA[0]);
    buf b_dia_1 (dia_in[1], DIA[1]);
    buf b_dia_10 (dia_in[10], DIA[10]);
    buf b_dia_11 (dia_in[11], DIA[11]);
    buf b_dia_12 (dia_in[12], DIA[12]);
    buf b_dia_13 (dia_in[13], DIA[13]);
    buf b_dia_14 (dia_in[14], DIA[14]);
    buf b_dia_15 (dia_in[15], DIA[15]);
    buf b_dia_16 (dia_in[16], DIA[16]);
    buf b_dia_17 (dia_in[17], DIA[17]);
    buf b_dia_18 (dia_in[18], DIA[18]);
    buf b_dia_19 (dia_in[19], DIA[19]);
    buf b_dia_2 (dia_in[2], DIA[2]);
    buf b_dia_20 (dia_in[20], DIA[20]);
    buf b_dia_21 (dia_in[21], DIA[21]);
    buf b_dia_22 (dia_in[22], DIA[22]);
    buf b_dia_23 (dia_in[23], DIA[23]);
    buf b_dia_24 (dia_in[24], DIA[24]);
    buf b_dia_25 (dia_in[25], DIA[25]);
    buf b_dia_26 (dia_in[26], DIA[26]);
    buf b_dia_27 (dia_in[27], DIA[27]);
    buf b_dia_28 (dia_in[28], DIA[28]);
    buf b_dia_29 (dia_in[29], DIA[29]);
    buf b_dia_3 (dia_in[3], DIA[3]);
    buf b_dia_30 (dia_in[30], DIA[30]);
    buf b_dia_31 (dia_in[31], DIA[31]);
    buf b_dia_4 (dia_in[4], DIA[4]);
    buf b_dia_5 (dia_in[5], DIA[5]);
    buf b_dia_6 (dia_in[6], DIA[6]);
    buf b_dia_7 (dia_in[7], DIA[7]);
    buf b_dia_8 (dia_in[8], DIA[8]);
    buf b_dia_9 (dia_in[9], DIA[9]);
    buf b_dib_0 (dib_in[0], DIB[0]);
    buf b_dib_1 (dib_in[1], DIB[1]);
    buf b_dib_10 (dib_in[10], DIB[10]);
    buf b_dib_11 (dib_in[11], DIB[11]);
    buf b_dib_12 (dib_in[12], DIB[12]);
    buf b_dib_13 (dib_in[13], DIB[13]);
    buf b_dib_14 (dib_in[14], DIB[14]);
    buf b_dib_15 (dib_in[15], DIB[15]);
    buf b_dib_16 (dib_in[16], DIB[16]);
    buf b_dib_17 (dib_in[17], DIB[17]);
    buf b_dib_18 (dib_in[18], DIB[18]);
    buf b_dib_19 (dib_in[19], DIB[19]);
    buf b_dib_2 (dib_in[2], DIB[2]);
    buf b_dib_20 (dib_in[20], DIB[20]);
    buf b_dib_21 (dib_in[21], DIB[21]);
    buf b_dib_22 (dib_in[22], DIB[22]);
    buf b_dib_23 (dib_in[23], DIB[23]);
    buf b_dib_24 (dib_in[24], DIB[24]);
    buf b_dib_25 (dib_in[25], DIB[25]);
    buf b_dib_26 (dib_in[26], DIB[26]);
    buf b_dib_27 (dib_in[27], DIB[27]);
    buf b_dib_28 (dib_in[28], DIB[28]);
    buf b_dib_29 (dib_in[29], DIB[29]);
    buf b_dib_3 (dib_in[3], DIB[3]);
    buf b_dib_30 (dib_in[30], DIB[30]);
    buf b_dib_31 (dib_in[31], DIB[31]);
    buf b_dib_4 (dib_in[4], DIB[4]);
    buf b_dib_5 (dib_in[5], DIB[5]);
    buf b_dib_6 (dib_in[6], DIB[6]);
    buf b_dib_7 (dib_in[7], DIB[7]);
    buf b_dib_8 (dib_in[8], DIB[8]);
    buf b_dib_9 (dib_in[9], DIB[9]);
    buf b_dipa_0 (dipa_in[0], DIPA[0]);
    buf b_dipa_1 (dipa_in[1], DIPA[1]);
    buf b_dipa_2 (dipa_in[2], DIPA[2]);
    buf b_dipa_3 (dipa_in[3], DIPA[3]);
    buf b_dipb_0 (dipb_in[0], DIPB[0]);
    buf b_dipb_1 (dipb_in[1], DIPB[1]);
    buf b_dipb_2 (dipb_in[2], DIPB[2]);
    buf b_dipb_3 (dipb_in[3], DIPB[3]);

    buf b_doa0 (DOA[0], doa_out0);
    buf b_doa1 (DOA[1], doa_out1);
    buf b_doa10 (DOA[10], doa_out10);
    buf b_doa11 (DOA[11], doa_out11);
    buf b_doa12 (DOA[12], doa_out12);
    buf b_doa13 (DOA[13], doa_out13);
    buf b_doa14 (DOA[14], doa_out14);
    buf b_doa15 (DOA[15], doa_out15);
    buf b_doa16 (DOA[16], doa_out16);
    buf b_doa17 (DOA[17], doa_out17);
    buf b_doa18 (DOA[18], doa_out18);
    buf b_doa19 (DOA[19], doa_out19);
    buf b_doa2 (DOA[2], doa_out2);
    buf b_doa20 (DOA[20], doa_out20);
    buf b_doa21 (DOA[21], doa_out21);
    buf b_doa22 (DOA[22], doa_out22);
    buf b_doa23 (DOA[23], doa_out23);
    buf b_doa24 (DOA[24], doa_out24);
    buf b_doa25 (DOA[25], doa_out25);
    buf b_doa26 (DOA[26], doa_out26);
    buf b_doa27 (DOA[27], doa_out27);
    buf b_doa28 (DOA[28], doa_out28);
    buf b_doa29 (DOA[29], doa_out29);
    buf b_doa3 (DOA[3], doa_out3);
    buf b_doa30 (DOA[30], doa_out30);
    buf b_doa31 (DOA[31], doa_out31);
    buf b_doa4 (DOA[4], doa_out4);
    buf b_doa5 (DOA[5], doa_out5);
    buf b_doa6 (DOA[6], doa_out6);
    buf b_doa7 (DOA[7], doa_out7);
    buf b_doa8 (DOA[8], doa_out8);
    buf b_doa9 (DOA[9], doa_out9);
    buf b_doa0_out (doa_out0, doa_out[0]);
    buf b_doa1_out (doa_out1, doa_out[1]);
    buf b_doa10_out (doa_out10, doa_out[10]);
    buf b_doa11_out (doa_out11, doa_out[11]);
    buf b_doa12_out (doa_out12, doa_out[12]);
    buf b_doa13_out (doa_out13, doa_out[13]);
    buf b_doa14_out (doa_out14, doa_out[14]);
    buf b_doa15_out (doa_out15, doa_out[15]);
    buf b_doa16_out (doa_out16, doa_out[16]);
    buf b_doa17_out (doa_out17, doa_out[17]);
    buf b_doa18_out (doa_out18, doa_out[18]);
    buf b_doa19_out (doa_out19, doa_out[19]);
    buf b_doa2_out (doa_out2, doa_out[2]);
    buf b_doa20_out (doa_out20, doa_out[20]);
    buf b_doa21_out (doa_out21, doa_out[21]);
    buf b_doa22_out (doa_out22, doa_out[22]);
    buf b_doa23_out (doa_out23, doa_out[23]);
    buf b_doa24_out (doa_out24, doa_out[24]);
    buf b_doa25_out (doa_out25, doa_out[25]);
    buf b_doa26_out (doa_out26, doa_out[26]);
    buf b_doa27_out (doa_out27, doa_out[27]);
    buf b_doa28_out (doa_out28, doa_out[28]);
    buf b_doa29_out (doa_out29, doa_out[29]);
    buf b_doa3_out (doa_out3, doa_out[3]);
    buf b_doa30_out (doa_out30, doa_out[30]);
    buf b_doa31_out (doa_out31, doa_out[31]);
    buf b_doa4_out (doa_out4, doa_out[4]);
    buf b_doa5_out (doa_out5, doa_out[5]);
    buf b_doa6_out (doa_out6, doa_out[6]);
    buf b_doa7_out (doa_out7, doa_out[7]);
    buf b_doa8_out (doa_out8, doa_out[8]);
    buf b_doa9_out (doa_out9, doa_out[9]);

    buf b_dopa0 (DOPA[0], dopa_out0);
    buf b_dopa1 (DOPA[1], dopa_out1);
    buf b_dopa2 (DOPA[2], dopa_out2);
    buf b_dopa3 (DOPA[3], dopa_out3);
    buf b_dopa0_out (dopa_out0, dopa_out[0]);
    buf b_dopa1_out (dopa_out1, dopa_out[1]);
    buf b_dopa2_out (dopa_out2, dopa_out[2]);
    buf b_dopa3_out (dopa_out3, dopa_out[3]);

    buf b_dob0 (DOB[0], dob_out0);
    buf b_dob1 (DOB[1], dob_out1);
    buf b_dob10 (DOB[10], dob_out10);
    buf b_dob11 (DOB[11], dob_out11);
    buf b_dob12 (DOB[12], dob_out12);
    buf b_dob13 (DOB[13], dob_out13);
    buf b_dob14 (DOB[14], dob_out14);
    buf b_dob15 (DOB[15], dob_out15);
    buf b_dob16 (DOB[16], dob_out16);
    buf b_dob17 (DOB[17], dob_out17);
    buf b_dob18 (DOB[18], dob_out18);
    buf b_dob19 (DOB[19], dob_out19);
    buf b_dob2 (DOB[2], dob_out2);
    buf b_dob20 (DOB[20], dob_out20);
    buf b_dob21 (DOB[21], dob_out21);
    buf b_dob22 (DOB[22], dob_out22);
    buf b_dob23 (DOB[23], dob_out23);
    buf b_dob24 (DOB[24], dob_out24);
    buf b_dob25 (DOB[25], dob_out25);
    buf b_dob26 (DOB[26], dob_out26);
    buf b_dob27 (DOB[27], dob_out27);
    buf b_dob28 (DOB[28], dob_out28);
    buf b_dob29 (DOB[29], dob_out29);
    buf b_dob3 (DOB[3], dob_out3);
    buf b_dob30 (DOB[30], dob_out30);
    buf b_dob31 (DOB[31], dob_out31);
    buf b_dob4 (DOB[4], dob_out4);
    buf b_dob5 (DOB[5], dob_out5);
    buf b_dob6 (DOB[6], dob_out6);
    buf b_dob7 (DOB[7], dob_out7);
    buf b_dob8 (DOB[8], dob_out8);
    buf b_dob9 (DOB[9], dob_out9);
    buf b_dob0_out (dob_out0, dob_out[0]);
    buf b_dob1_out (dob_out1, dob_out[1]);
    buf b_dob10_out (dob_out10, dob_out[10]);
    buf b_dob11_out (dob_out11, dob_out[11]);
    buf b_dob12_out (dob_out12, dob_out[12]);
    buf b_dob13_out (dob_out13, dob_out[13]);
    buf b_dob14_out (dob_out14, dob_out[14]);
    buf b_dob15_out (dob_out15, dob_out[15]);
    buf b_dob16_out (dob_out16, dob_out[16]);
    buf b_dob17_out (dob_out17, dob_out[17]);
    buf b_dob18_out (dob_out18, dob_out[18]);
    buf b_dob19_out (dob_out19, dob_out[19]);
    buf b_dob2_out (dob_out2, dob_out[2]);
    buf b_dob20_out (dob_out20, dob_out[20]);
    buf b_dob21_out (dob_out21, dob_out[21]);
    buf b_dob22_out (dob_out22, dob_out[22]);
    buf b_dob23_out (dob_out23, dob_out[23]);
    buf b_dob24_out (dob_out24, dob_out[24]);
    buf b_dob25_out (dob_out25, dob_out[25]);
    buf b_dob26_out (dob_out26, dob_out[26]);
    buf b_dob27_out (dob_out27, dob_out[27]);
    buf b_dob28_out (dob_out28, dob_out[28]);
    buf b_dob29_out (dob_out29, dob_out[29]);
    buf b_dob3_out (dob_out3, dob_out[3]);
    buf b_dob30_out (dob_out30, dob_out[30]);
    buf b_dob31_out (dob_out31, dob_out[31]);
    buf b_dob4_out (dob_out4, dob_out[4]);
    buf b_dob5_out (dob_out5, dob_out[5]);
    buf b_dob6_out (dob_out6, dob_out[6]);
    buf b_dob7_out (dob_out7, dob_out[7]);
    buf b_dob8_out (dob_out8, dob_out[8]);
    buf b_dob9_out (dob_out9, dob_out[9]);

    buf b_dopb0 (DOPB[0], dopb_out0);
    buf b_dopb1 (DOPB[1], dopb_out1);
    buf b_dopb2 (DOPB[2], dopb_out2);
    buf b_dopb3 (DOPB[3], dopb_out3);
    buf b_dopb0_out (dopb_out0, dopb_out[0]);
    buf b_dopb1_out (dopb_out1, dopb_out[1]);
    buf b_dopb2_out (dopb_out2, dopb_out[2]);
    buf b_dopb3_out (dopb_out3, dopb_out[3]);


    buf b_ena (ena_in, ENA);
    buf b_enb (enb_in, ENB);
    buf b_gsr (gsr_in, GSR);
    buf b_ssra (ssra_in, SSRA);
    buf b_ssrb (ssrb_in, SSRB);
    buf b_wea0 (wea_in[0], WEA[0]);
    buf b_wea1 (wea_in[1], WEA[1]);
    buf b_wea2 (wea_in[2], WEA[2]);
    buf b_wea3 (wea_in[3], WEA[3]);
    buf b_web0 (web_in[0], WEB[0]);
    buf b_web1 (web_in[1], WEB[1]);
    buf b_web2 (web_in[2], WEB[2]);
    buf b_web3 (web_in[3], WEB[3]);

    initial begin
	for (count = 0; count < 256; count = count + 1) begin
	    mem[count]		  <= INIT_00[count];
	    mem[256 * 1 + count]  <= INIT_01[count];
	    mem[256 * 2 + count]  <= INIT_02[count];
	    mem[256 * 3 + count]  <= INIT_03[count];
	    mem[256 * 4 + count]  <= INIT_04[count];
	    mem[256 * 5 + count]  <= INIT_05[count];
	    mem[256 * 6 + count]  <= INIT_06[count];
	    mem[256 * 7 + count]  <= INIT_07[count];
	    mem[256 * 8 + count]  <= INIT_08[count];
	    mem[256 * 9 + count]  <= INIT_09[count];
	    mem[256 * 10 + count] <= INIT_0A[count];
	    mem[256 * 11 + count] <= INIT_0B[count];
	    mem[256 * 12 + count] <= INIT_0C[count];
	    mem[256 * 13 + count] <= INIT_0D[count];
	    mem[256 * 14 + count] <= INIT_0E[count];
	    mem[256 * 15 + count] <= INIT_0F[count];
	    mem[256 * 16 + count] <= INIT_10[count];
	    mem[256 * 17 + count] <= INIT_11[count];
	    mem[256 * 18 + count] <= INIT_12[count];
	    mem[256 * 19 + count] <= INIT_13[count];
	    mem[256 * 20 + count] <= INIT_14[count];
	    mem[256 * 21 + count] <= INIT_15[count];
	    mem[256 * 22 + count] <= INIT_16[count];
	    mem[256 * 23 + count] <= INIT_17[count];
	    mem[256 * 24 + count] <= INIT_18[count];
	    mem[256 * 25 + count] <= INIT_19[count];
	    mem[256 * 26 + count] <= INIT_1A[count];
	    mem[256 * 27 + count] <= INIT_1B[count];
	    mem[256 * 28 + count] <= INIT_1C[count];
	    mem[256 * 29 + count] <= INIT_1D[count];
	    mem[256 * 30 + count] <= INIT_1E[count];
	    mem[256 * 31 + count] <= INIT_1F[count];
	    mem[256 * 32 + count] <= INIT_20[count];
	    mem[256 * 33 + count] <= INIT_21[count];
	    mem[256 * 34 + count] <= INIT_22[count];
	    mem[256 * 35 + count] <= INIT_23[count];
	    mem[256 * 36 + count] <= INIT_24[count];
	    mem[256 * 37 + count] <= INIT_25[count];
	    mem[256 * 38 + count] <= INIT_26[count];
	    mem[256 * 39 + count] <= INIT_27[count];
	    mem[256 * 40 + count] <= INIT_28[count];
	    mem[256 * 41 + count] <= INIT_29[count];
	    mem[256 * 42 + count] <= INIT_2A[count];
	    mem[256 * 43 + count] <= INIT_2B[count];
	    mem[256 * 44 + count] <= INIT_2C[count];
	    mem[256 * 45 + count] <= INIT_2D[count];
	    mem[256 * 46 + count] <= INIT_2E[count];
	    mem[256 * 47 + count] <= INIT_2F[count];
	    mem[256 * 48 + count] <= INIT_30[count];
	    mem[256 * 49 + count] <= INIT_31[count];
	    mem[256 * 50 + count] <= INIT_32[count];
	    mem[256 * 51 + count] <= INIT_33[count];
	    mem[256 * 52 + count] <= INIT_34[count];
	    mem[256 * 53 + count] <= INIT_35[count];
	    mem[256 * 54 + count] <= INIT_36[count];
	    mem[256 * 55 + count] <= INIT_37[count];
	    mem[256 * 56 + count] <= INIT_38[count];
	    mem[256 * 57 + count] <= INIT_39[count];
	    mem[256 * 58 + count] <= INIT_3A[count];
	    mem[256 * 59 + count] <= INIT_3B[count];
	    mem[256 * 60 + count] <= INIT_3C[count];
	    mem[256 * 61 + count] <= INIT_3D[count];
	    mem[256 * 62 + count] <= INIT_3E[count];
	    mem[256 * 63 + count] <= INIT_3F[count];
	    mem[256 * 64 + count] <= INITP_00[count];
	    mem[256 * 65 + count] <= INITP_01[count];
	    mem[256 * 66 + count] <= INITP_02[count];
	    mem[256 * 67 + count] <= INITP_03[count];
	    mem[256 * 68 + count] <= INITP_04[count];
	    mem[256 * 69 + count] <= INITP_05[count];
	    mem[256 * 70 + count] <= INITP_06[count];
	    mem[256 * 71 + count] <= INITP_07[count];
	end
    end


    initial begin


        if ((DATA_WIDTH_A == 0) && (DATA_WIDTH_B == 0)) begin
            $display("Attribute Syntax Error : Both attributes DATA_WIDTH_A and DATA_WIDTH_B on RAMB16BWE instance %m can not be 0.");
            $finish;
        end


	
	if ((SIM_COLLISION_CHECK != "ALL") && (SIM_COLLISION_CHECK != "NONE") && (SIM_COLLISION_CHECK != "WARNING_ONLY") && (SIM_COLLISION_CHECK != "GENERATE_X_ONLY")) begin
	    
	    $display("Attribute Syntax Error : The attribute SIM_COLLISION_CHECK on RAMB16BWE instance %m is set to %s.  Legal values for this attribute are ALL, NONE, WARNING_ONLY or GENERATE_X_ONLY.", SIM_COLLISION_CHECK);
	    $finish;

	end

    end

    
    initial begin
	case (WRITE_MODE_A)
	    "WRITE_FIRST" : wr_mode_a <= 2'b00;
	    "READ_FIRST"  : wr_mode_a <= 2'b01;
	    "NO_CHANGE"   : wr_mode_a <= 2'b10;
	    default       : begin
				$display("Attribute Syntax Error : The attribute WRITE_MODE_A on RAMB16BWE instance %m is set to %s.  Legal values for this attribute are WRITE_FIRST, READ_FIRST or NO_CHANGE.", WRITE_MODE_A);
				$finish;
			    end
	endcase
    end


    initial begin
	case (WRITE_MODE_B)
	    "WRITE_FIRST" : wr_mode_b <= 2'b00;
	    "READ_FIRST"  : wr_mode_b <= 2'b01;
	    "NO_CHANGE"   : wr_mode_b <= 2'b10;
	    default       : begin
				$display("Attribute Syntax Error : The attribute WRITE_MODE_B on RAMB16BWE instance %m is set to %s.  Legal values for this attribute are WRITE_FIRST, READ_FIRST or NO_CHANGE.", WRITE_MODE_B);
				$finish;
			    end
	endcase
    end


    initial begin

	dipaw   = 0;
	dipaw_1 = -1;
	dipbw   = 0;
	dipbw_1 = -1;

	dopaw   = 0;
	dopaw_1 = -1;
	dopbw   = 0;
	dopbw_1 = -1;

	case (DATA_WIDTH_A)

	    0 : ;
 
	    1 : begin
		    zero_read_a = 14'b11111111111111;
		    doaw = 1;
		    doaw_1 = doaw - 1;
		    zero_write_a = 14'b11111111111111;
		    diaw = 1;
		    diaw_1 = diaw - 1;
		end

	    2 : begin
		    zero_read_a = 14'b11111111111110;
		    doaw = 2;
		    doaw_1 = doaw - 1;
		    zero_write_a = 14'b11111111111110;
		    diaw = 2;
		    diaw_1 = diaw - 1;
		end

	    4 : begin
		    zero_read_a = 14'b11111111111100;
		    doaw = 4;
		    doaw_1 = doaw - 1;
		    zero_write_a = 14'b11111111111100;
		    diaw = 4;
		    diaw_1 = diaw - 1;
		end

	    9 : begin
		    zero_read_a = 14'b11111111111000;
		    zero_parity_read_a = 11'b11111111111;
		    doaw = 8;
		    doaw_1 = doaw - 1;
		    dopaw = 1;
		    dopaw_1 = dopaw - 1;
		    zero_write_a = 14'b11111111111000;
		    zero_parity_write_a = 11'b11111111111;
		    diaw = 8;
		    diaw_1 = diaw - 1;
		    dipaw = 1;
		    dipaw_1 = dipaw - 1;
		end

	    18 : begin
		    zero_read_a = 14'b11111111110000;
		    zero_parity_read_a = 11'b11111111110;
		    doaw = 16;
		    doaw_1 = doaw - 1;
		    dopaw = 2;
		    dopaw_1 = dopaw - 1;
		    zero_write_a = 14'b11111111110000;
		    zero_parity_write_a = 11'b11111111110;		
		    diaw = 16;
		    diaw_1 = diaw - 1;
		    dipaw = 2;
		    dipaw_1 = dipaw - 1;
		end

	    36 : begin
		    zero_read_a = 14'b11111111100000;
		    zero_parity_read_a = 11'b11111111100;
		    doaw = 32;
		    doaw_1 = doaw - 1;
		    dopaw = 4;
		    dopaw_1 = dopaw - 1;
		    zero_write_a = 14'b11111111100000;
		    zero_parity_write_a = 11'b11111111100;		
		    diaw = 32;
		    diaw_1 = diaw - 1;
		    dipaw = 4;
		    dipaw_1 = dipaw - 1;
		end

	    default : begin
		    $display("Attribute Syntax Error : The attribute DATA_WIDTH_A on RAMB16BWE instance %m is set to %d.  Legal values for this attribute are  0, 1, 2, 4, 9, 18 or 36.", DATA_WIDTH_A);
	            $finish;
	              end

	endcase // case(DATA_WIDTH_A)
	


	case (DATA_WIDTH_B)

	    0 : ; 

	    1 : begin
		    zero_read_b = 14'b11111111111111;
		    dobw = 1;
		    dobw_1 = dobw - 1;
		    zero_write_b = 14'b11111111111111;
		    dibw = 1;
		    dibw_1 = dibw - 1;
		end

	    2 : begin
		    zero_read_b = 14'b11111111111110;
		    dobw = 2;
		    dobw_1 = dobw - 1;
		    zero_write_b = 14'b11111111111110;
		    dibw = 2;
		    dibw_1 = dibw - 1;
		end

	    4 : begin
		    zero_read_b = 14'b11111111111100;
		    dobw = 4;
		    dobw_1 = dobw - 1;
		    zero_write_b = 14'b11111111111100;
		    dibw = 4;
		    dibw_1 = dibw - 1;
		end

	    9 : begin
		    zero_read_b = 14'b11111111111000;
		    zero_parity_read_b = 11'b11111111111;
		    dobw = 8;
		    dobw_1 = dobw - 1;
		    dopbw = 1;
		    dopbw_1 = dopbw - 1;
		    zero_write_b = 14'b11111111111000;
		    zero_parity_write_b = 11'b11111111111;		
		    dibw = 8;
		    dibw_1 = dibw - 1;
		    dipbw = 1;
		    dipbw_1 = dipbw - 1;
		end

	    18 : begin
		    zero_read_b = 14'b11111111110000;
		    zero_parity_read_b = 11'b11111111110;
		    dobw = 16;
		    dobw_1 = dobw - 1;
		    dopbw = 2;
		    dopbw_1 = dopbw - 1;
		    zero_write_b = 14'b11111111110000;
		    zero_parity_write_b = 11'b11111111110;		
		    dibw = 16;
		    dibw_1 = dibw - 1;
		    dipbw = 2;
		    dipbw_1 = dipbw - 1;
		end

	    36 : begin
		    zero_read_b = 14'b11111111100000;
		    zero_parity_read_b = 11'b11111111100;
		    dobw = 32;
		    dobw_1 = dobw - 1;
		    dopbw = 4;
		    dopbw_1 = dopbw - 1;
		    zero_write_b = 14'b11111111100000;
		    zero_parity_write_b = 11'b11111111100;		
		    dibw = 32;
		    dibw_1 = dibw - 1;
		    dipbw = 4;
		    dipbw_1 = dipbw - 1;
		end

	    default : begin
		    $display("Attribute Syntax Error : The attribute DATA_WIDTH_B on RAMB16BWE instance %m is set to %d.  Legal values for this attribute are  0, 1, 2, 4, 9, 18 or 36.", DATA_WIDTH_B);
	            $finish;
	              end

	endcase // case(DATA_WIDTH_B)
	
	
	wea_index = -1;
	web_index = -1;

    end // end initial


    assign wea_in_sampled[0] = wea_in[0];
    assign wea_in_sampled[1] = wea_in[1];
    assign wea_in_sampled[2] = wea_in[2];
    assign wea_in_sampled[3] = wea_in[3];

    assign web_in_sampled[0] = web_in[0];
    assign web_in_sampled[1] = web_in[1];
    assign web_in_sampled[2] = web_in[2];
    assign web_in_sampled[3] = web_in[3];

    always @(addra_in) begin
	address_parity_read_a <= addra_in[13:3] & zero_parity_read_a;
	address_parity_write_a <= addra_in[13:3] & zero_parity_write_a;
	address_write_a <= addra_in[13:0] & zero_write_a;
	address_read_a <= addra_in[13:0] & zero_read_a;
    end
	
    always @(addrb_in) begin
	address_parity_read_b <= addrb_in[13:3] & zero_parity_read_b;
	address_parity_write_b <= addrb_in[13:3] & zero_parity_write_b;
	address_write_b <= addrb_in[13:0] & zero_write_b;
	address_read_b <= addrb_in[13:0] & zero_read_b;
    end

    
    always @(address_write_a or address_read_a) begin

	if (diaw <= doaw) begin

	    case (diaw)

		1 : begin

		    case (doaw)

			1 : doa_index <= 0;
			2 : doa_index <= address_write_a[0];
			4 : doa_index <= address_write_a[1:0];
			8 : doa_index <= address_write_a[2:0];
			16 : doa_index <= address_write_a[3:0];
			32 : doa_index <= address_write_a[4:0];

		    endcase // case(doaw)

		end
		2 : begin

		    case (doaw)

			2 : doa_index <= 0;
			4 : doa_index <= address_write_a[1];
			8 : doa_index <= address_write_a[2:1];
			16 : doa_index <= address_write_a[3:1];
			32 : doa_index <= address_write_a[4:1];

		    endcase // case(doaw)

		end
		4 : begin

		    case (doaw)

			4 : doa_index <= 0;
			8 : doa_index <= address_write_a[2];
			16 : doa_index <= address_write_a[3:2];
			32 : doa_index <= address_write_a[4:2];

		    endcase // case(doaw)

		end
		8 : begin

		    case (doaw)

			8 : begin 
			         doa_index <= 0;
			         dopa_index <= 0;
			     end
			16 : begin 
			         doa_index <= address_write_a[3];
			         dopa_index <= address_parity_write_a[0];
			     end			
			32 : begin 
			         doa_index <= address_write_a[4:3];
			         dopa_index <= address_parity_write_a[1:0];
			     end
			
		    endcase // case(doaw)
		end
	       	16 : begin

		    case (doaw)
			
			16 : begin 
			         doa_index <= 0;
			         dopa_index <= 0;
			     end
			32 : begin 
			         doa_index <= address_write_a[4];
			         dopa_index <= address_parity_write_a[1];
			     end
			
		    endcase // case(doaw)
		end
	       	32 : begin 

		         doa_index <= 0;
		         dopa_index <= 0;

		     end

	    endcase

	end // if (diaw <= doaw)
	else if (diaw > doaw) begin

	    case (doaw)

		1 : begin

		    case (diaw)

			2 : doa_index <= address_read_a[0];
			4 : doa_index <= address_read_a[1:0];
			8 : doa_index <= address_read_a[2:0];
			16 : doa_index <= address_read_a[3:0];
			32 : doa_index <= address_read_a[4:0];

		    endcase // case(diaw)

		end
		2 : begin

		    case (diaw)

			4 : doa_index <= address_read_a[1];
			8 : doa_index <= address_read_a[2:1];
			16 : doa_index <= address_read_a[3:1];
			32 : doa_index <= address_read_a[4:1];

		    endcase // case(diaw)

		end
		4 : begin

		    case (diaw)

			8 : doa_index <= address_read_a[2];
			16 : doa_index <= address_read_a[3:2];
			32 : doa_index <= address_read_a[4:2];

		    endcase // case(diaw)

		end
		8 : begin

		    case (diaw)

			16 : begin 
			         doa_index <= address_read_a[3];
			         dopa_index <= address_parity_read_a[0];
			     end			
			32 : begin 
			         doa_index <= address_read_a[4:3];
			         dopa_index <= address_parity_read_a[1:0];
			     end
			
		    endcase // case(diaw)
		end
	       	16 : begin

		         doa_index <= address_read_a[4];
		         dopa_index <= address_parity_read_a[1];

		end
			
	    endcase // case(doaw)

	end // if (diaw > doaw)
	
    end // always @ (address_write_a or address_read_a)



    always @(address_write_b or address_read_b) begin

	if (dibw <= dobw) begin

	    case (dibw)
		
		1 : begin
		    
		    case (dobw)

			1 : dob_index <= 0;
			2 : dob_index <= address_write_b[0];
			4 : dob_index <= address_write_b[1:0];
			8 : dob_index <= address_write_b[2:0];
			16 : dob_index <= address_write_b[3:0];
			32 : dob_index <= address_write_b[4:0];

		    endcase // case(dobw)

		end
		2 : begin

		    case (dobw)

			2 : dob_index <= 0;
			4 : dob_index <= address_write_b[1];
			8 : dob_index <= address_write_b[2:1];
			16 : dob_index <= address_write_b[3:1];
			32 : dob_index <= address_write_b[4:1];

		    endcase // case(dobw)

		end
		4 : begin

		    case (dobw)

			4 : dob_index <= 0;
			8 : dob_index <= address_write_b[2];
			16 : dob_index <= address_write_b[3:2];
			32 : dob_index <= address_write_b[4:2];

		    endcase // case(dobw)

		end
		8 : begin

		    case (dobw)

			8 : begin 
			         dob_index <= 0;
			         dopb_index <= 0;
			     end
			16 : begin 
			         dob_index <= address_write_b[3];
			         dopb_index <= address_parity_write_b[0];
			     end			
			32 : begin 
			         dob_index <= address_write_b[4:3];
			         dopb_index <= address_parity_write_b[1:0];
			     end
			
		    endcase // case(dobw)
		end
	       	16 : begin

		    case (dobw)
			
			16 : begin 
			         dob_index <= 0;
			         dopb_index <= 0;
			     end
			32 : begin 
			         dob_index <= address_write_b[4];
			         dopb_index <= address_parity_write_b[1];
			     end
			
		    endcase // case(dobw)
		end
	       	32 : begin 

		         dob_index <= 0;
		         dopb_index <= 0;

		     end

	    endcase

	end // if (dibw <= dobw)
	else if (dibw > dobw) begin

	    case (dobw)

		1 : begin

		    case (dibw)

			2 : dob_index <= address_read_b[0];
			4 : dob_index <= address_read_b[1:0];
			8 : dob_index <= address_read_b[2:0];
			16 : dob_index <= address_read_b[3:0];
			32 : dob_index <= address_read_b[4:0];

		    endcase // case(dibw)

		end
		2 : begin

		    case (dibw)

			4 : dob_index <= address_read_b[1];
			8 : dob_index <= address_read_b[2:1];
			16 : dob_index <= address_read_b[3:1];
			32 : dob_index <= address_read_b[4:1];

		    endcase // case(dibw)

		end
		4 : begin

		    case (dibw)

			8 : dob_index <= address_read_b[2];
			16 : dob_index <= address_read_b[3:2];
			32 : dob_index <= address_read_b[4:2];

		    endcase // case(dibw)

		end
		8 : begin

		    case (dibw)

			16 : begin 
			         dob_index <= address_read_b[3];
			         dopb_index <= address_parity_read_b[0];
			     end			
			32 : begin 
			         dob_index <= address_read_b[4:3];
			         dopb_index <= address_parity_read_b[1:0];
			     end
			
		    endcase // case(dibw)
		end
	       	16 : begin

		         dob_index <= address_read_b[4];
		         dopb_index <= address_parity_read_b[1];

		end
			
	    endcase // case(dobw)

	end // if (dibw > dobw)
	
    end // always @ (address_write_b or address_read_b)

    
// memory come first to work around the race condition of mem and x
// ***** Port A ****** Memory Update ***** 
    always @(posedge clka_in) begin

	if (ena_in == 1 && gsr_in == 0) begin

	    case (diaw)
		    1, 2, 4, 8 : begin
				     wea_index = addra_in[4:3];

				     if (wea_in_sampled[wea_index] == 1) begin

	        			for (i_6 = 0; i_6 < diaw; i_6 = i_6 + 1)
		    			    mem[address_write_a + i_6] <= dia_in[i_6];

					if (dipaw_1 != -1)
		    			    for (i_6p = 0; i_6p < dipaw; i_6p = i_6p + 1)
					        mem[(16384 + address_parity_write_a + i_6p)] <= dipa_in[i_6p];

				     end

		    end  // 1, 2, 4, 8 :

		    16 : begin
			     wea_index = {addra_in[4], 1'b0};

			     if (wea_in_sampled[wea_index] == 1) begin

			         for (i_6 = 0; i_6 <= (diaw/2 - 1); i_6 = i_6 + 1)
			             mem[address_write_a + i_6] <= dia_in[i_6];

				 if (dipaw_1 != -1)
				     for (i_6p = 0; i_6p <= (dipaw/2 - 1); i_6p = i_6p + 1)
					 mem[(16384 + address_parity_write_a + i_6p)] <= dipa_in[i_6p];

			     end

			     wea_index = {addra_in[4], 1'b1};

		 	     if (wea_in_sampled[wea_index] == 1) begin

			         for (i_7 = diaw/2; i_7 < diaw; i_7 = i_7 + 1)
				     mem[address_write_a + i_7] <= dia_in[i_7];

				 if (dipaw_1 != -1)
				     for (i_7p = dipaw/2; i_7p < dipaw; i_7p = i_7p + 1)
					 mem[16384 + address_parity_write_a + i_7p] <= dipa_in[i_7p];

			     end

		    end  // 16:

		    32 : begin

			     wea_index = 0;
			     if (wea_in_sampled[wea_index] == 1) begin

				 for (i_6 = 0; i_6 <= (((diaw/4) * 1) - 1); i_6 = i_6 + 1)
				     mem[address_write_a + i_6] <= dia_in[i_6];

				 if (dipaw_1 != -1)
				     for (i_6p = 0; i_6p <= (((dipaw/4) * 1) - 1); i_6p = i_6p + 1)
					 mem[16384 + address_parity_write_a + i_6p] <= dipa_in[i_6p];
			     end

			     wea_index = 1;
			     if (wea_in_sampled[wea_index] == 1) begin

				 for (i_7 = (diaw/4) * 1; i_7 <= (((diaw/4) * 2) - 1); i_7 = i_7 + 1)
				     mem[address_write_a + i_7] <= dia_in[i_7];

				 if (dipaw_1 != -1)
				     for (i_7p = (dipaw/4) * 1; i_7p <= (((dipaw/4) * 2) -1); i_7p = i_7p + 1)
					 mem[16384 + address_parity_write_a + i_7p] <= dipa_in[i_7p];
			     end

			     wea_index = 2;
			     if (wea_in_sampled[wea_index] == 1) begin

				 for (i_8 = (diaw/4) * 2; i_8 <= (((diaw/4) * 3) - 1); i_8 = i_8 + 1)
				     mem[address_write_a + i_8] <= dia_in[i_8];

				 if (dipaw_1 != -1)
				     for (i_8p = (dipaw/4) * 2; i_8p <= (((dipaw/4) * 3) -1); i_8p = i_8p + 1)
					 mem[16384 + address_parity_write_a + i_8p] <= dipa_in[i_8p];
			     end

			     wea_index = 3;
			     if (wea_in_sampled[wea_index] == 1) begin

				 for (i_9 = (diaw/4) * 3; i_9 <= (((diaw/4) * 4) - 1); i_9 = i_9 + 1)
				     mem[address_write_a + i_9] <= dia_in[i_9];

				 if (dipaw_1 != -1)
				     for (i_9p = (dipaw/4) * 3; i_9p <= (((dipaw/4) * 4) -1); i_9p = i_9p + 1)
					 mem[16384 + address_parity_write_a + i_9p] <= dipa_in[i_9p];
			     end
		    end  // 32 :

		endcase  // case (diaw) /**** memory update ***/

	end  // else if (ena_in == 1 && gsr_in == 0)

    end  // always @(posedge clka_in) /**** memory update ***/
    

// ***** Port A *****
    always @(posedge clka_in or posedge gsr_in) begin

	if (gsr_in == 1) begin

	    for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1) begin
	        doa_out[i_1] <= INIT_A[i_1];
		doa_out_buf[i_1] <= INIT_A[i_1];
	    end

	    if (dopaw_1 != -1)
	        for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1) begin
	    	    dopa_out[i_1p] <= INIT_A[i_1p + doaw];
		    dopa_out_buf[i_1p] <= INIT_A[i_1p + doaw];
		end

	end
	else if (ena_in == 1 && gsr_in == 0) begin
	    if (ssra_in == 1) begin
	        for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1) begin
		    doa_out[i_1] <= SRVAL_A[i_1];
		    doa_out_buf[i_1] <= SRVAL_A[i_1];
		end

		if (dopaw_1 != -1)
		    for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1) begin
		        dopa_out[i_1p] <= SRVAL_A[doaw + i_1p];
		        dopa_out_buf[i_1p] <= SRVAL_A[doaw + i_1p];
		    end
		
	    end
	    else if (ssra_in == 0 && wr_mode_a == 2'b00) begin

		case (diaw)
		    1, 2, 4, 8 : begin
			
				     wea_index = addra_in[4:3];
				     if (wea_in_sampled[wea_index] == 1) begin

				         if (doaw > diaw) begin
					     					     
					     for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
					         doa_out_buf[i_1] = mem[address_read_a + i_1];

					     for (i_2 = 0; i_2 < diaw; i_2 = i_2 + 1)
					         doa_out_buf[(doa_index * diaw) + i_2] = dia_in[i_2];
					     

					     if (dopaw_1 != -1) begin

						 for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1)
					             dopa_out_buf[i_1p] = mem[16384 + address_parity_read_a + i_1p];
 
						 for (i_2p = 0; i_2p < dipaw; i_2p = i_2p + 1)
					             dopa_out_buf[(dopa_index * dipaw) + i_2p] = dipa_in[i_2p];
					    						 
					     end // if (dopaw > dipaw)		

					 end // if (doaw > diaw)
					 else if (doaw <= diaw) begin
					     					     
					     for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
					         doa_out_buf[i_1] = dia_in[(doa_index * doaw) + i_1];
					     

					     if (dopaw_1 != -1)  // only when dipaw = dopaw = 8
						 for (i_1p = 0; i_1p < dipaw; i_1p = i_1p + 1)
					             dopa_out_buf[i_1p] = dipa_in[i_1p];
					     
					 end // if (doaw <= diaw)
					 
				     end			
				     else if (wea_in_sampled[wea_index] == 0) begin  // wea disable

					 for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
					     doa_out_buf[i_1] = mem[address_read_a + i_1];
					 
					 if (dopaw_1 != -1)
					     for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1)
					         dopa_out_buf[i_1p] = mem[16384 + address_parity_read_a + i_1p];

				     end

			             collision_call0_task(0);

		    end // case: 1, 2, 4, 8		    

		    16 : begin // dipaw = 2

			if (doaw > diaw) begin  // only when doaw = 32, dopaw = 4
			    
			    for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
				doa_out_buf[i_1] = mem[address_read_a + i_1];
			    
			    for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1)
				dopa_out_buf[i_1p] = mem[16384 + address_parity_read_a + i_1p];

			    
			    if (wea_in_sampled[{addra_in[4], 1'b0}] != wea_in_sampled[{addra_in[4], 1'b1}]) begin

				for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
				    doa_out_buf[i_1] = 1'bx;
				
				for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1)
				    dopa_out_buf[i_1p] = 1'bx;

			    end
			    else begin
			    
				wea_index = {addra_in[4], 1'b0};
			    
				if (wea_in_sampled[wea_index] == 1) begin
				    
				    for (i_2 = 0; i_2 < diaw/2; i_2 = i_2 + 1)
					doa_out_buf[(doa_index * diaw) + i_2] = dia_in[i_2];
				    
				    for (i_2p = 0; i_2p < dipaw/2; i_2p = i_2p + 1)
					dopa_out_buf[(dopa_index * dipaw) + i_2p] = dipa_in[i_2p];
				
				end
				
				
				wea_index = {addra_in[4], 1'b1};
				
				if (wea_in_sampled[wea_index] == 1) begin
				    
				    for (i_3 = diaw/2; i_3 < diaw; i_3 = i_3 + 1)
					doa_out_buf[(doa_index * diaw) + i_3] = dia_in[i_3];
				    
				    for (i_3p = dipaw/2; i_3p < dipaw; i_3p = i_3p + 1)
				    dopa_out_buf[(dopa_index * dipaw) + i_3p] = dipa_in[i_3p];
				    
				end

			    end // else: !if(wea_in_sampled[{addra_in[4], 1'b0}] != wea_in_sampled[{addra_in[4], 1'b1}])
			    

			    collision_call0_task(0);

			end // if (doaw > diaw)			
			else if (doaw <= diaw) begin
			    
			    wea_index = {addra_in[4], 1'b0};
			    
			    if (wea_in_sampled[wea_index] == 1) begin
				
				for (i_2 = 0; i_2 < diaw/2; i_2 = i_2 + 1)
				    doa_out_buf[i_2] = dia_in[i_2];
				    
				if (dopaw_1 != -1)
				    for (i_2p = 0; i_2p < dipaw/2; i_2p = i_2p + 1)
					dopa_out_buf[i_2p] = dipa_in[i_2p];
				    
			    end
			    else if (wea_in_sampled[{addra_in[4], 1'b0}] != wea_in_sampled[{addra_in[4], 1'b1}]) begin

				for (i_2 = 0; i_2 < diaw/2; i_2 = i_2 + 1)
				    doa_out_buf[i_2] = 1'bx;
				    
				if (dopaw_1 != -1)
				    for (i_2p = 0; i_2p < dipaw/2; i_2p = i_2p + 1)
					dopa_out_buf[i_2p] = 1'bx;

			    end
				
			    
			    wea_index = {addra_in[4], 1'b1};
				
			    if (wea_in_sampled[wea_index] == 1) begin
				
				for (i_3 = diaw/2; i_3 < diaw; i_3 = i_3 + 1)
				    doa_out_buf[i_3] = dia_in[i_3];

				if (dopaw_1 != -1)
				    for (i_3p = dipaw/2; i_3p < dipaw; i_3p = i_3p + 1)
					dopa_out_buf[i_3p] = dipa_in[i_3p];
				    
			    end
			    else if (wea_in_sampled[{addra_in[4], 1'b0}] != wea_in_sampled[{addra_in[4], 1'b1}]) begin

				for (i_3 = diaw/2; i_3 < diaw; i_3 = i_3 + 1)
				    doa_out_buf[i_3] = 1'bx;

				if (dopaw_1 != -1)
				    for (i_3p = dipaw/2; i_3p < dipaw; i_3p = i_3p + 1)
					dopa_out_buf[i_3p] = 1'bx;
				    
			    end

			    
			    if ((wea_in_sampled[{addra_in[4], 1'b0}] === wea_in_sampled[{addra_in[4], 1'b1}]) && wea_in_sampled[{addra_in[4], 1'b1}] == 0) begin

				for (i_1 = 0; i_1 < diaw; i_1 = i_1 + 1)
				    doa_out_buf[i_1] = mem[address_write_a + i_1];
			    
				if (dopaw_1 != -1)
				    for (i_1p = 0; i_1p < dipaw; i_1p = i_1p + 1)
					dopa_out_buf[i_1p] = mem[16384 + address_parity_write_a + i_1p];

			    end
			    else if (wea_in_sampled[{addra_in[4], 1'b0}] != wea_in_sampled[{addra_in[4], 1'b1}]) begin				
				if (diaw != doaw) begin
				
				    for (i_1 = 0; i_1 < diaw; i_1 = i_1 + 1)
					doa_out_buf[i_1] = 1'bx;
				
				    for (i_1p = 0; i_1p < dipaw; i_1p = i_1p + 1)
					dopa_out_buf[i_1p] = 1'bx;

				end

			    end
			    

			    collision_call1_task(0);

			end // if (doaw <= diaw)
			
		    end // case: 16
		    
		    32 : begin // only doaw <= diaw			
			
			     for (i_2 = 0; i_2 <= 3; i_2 = i_2 +1) begin

				 if (wea_in_sampled[i_2] == 1) begin

				     for (i_3 = (8 * i_2); i_3 < (8 * (i_2 + 1)); i_3 = i_3 + 1)
				         doa_out_buf[i_3] = dia_in[i_3];

				     if (dopaw_1 != -1)
					 for (i_2p = i_2; i_2p < (i_2 + 1); i_2p = i_2p + 1)
					     dopa_out_buf[i_2p] = dipa_in[i_2p];

				 end
				 else if (wea_in_sampled[i_2] == 0) begin

				     for (i_3 = (8 * i_2); i_3 < (8 * (i_2 + 1)); i_3 = i_3 + 1)
				         doa_out_buf[i_3] = 1'bx;

				     if (dopaw_1 != -1)
					 for (i_2p = i_2; i_2p < (i_2 + 1); i_2p = i_2p + 1)
					     dopa_out_buf[i_2p] = 1'bx;

				 end
			     end // for (i_2 = 0; i_2 <= 3; i_2 = i_2 +1)

			
			     if (|wea_in_sampled == 0) begin

				 for (i_1 = 0; i_1 < diaw; i_1 = i_1 + 1)
				     doa_out_buf[i_1] = mem[address_write_a + i_1];
				 
				 if (dopaw_1 != -1)
				     for (i_1p = 0; i_1p < dipaw; i_1p = i_1p + 1)
					 dopa_out_buf[i_1p] = mem[16384 + address_parity_write_a + i_1p];
			     end
			     else if (wea_in_sampled != 4'b1111) begin
				 
				 if (diaw != doaw) begin

				    for (i_1 = 0; i_1 < diaw; i_1 = i_1 + 1)
					doa_out_buf[i_1] = 1'bx;
				
				    for (i_1p = 0; i_1p < dipaw; i_1p = i_1p + 1)
					dopa_out_buf[i_1p] = 1'bx;

				end

			    end
			
			
			    collision_call1_task(0);

		    end // case: 32

		endcase // case(diaw)

	    end // if (ssra_in == 0 && wr_mode_a == 2'b00)
	    
	    else if (ssra_in == 0 && wr_mode_a == 2'b01) begin

	        for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
		    doa_out_buf[i_1] = mem[address_read_a + i_1];

		if (dopaw_1 != -1)
		    for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1)
			dopa_out_buf[i_1p] = mem[(16384 + address_parity_read_a + i_1p)];

			collision_call0_task(0);
	    end
	    
	    else if (ssra_in == 0 && wr_mode_a == 2'b10) begin

		case (diaw)
		    1, 2, 4, 8 : begin
				     wea_index = addra_in[4:3];

				     if (wea_in_sampled[wea_index] == 0) begin

	        			for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
		    			    doa_out_buf[i_1] = mem[address_read_a + i_1];

					if (dopaw_1 != -1)
		    			    for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1)
					    dopa_out_buf[i_1p] = mem[(16384 + address_parity_read_a + i_1p)];

				     end

		    end  // 1, 2, 4, 8 :

		    16, 32 : begin
			     if (wea_in_sampled == 4'b0000) begin
				 
 	        		 for (i_1 = 0; i_1 < doaw; i_1 = i_1 + 1)
		    		     doa_out_buf[i_1] = mem[address_read_a + i_1];

				 if (dopaw_1 != -1)
		    		     for (i_1p = 0; i_1p < dopaw; i_1p = i_1p + 1)
					 dopa_out_buf[i_1p] = mem[(16384 + address_parity_read_a + i_1p)];

			     end
		    end

		endcase  // case (diaw)
		
		collision_call0_task(0);		

	    end // if (ssra_in == 0 && wr_mode_a == 2'b10)
	    
	end // if (ena_in == 1 && gsr_in == 0 && !(addra_in_14 == 1'b1 && cascade_a[1] == 1'b1))
	
    end // always @ (posedge clka_in or posedge gsr_in)


    
// ***** Port B ****** Memory Update ***** 
    always @(posedge clkb_in) begin

	if (enb_in == 1 && gsr_in == 0) begin

	    case (dibw)
		    1, 2, 4, 8 : begin
				     web_index = addrb_in[4:3];

				     if (web_in_sampled[web_index] == 1) begin

	        			for (ib_6 = 0; ib_6 < dibw; ib_6 = ib_6 + 1)
		    			    mem[address_write_b + ib_6] <= dib_in[ib_6];

					if (dipbw_1 != -1)
		    			    for (ib_6p = 0; ib_6p < dipbw; ib_6p = ib_6p + 1)
					        mem[(16384 + address_parity_write_b + ib_6p)] <= dipb_in[ib_6p];

				     end

		    end  // 1, 2, 4, 8 :

		    16 : begin
			     web_index = {addrb_in[4], 1'b0};

			     if (web_in_sampled[web_index] == 1) begin

			         for (ib_6 = 0; ib_6 <= (dibw/2 - 1); ib_6 = ib_6 + 1)
			             mem[address_write_b + ib_6] <= dib_in[ib_6];

				 if (dipbw_1 != -1)
				     for (ib_6p = 0; ib_6p <= (dipbw/2 - 1); ib_6p = ib_6p + 1)
					 mem[(16384 + address_parity_write_b + ib_6p)] <= dipb_in[ib_6p];

			     end

			     web_index = {addrb_in[4], 1'b1};

		 	     if (web_in_sampled[web_index] == 1) begin

			         for (ib_7 = dibw/2; ib_7 < dibw; ib_7 = ib_7 + 1)
				     mem[address_write_b + ib_7] <= dib_in[ib_7];

				 if (dipbw_1 != -1)
				     for (ib_7p = dipbw/2; ib_7p < dipbw; ib_7p = ib_7p + 1)
					 mem[16384 + address_parity_write_b + ib_7p] <= dipb_in[ib_7p];

			     end

		    end  // 16:

		    32 : begin

			     web_index = 0;
			     if (web_in_sampled[web_index] == 1) begin

				 for (ib_6 = 0; ib_6 <= (((dibw/4) * 1) - 1); ib_6 = ib_6 + 1)
				     mem[address_write_b + ib_6] <= dib_in[ib_6];

				 if (dipbw_1 != -1)
				     for (ib_6p = 0; ib_6p <= (((dipbw/4) * 1) - 1); ib_6p = ib_6p + 1)
					 mem[16384 + address_parity_write_b + ib_6p] <= dipb_in[ib_6p];
			     end

			     web_index = 1;
			     if (web_in_sampled[web_index] == 1) begin

				 for (ib_7 = (dibw/4) * 1; ib_7 <= (((dibw/4) * 2) - 1); ib_7 = ib_7 + 1)
				     mem[address_write_b + ib_7] <= dib_in[ib_7];

				 if (dipbw_1 != -1)
				     for (ib_7p = (dipbw/4) * 1; ib_7p <= (((dipbw/4) * 2) -1); ib_7p = ib_7p + 1)
					 mem[16384 + address_parity_write_b + ib_7p] <= dipb_in[ib_7p];
			     end

			     web_index = 2;
			     if (web_in_sampled[web_index] == 1) begin

				 for (ib_8 = (dibw/4) * 2; ib_8 <= (((dibw/4) * 3) - 1); ib_8 = ib_8 + 1)
				     mem[address_write_b + ib_8] <= dib_in[ib_8];

				 if (dipbw_1 != -1)
				     for (ib_8p = (dipbw/4) * 2; ib_8p <= (((dipbw/4) * 3) -1); ib_8p = ib_8p + 1)
					 mem[16384 + address_parity_write_b + ib_8p] <= dipb_in[ib_8p];
			     end

			     web_index = 3;
			     if (web_in_sampled[web_index] == 1) begin

				 for (ib_9 = (dibw/4) * 3; ib_9 <= (((dibw/4) * 4) - 1); ib_9 = ib_9 + 1)
				     mem[address_write_b + ib_9] <= dib_in[ib_9];

				 if (dipbw_1 != -1)
				     for (ib_9p = (dipbw/4) * 3; ib_9p <= (((dipbw/4) * 4) -1); ib_9p = ib_9p + 1)
					 mem[16384 + address_parity_write_b + ib_9p] <= dipb_in[ib_9p];
			     end
		    end  // 32 :

		endcase  // case (dibw) /**** memory update ***/

	end  // else if (enb_in == 1 && gsr_in == 0)

    end  // always @(posedge clkb_in) /**** memory update ***/


    
// ***** Port B *****
    always @(posedge clkb_in or posedge gsr_in) begin

	if (gsr_in == 1) begin

	    for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1) begin
	        dob_out[ib_1] <= INIT_B[ib_1];
		dob_out_buf[ib_1] <= INIT_B[ib_1];
	    end

	    if (dopbw_1 != -1)
	        for (ib_1p = 0; ib_1p < dopbw; ib_1p = ib_1p + 1) begin
	    	    dopb_out[ib_1p] <= INIT_B[ib_1p + dobw];
		    dopb_out_buf[ib_1p] <= INIT_B[ib_1p + dobw];
		end
	end
	else if (enb_in == 1 && gsr_in == 0) begin
	    if (ssrb_in == 1) begin
	        for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1) begin
		    dob_out[ib_1] <= SRVAL_B[ib_1];
		    dob_out_buf[ib_1] <= SRVAL_B[ib_1];
		end
		
		if (dopbw_1 != -1)
		    for (ib_1p = 0; ib_1p < dopbw; ib_1p = ib_1p + 1) begin
		        dopb_out[ib_1p] <= SRVAL_B[dobw + ib_1p];
			dopb_out_buf[ib_1p] <= SRVAL_B[dobw + ib_1p];
		    end
		
	    end
	    else if (ssrb_in == 0 && wr_mode_b == 2'b00) begin

		case (dibw)
		    1, 2, 4, 8 : begin
				     web_index = addrb_in[4:3];
				     if (web_in_sampled[web_index] == 1) begin

				         if (dobw > dibw) begin
					     					     
					     for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1)
					         dob_out_buf[ib_1] = mem[address_read_b + ib_1];
					     
					     for (ib_2 = 0; ib_2 < dibw; ib_2 = ib_2 + 1)
					         dob_out_buf[(dob_index * dibw) + ib_2] = dib_in[ib_2];


					     if (dopbw_1 != -1) begin

						 for (ib_1p = 0; ib_1p < dopbw; ib_1p = ib_1p + 1)
					             dopb_out_buf[ib_1p] = mem[16384 + address_parity_read_b + ib_1p];
					     
						 for (ib_2p = 0; ib_2p < dipbw; ib_2p = ib_2p + 1)
					             dopb_out_buf[(dopb_index * dipbw) + ib_2p] = dipb_in[ib_2p];
					    						 
					     end // if (dopbw > dipbw)		

					 end // if (dobw > dibw)
					 else if (dobw <= dibw) begin
					     					     
					     for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1)
					         dob_out_buf[ib_1] = dib_in[(dob_index * dobw) + ib_1];

					     if (dopbw_1 != -1)  // only when dipbw = dopbw = 8
						 for (ib_1p = 0; ib_1p < dipbw; ib_1p = ib_1p + 1)
					             dopb_out_buf[ib_1p] = dipb_in[ib_1p];
					     
					 end // if (dobw <= dibw)
					 
				     end			
				     else if (web_in_sampled[web_index] == 0) begin  // web disable

					 for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1)
					     dob_out_buf[ib_1] = mem[address_read_b + ib_1];
					 
					 if (dopbw_1 != -1)
					     for (ib_1p = 0; ib_1p < dopbw; ib_1p = ib_1p + 1)
					         dopb_out_buf[ib_1p] = mem[16384 + address_parity_read_b + ib_1p];

				     end

			             collision_call0_task(1);		

		    end // case: 1, 2, 4, 8		    

		    16 : begin // dipbw = 2

			if (dobw > dibw) begin  // only when dobw = 32, dopbw = 4
			    
			    for (i_1 = 0; i_1 < dobw; i_1 = i_1 + 1)
				dob_out_buf[i_1] = mem[address_read_b + i_1];
			    
			    for (i_1p = 0; i_1p < dopbw; i_1p = i_1p + 1)
				dopb_out_buf[i_1p] = mem[16384 + address_parity_read_b + i_1p];

			    
			    if (web_in_sampled[{addrb_in[4], 1'b0}] != web_in_sampled[{addrb_in[4], 1'b1}]) begin

				for (i_1 = 0; i_1 < dobw; i_1 = i_1 + 1)
				    dob_out_buf[i_1] = 1'bx;
				
				for (i_1p = 0; i_1p < dopbw; i_1p = i_1p + 1)
				    dopb_out_buf[i_1p] = 1'bx;

			    end
			    else begin
			    
				web_index = {addrb_in[4], 1'b0};
			    
				if (web_in_sampled[web_index] == 1) begin
				    
				    for (i_2 = 0; i_2 < dibw/2; i_2 = i_2 + 1)
					dob_out_buf[(dob_index * dibw) + i_2] = dib_in[i_2];
				    
				    for (i_2p = 0; i_2p < dipbw/2; i_2p = i_2p + 1)
					dopb_out_buf[(dopb_index * dipbw) + i_2p] = dipb_in[i_2p];
				
				end
				
				
				web_index = {addrb_in[4], 1'b1};
				
				if (web_in_sampled[web_index] == 1) begin
				    
				    for (i_3 = dibw/2; i_3 < dibw; i_3 = i_3 + 1)
					dob_out_buf[(dob_index * dibw) + i_3] = dib_in[i_3];
				    
				    for (i_3p = dipbw/2; i_3p < dipbw; i_3p = i_3p + 1)
				    dopb_out_buf[(dopb_index * dipbw) + i_3p] = dipb_in[i_3p];
				    
				end

			    end // else: !if(web_in_sampled[{addrb_in[4], 1'b0}] != web_in_sampled[{addrb_in[4], 1'b1}])
			    

			    collision_call0_task(1);

			end // if (dobw > dibw)			
			else if (dobw <= dibw) begin
			    
			    web_index = {addrb_in[4], 1'b0};
			    
			    if (web_in_sampled[web_index] == 1) begin
				
				for (i_2 = 0; i_2 < dibw/2; i_2 = i_2 + 1)
				    dob_out_buf[i_2] = dib_in[i_2];
				    
				if (dopbw_1 != -1)
				    for (i_2p = 0; i_2p < dipbw/2; i_2p = i_2p + 1)
					dopb_out_buf[i_2p] = dipb_in[i_2p];
				    
			    end
			    else if (web_in_sampled[{addrb_in[4], 1'b0}] != web_in_sampled[{addrb_in[4], 1'b1}]) begin

				for (i_2 = 0; i_2 < dibw/2; i_2 = i_2 + 1)
				    dob_out_buf[i_2] = 1'bx;
				    
				if (dopbw_1 != -1)
				    for (i_2p = 0; i_2p < dipbw/2; i_2p = i_2p + 1)
					dopb_out_buf[i_2p] = 1'bx;

			    end
				
			    
			    web_index = {addrb_in[4], 1'b1};
				
			    if (web_in_sampled[web_index] == 1) begin
				
				for (i_3 = dibw/2; i_3 < dibw; i_3 = i_3 + 1)
				    dob_out_buf[i_3] = dib_in[i_3];

				if (dopbw_1 != -1)
				    for (i_3p = dipbw/2; i_3p < dipbw; i_3p = i_3p + 1)
					dopb_out_buf[i_3p] = dipb_in[i_3p];
				    
			    end
			    else if (web_in_sampled[{addrb_in[4], 1'b0}] != web_in_sampled[{addrb_in[4], 1'b1}]) begin

				for (i_3 = dibw/2; i_3 < dibw; i_3 = i_3 + 1)
				    dob_out_buf[i_3] = 1'bx;

				if (dopbw_1 != -1)
				    for (i_3p = dipbw/2; i_3p < dipbw; i_3p = i_3p + 1)
					dopb_out_buf[i_3p] = 1'bx;
				    
			    end

			    
			    if ((web_in_sampled[{addrb_in[4], 1'b0}] === web_in_sampled[{addrb_in[4], 1'b1}]) && web_in_sampled[{addrb_in[4], 1'b1}] == 0) begin

				for (i_1 = 0; i_1 < dibw; i_1 = i_1 + 1)
				    dob_out_buf[i_1] = mem[address_write_b + i_1];
			    
				if (dopbw_1 != -1)
				    for (i_1p = 0; i_1p < dipbw; i_1p = i_1p + 1)
					dopb_out_buf[i_1p] = mem[16384 + address_parity_write_b + i_1p];

			    end
			    else if (web_in_sampled[{addrb_in[4], 1'b0}] != web_in_sampled[{addrb_in[4], 1'b1}]) begin				
				if (dibw != dobw) begin
				
				    for (i_1 = 0; i_1 < dibw; i_1 = i_1 + 1)
					dob_out_buf[i_1] = 1'bx;
				    
				    if (dopbw_1 != -1)
					for (i_1p = 0; i_1p < dipbw; i_1p = i_1p + 1)
					    dopb_out_buf[i_1p] = 1'bx;

				end

			    end
			    

			    collision_call1_task(1);

			end // if (dobw <= dibw)
			
		    end // case: 16
		    
		    32 : begin // only dobw <= dibw			
			
			     for (i_2 = 0; i_2 <= 3; i_2 = i_2 +1) begin

				 if (web_in_sampled[i_2] == 1) begin

				     for (i_3 = (8 * i_2); i_3 < (8 * (i_2 + 1)); i_3 = i_3 + 1)
				         dob_out_buf[i_3] = dib_in[i_3];

				     if (dopbw_1 != -1)
					 for (i_2p = i_2; i_2p < (i_2 + 1); i_2p = i_2p + 1)
					     dopb_out_buf[i_2p] = dipb_in[i_2p];

				 end
				 else if (web_in_sampled[i_2] == 0) begin

				     for (i_3 = (8 * i_2); i_3 < (8 * (i_2 + 1)); i_3 = i_3 + 1)
				         dob_out_buf[i_3] = 1'bx;

				     if (dopbw_1 != -1)
					 for (i_2p = i_2; i_2p < (i_2 + 1); i_2p = i_2p + 1)
					     dopb_out_buf[i_2p] = 1'bx;

				 end
			     end // for (i_2 = 0; i_2 <= 3; i_2 = i_2 +1)

			
			     if (|web_in_sampled == 0) begin

				 for (i_1 = 0; i_1 < dibw; i_1 = i_1 + 1)
				     dob_out_buf[i_1] = mem[address_write_b + i_1];
				 
				 if (dopbw_1 != -1)
				     for (i_1p = 0; i_1p < dipbw; i_1p = i_1p + 1)
					 dopb_out_buf[i_1p] = mem[16384 + address_parity_write_b + i_1p];
			     end
			     else if (web_in_sampled != 4'b1111) begin
				 
				 if (dibw != dobw) begin

				    for (i_1 = 0; i_1 < dibw; i_1 = i_1 + 1)
					dob_out_buf[i_1] = 1'bx;
				
				    for (i_1p = 0; i_1p < dipbw; i_1p = i_1p + 1)
					dopb_out_buf[i_1p] = 1'bx;

				end

			    end
			
			
			    collision_call1_task(1);

		    end // case: 32

		endcase // case(dibw)

	    end // if (ssrb_in == 0 && wr_mode_b == 2'b00)
	    
	    else if (ssrb_in == 0 && wr_mode_b == 2'b01) begin

	        for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1)
		    dob_out_buf[ib_1] = mem[address_read_b + ib_1];

		if (dopbw_1 != -1)
		    for (ib_1p = 0; ib_1p < dopbw; ib_1p = ib_1p + 1)
			dopb_out_buf[ib_1p] = mem[(16384 + address_parity_read_b + ib_1p)];

		collision_call0_task(1);

	    end
	    
	    else if (ssrb_in == 0 && wr_mode_b == 2'b10) begin

		case (dibw)
		    1, 2, 4, 8 : begin
				     web_index = addrb_in[4:3];

				     if (web_in_sampled[web_index] == 0) begin

	        			for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1)
		    			    dob_out_buf[ib_1] = mem[address_read_b + ib_1];

					if (dopbw_1 != -1)
		    			    for (ib_1p = 0; ib_1p < dopbw; ib_1p = ib_1p + 1)
					    dopb_out_buf[ib_1p] = mem[(16384 + address_parity_read_b + ib_1p)];

				     end

		    end  // 1, 2, 4, 8 :

		    16, 32 : begin
			     if (web_in_sampled == 4'b0000) begin
				 
 	        		 for (ib_1 = 0; ib_1 < dobw; ib_1 = ib_1 + 1)
		    		     dob_out_buf[ib_1] = mem[address_read_b + ib_1];

				 if (dopbw_1 != -1)
		    		     for (ib_1p = 0; ib_1p < dopbw; ib_1p = ib_1p + 1)
					 dopb_out_buf[ib_1p] = mem[(16384 + address_parity_read_b + ib_1p)];

			     end
		    end

		endcase  // case (dibw)
		
		collision_call0_task(1);

	    end // if (ssrb_in == 0 && wr_mode_b == 2'b10)
	    
	end // if (enb_in == 1 && gsr_in == 0 && !(addrb_in_14 == 1'b1 && cascade_b[1] == 1'b1))
	
    end // always @ (posedge clkb_in or posedge gsr_in)

    


    
   

    
// collision checks

// need to disable if no checks
    always @(posedge clka_in) begin
	
	// registering for inputs for collision checks
	address_read_a_reg = address_read_a;
	address_parity_read_a_reg = address_parity_read_a;
	address_write_a_reg = address_write_a;
	address_parity_write_a_reg = address_parity_write_a;
	ena_reg = ena_in;
	wea_in_sampled_reg = wea_in_sampled;
	dia_reg = dia_in;
	dipa_reg = dipa_in;
	prev_time = curr_time;
	curr_time = $time;
	if (ena_in == 1) ssra_reg_col = ssra_in;
    end

    always @(posedge clkb_in) begin
	
	// registering for inputs for collision checks
	address_read_b_reg = address_read_b;
	address_parity_read_b_reg = address_parity_read_b;
	address_write_b_reg = address_write_b;
	address_parity_write_b_reg = address_parity_write_b;
	enb_reg = enb_in;
	web_in_sampled_reg = web_in_sampled;
	dib_reg = dib_in;
	dipb_reg = dipb_in;
	prev_time = curr_time;
	curr_time = $time;
	if (enb_in == 1) ssrb_reg_col = ssrb_in;
	
    end


    task collision_task;

	input port;
	input integer setup_all_parameter, setup_read_first_parameter;
	inout [31:0] out_curr, out_reg;
	inout [3:0] outp_curr, outp_reg;
	inout [2:0] col_msg_flag;
	
	time time_diff;
	reg [3:0] we_curr, we_reg;
	reg [1:0] wr_mode_curr, wr_mode_reg;
	integer setup_time, t_a, diow_curr, diow_reg, diow;
	reg [13:0] addr_curr, addr_reg, addr_smallest_s;
	reg [13:0] col_addr_curr, col_addr_reg;
	reg [4:0] addr_index;
	reg col_check_flag;

	integer diopw_curr, diopw_reg;
	reg [11:0] addr_parity_curr, addr_parity_reg;
	reg [11:0] addr_parity_smallest_s;
	integer diopw;
	reg [1:0] addr_parity_index;
	integer diw, dipw;
	reg wr_col_check_flag;
	reg [1:0] wr_addr_parity_index;
	reg [4:0] wr_addr_index;
	reg [13:0] wr_addr_reg;
	reg [11:0] wr_addr_parity_reg;
	reg wr_we_curr, wr_we_reg;
	reg [2:0] junk;
	reg [31:0] di_curr, di_reg;
	reg [3:0] dip_curr, dip_reg;
	reg [11:0] wr_addr_parity_smallest_s;
	reg [13:0] wr_addr_smallest_s;
	
	integer sdata_index, sdata_parity_index;
	integer sdata_index_pre, sdata_parity_index_pre;
	integer sdata_index_smaller_s, sdata_parity_index_smaller_s;
	reg cross_wr_rd_ports_check;

	begin

	    col_check_flag = 0;
	    wr_col_check_flag = 0;

	    addr_index = 5'b00000;
	    wr_addr_index = 5'b00000;
	    addr_parity_index = 2'b00;
	    wr_addr_parity_index = 2'b00;
	    sdata_index_smaller_s = 0;
	    sdata_parity_index_smaller_s = 0;
	    sdata_parity_index = 0;
	    sdata_index = 0;


	    time_diff = curr_time - prev_time;
	    
	    if ((port ===  0 && enb_reg === 0) || (port === 1 && ena_reg === 0))
		disable collision_task;


	    if (time_diff == 0) begin
		    
		setup_time = 0;

		if (port == 0) begin

		    wr_mode_curr = wr_mode_a;
		    wr_mode_reg = wr_mode_b;
		    we_curr = wea_in_sampled;
		    we_reg = web_in_sampled;

		end
		else if (port == 1) begin

		    wr_mode_curr = wr_mode_b;
		    wr_mode_reg = wr_mode_a;
		    we_curr = web_in_sampled;
		    we_reg = wea_in_sampled;

		end

	    end
	    else if (time_diff <= setup_read_first_parameter) begin

		if (time_diff <= setup_all_parameter)

		    setup_time = 1;

		else

		    setup_time = 3;
			

		if (port == 0) begin

		    wr_mode_curr = wr_mode_a;
		    wr_mode_reg = wr_mode_b;
		    we_curr = wea_in_sampled;
		    we_reg = web_in_sampled_reg;

		end
		else if (port == 1) begin
			
		    wr_mode_curr = wr_mode_b;
		    wr_mode_reg = wr_mode_a;
		    we_curr = web_in_sampled;
		    we_reg = wea_in_sampled_reg;

		end
	    end // if (time_diff <= setup_read_first_parameter)
	    else begin
		    
		disable collision_task;

	    end // else: !if(time_diff <= setup_read_first_parameter)
	    
		
	    for (t_a = 0; t_a <= 3; t_a = t_a + 1) begin : t_a_loop

		
		case ({we_curr[t_a], we_reg[t_a]})

		    2'b00 : disable t_a_loop;
		    2'b01 : begin 
			        if (port == 0) begin
				    diow_curr = doaw;
				    diow_reg = dibw;
				    addr_curr = address_read_a;
				    addr_reg = address_write_b_reg;
				    col_addr_curr = address_read_a & zero_write_b;
				    col_addr_reg = address_write_b_reg & zero_read_a;
				    diopw_curr = dopaw;
				    diopw_reg = dipbw;
				    addr_parity_curr = address_parity_read_a;
				    addr_parity_reg = address_parity_write_b_reg;
				end
				else if (port == 1) begin
				    diow_reg = diaw;
				    diow_curr = dobw;
				    addr_curr = address_read_b;
				    addr_reg = address_write_a_reg;
				    col_addr_curr = address_read_b & zero_write_a;
				    col_addr_reg = address_write_a_reg & zero_read_b;
				    diopw_reg = dipaw;
				    diopw_curr = dopbw;
				    addr_parity_curr = address_parity_read_b;
				    addr_parity_reg = address_parity_write_a_reg;
				end
		            end
		    2'b10 : begin 
			        if (port == 0) begin
				    diow_curr = diaw;
				    diow_reg = dobw;
				    addr_curr = address_write_a;
				    addr_reg = address_read_b_reg;
				    col_addr_curr = address_write_a & zero_read_b;
				    col_addr_reg = address_read_b_reg & zero_write_a;
				    diopw_curr = dipaw;
				    diopw_reg = dopbw;
				    addr_parity_curr = address_parity_write_a;
				    addr_parity_reg = address_parity_read_b_reg;
				end
				else if (port == 1) begin
				    diow_reg = doaw;
				    diow_curr = dibw;
				    addr_curr = address_write_b;
				    addr_reg = address_read_a_reg;
				    col_addr_curr = address_write_b & zero_read_a;
				    col_addr_reg = address_read_a_reg & zero_write_b;
				    diopw_reg = dopaw;
				    diopw_curr = dipbw;
				    addr_parity_curr = address_parity_write_b;
				    addr_parity_reg = address_parity_read_a_reg;
				end
			    end
		    2'b11 : begin 
			        if (port == 0) begin
				    diow_curr = diaw;
				    diow_reg = dibw;
				    addr_curr = address_write_a;
				    addr_reg = address_write_b_reg;
				    col_addr_curr = address_write_a & zero_write_b;
				    col_addr_reg = address_write_b_reg & zero_write_a;
				    diopw_curr = dipaw;
				    diopw_reg = dipbw;
				    addr_parity_curr = address_parity_write_a;
				    addr_parity_reg = address_parity_write_b_reg;
				    wr_addr_reg = address_read_b_reg;
				    wr_addr_parity_reg = address_parity_read_b_reg;
				end
				else if (port == 1) begin
				    diow_reg = diaw;
				    diow_curr = dibw;
				    addr_curr = address_write_b;
				    addr_reg = address_write_a_reg;
				    col_addr_curr = address_write_b & zero_write_a;
				    col_addr_reg = address_write_a_reg & zero_write_b;
				    diopw_reg = dipaw;
				    diopw_curr = dipbw;
				    addr_parity_curr = address_parity_write_b;
				    addr_parity_reg = address_parity_write_a_reg;
				    wr_addr_reg = address_read_a_reg;
				    wr_addr_parity_reg = address_parity_read_a_reg;
				end
			    end

		endcase // case({we_curr[t_a], we_reg[t_a]})

		    
		if (diow_curr < diow_reg) begin
		    diow = diow_curr;
		end
		else begin
		    diow = diow_reg;
		end

		
		if (diopw_curr < diopw_reg) begin
		    diopw = diopw_curr;
		end
		else begin
		    diopw = diopw_reg;
		end


		if (diow_curr <= diow_reg) begin
		    
		    case (diow_curr)

			1 : begin

			        case (diow_reg)
				
				    1 : sdata_index_pre = 0;
				    2 : sdata_index_pre = addr_curr[0];
				    4 : sdata_index_pre = addr_curr[1:0];
				    8 : sdata_index_pre = addr_curr[2:0];
				    16 : sdata_index_pre = addr_curr[3:0];
				    32 : sdata_index_pre = addr_curr[4:0];
						
				endcase // case(diow_reg)

			    end
			2 : begin
					    
			        case (diow_reg)

				    2 : sdata_index_pre = 0;
				    4 : sdata_index_pre = addr_curr[1];
				    8 : sdata_index_pre = addr_curr[2:1];
				    16 : sdata_index_pre = addr_curr[3:1];
				    32 : sdata_index_pre = addr_curr[4:1];

				endcase // case(diow_reg)

			    end
			4 : begin

			        case (diow_reg)

				    4 : sdata_index_pre = 0;
				    8 : sdata_index_pre = addr_curr[2];
				    16 : sdata_index_pre = addr_curr[3:2];
				    32 : sdata_index_pre = addr_curr[4:2];
					    
				endcase // case(diow_reg)

			    end
			8 : begin

			        case (diow_reg)

				    8 : begin 
					    sdata_index_pre = 0;
					    sdata_parity_index_pre = 0;
				        end
				    16 : begin 
					     sdata_index_pre = addr_curr[3];
					     sdata_parity_index_pre = addr_parity_curr[0];
				         end			
				    32 : begin 
					     sdata_index_pre = addr_curr[4:3];
					     sdata_parity_index_pre = addr_parity_curr[1:0];
				         end
			
				endcase // case(diow_reg)
			    end
	       		16 : begin

			        case (diow_reg)
				    
				    16 : begin 
					     sdata_index_pre = 0;
					     sdata_parity_index_pre = 0;
				         end
				    32 : begin 
					     sdata_index_pre = addr_curr[4];
					     sdata_parity_index_pre = addr_parity_curr[1];
				         end
					    
				endcase // case(diow_reg)
			     end
	       		32 : begin 

			         sdata_index_pre = 0;
			         sdata_parity_index_pre = 0;
					
			     end

		    endcase

		end // if (diow_curr <= diow_reg)	    
		else if (diow_curr > diow_reg) begin

		    case (diow_reg)

			1 : begin

			        case (diow_curr)

				    2 : sdata_index_pre = addr_reg[0];
				    4 : sdata_index_pre = addr_reg[1:0];
				    8 : sdata_index_pre = addr_reg[2:0];
				    16 : sdata_index_pre = addr_reg[3:0];
				    32 : sdata_index_pre = addr_reg[4:0];
				
				endcase // case(diow_curr)

			    end
			2 : begin

			        case (diow_curr)

				    4 : sdata_index_pre = addr_reg[1];
				    8 : sdata_index_pre = addr_reg[2:1];
				    16 : sdata_index_pre = addr_reg[3:1];
				    32 : sdata_index_pre = addr_reg[4:1];
				    
				endcase // case(diow_curr)

			    end
			4 : begin

			        case (diow_curr)

				    8 : sdata_index_pre = addr_reg[2];
				    16 : sdata_index_pre = addr_reg[3:2];
				    32 : sdata_index_pre = addr_reg[4:2];
				    
				endcase // case(diow_curr)

			    end
			8 : begin

			        case (diow_curr)

				    16 : begin 
					     sdata_index_pre = addr_reg[3];
					     sdata_parity_index_pre = addr_parity_reg[0];
				         end			
				    32 : begin 
					     sdata_index_pre = addr_reg[4:3];
					     sdata_parity_index_pre = addr_parity_reg[1:0];
				         end
			
				endcase // case(diow_curr)
			    end
	       		16 : begin

		                 sdata_index_pre = addr_reg[4];
		                 sdata_parity_index_pre = addr_parity_reg[1];

			end
			
		    endcase // case(diow_reg)

		end // if (diow_curr > diow_reg)

		
		if (port == 0) begin
		    if (addr_curr <= addr_reg) begin
			if (diow_reg != 1 && addr_curr != addr_reg) begin
			    sdata_index = sdata_index_pre * diow_reg;
			    sdata_parity_index = sdata_parity_index_pre * diopw_reg;
			end
			else begin
			    sdata_index = sdata_index_pre;
			    sdata_parity_index = sdata_parity_index_pre;
			end
		    end
		    else if (addr_curr > addr_reg) begin
			if (diow_curr != 1) begin
			    sdata_index = sdata_index_pre * diow_curr;
			    sdata_parity_index = sdata_parity_index_pre * diopw_curr;
			end
			else begin
			    sdata_index = sdata_index_pre;
			    sdata_parity_index = sdata_parity_index_pre;
			end
		    end
		end // if (port == 0)
		else if (port == 1) begin
		    if (addr_curr <= addr_reg) begin
			if (diow_reg != 1 && addr_curr != addr_reg) begin
			    sdata_index = sdata_index_pre * diow_reg;
			    sdata_parity_index = sdata_parity_index_pre * diopw_reg;
			end
			else begin
			    sdata_index = sdata_index_pre;
			    sdata_parity_index = sdata_parity_index_pre;
			end
		    end
		    else if (addr_curr > addr_reg) begin
			if (diow_curr != 1) begin
			    sdata_index = sdata_index_pre * diow_curr;
			    sdata_parity_index = sdata_parity_index_pre * diopw_curr;
			end
			else begin
			    sdata_index = sdata_index_pre;
			    sdata_parity_index = sdata_parity_index_pre;
			end
		    end
		end // if (port == 1)

		
		if (port == 0) begin
		    di_curr = dia_in;
		    di_reg = dib_reg;
		    dip_curr = dipa_in;
		    dip_reg = dipb_reg;
		end
		else if (port == 1) begin
		    di_curr = dib_in;
		    di_reg = dia_reg;
		    dip_curr = dipb_in;
		    dip_reg = dipa_reg;
		end
		

		if (addr_curr > addr_reg) begin
		    addr_smallest_s = addr_curr;
		    addr_parity_smallest_s = addr_parity_curr;
		end
		else begin
		    addr_smallest_s = addr_reg;
		    addr_parity_smallest_s = addr_parity_reg;
		end

			    
		if (diow <= 8) begin
		    if (addr_smallest_s[4:3] == t_a) begin
			col_check_flag = 1;
		    end
		    else begin
			col_check_flag = 0;
		    end
		end
		else if (diow == 16) begin
		    if (({addr_smallest_s[4], 1'b0} == t_a) || ({addr_smallest_s[4], 1'b1} == t_a)) begin
			col_check_flag = 1;
		    end
		    else begin
			col_check_flag = 0;
		    end
		end
		else if (diow == 32) begin
		    col_check_flag = 1;  // always loop 4 times
		end
		

		if (col_addr_curr === col_addr_reg) begin  // real address collision

		    if (col_check_flag == 1) begin
				
			if (addr_curr[4:0] > addr_reg[4:0]) begin
			    
				addr_index = addr_curr[4:0];
				addr_parity_index = addr_parity_curr[1:0];
			    
			end
			else begin

				addr_index = addr_reg[4:0];
				addr_parity_index = addr_parity_reg[1:0];

			end // else: !if(addr_curr[4:0] > addr_reg[4:0])


			case (diow)
			    
			    1, 2, 4, 8 : begin

				             sdata_index_smaller_s = 0;
				             sdata_parity_index_smaller_s = 0;
    
			                     collision_table_task(sdata_index, sdata_parity_index,sdata_index_smaller_s, sdata_parity_index_smaller_s, port, we_curr[t_a], we_reg[t_a], di_curr, di_reg, dip_curr, dip_reg, addr_curr, addr_reg, setup_time, wr_mode_curr, wr_mode_reg, addr_index, addr_parity_index, addr_smallest_s, addr_parity_smallest_s, diow, diopw, out_curr, out_reg, outp_curr, outp_reg, col_msg_flag);
			                 end
			    16 : begin
				
				     if (t_a == 1 || t_a == 3) begin  // t_a = 1 or 3 means come in the 2nd time, so + 8

					 sdata_index_smaller_s = sdata_index_smaller_s + 8;
					 sdata_parity_index_smaller_s = sdata_parity_index_smaller_s + 1;
					 sdata_index = sdata_index + 8;
					 sdata_parity_index = sdata_parity_index + 1;
					 addr_index = addr_index + 8;
					 addr_parity_index = addr_parity_index + 1;					 
					 addr_smallest_s = addr_smallest_s + 8;
					 addr_parity_smallest_s = addr_parity_smallest_s + 1;
					 
				     end

       				     diow = 8;
				     diopw = 1;

				     collision_table_task(sdata_index, sdata_parity_index,sdata_index_smaller_s, sdata_parity_index_smaller_s, port, we_curr[t_a], we_reg[t_a], di_curr, di_reg, dip_curr, dip_reg, addr_curr, addr_reg, setup_time, wr_mode_curr, wr_mode_reg, addr_index, addr_parity_index, addr_smallest_s, addr_parity_smallest_s, diow, diopw, out_curr, out_reg, outp_curr, outp_reg, col_msg_flag);

			         end
			    32 : begin

				     if (t_a != 0) begin// t_a = 1,2 or 3 means come in the 2nd time, so + 8

					 sdata_index_smaller_s = sdata_index_smaller_s + 8;
					 sdata_parity_index_smaller_s = sdata_parity_index_smaller_s + 1;
					 sdata_index = sdata_index + (8 * t_a);
					 sdata_parity_index = sdata_parity_index + t_a;					 
					 addr_index = addr_index + (8 * t_a);
					 addr_parity_index = addr_parity_index + t_a;
					 addr_smallest_s = addr_smallest_s + (8 * t_a);
					 addr_parity_smallest_s = addr_parity_smallest_s + t_a;

				     end
				
       				     diow = 8;
				     diopw = 1;

				     collision_table_task(sdata_index, sdata_parity_index,sdata_index_smaller_s, sdata_parity_index_smaller_s, port, we_curr[t_a], we_reg[t_a], di_curr, di_reg, dip_curr, dip_reg, addr_curr, addr_reg, setup_time, wr_mode_curr, wr_mode_reg, addr_index, addr_parity_index, addr_smallest_s, addr_parity_smallest_s, diow, diopw, out_curr, out_reg, outp_curr, outp_reg, col_msg_flag);

			         end
			endcase // case(diow_curr)

		    end // if (col_check_flag == 1)


		    
		    cross_wr_rd_ports_check = 0;
		    
		    if (cross_wr_rd_ports_check) begin 	// corss checking - disable for now
		    // corss checking - disable for now
		    if (port == 0) begin
			if (diaw < dibw) begin
			    diw = dibw;
			    dipw = dipbw;
			    wr_we_curr = 0;
			    wr_we_reg = 1;
			end
			else begin
			    diw = diaw;
			    dipw = dipaw;
			    wr_we_curr = 1;
				wr_we_reg = 0;
			end
		    end // if (port == 0)
		    else if (port == 1) begin
			if (diaw < dibw) begin
			    diw = dibw;
			    dipw = dipbw;
			    wr_we_curr = 1;
			    wr_we_reg = 0;
			end
			else begin
			    diw = diaw;
			    dipw = dipaw;
			    wr_we_curr = 0;
			    wr_we_reg = 1;
			end
		    end // if (port == 1)
			

		    if (addr_curr > wr_addr_reg) begin
			wr_addr_smallest_s = addr_curr;
			wr_addr_parity_smallest_s = addr_parity_curr;
		    end
		    else begin
			wr_addr_smallest_s = wr_addr_reg;
			wr_addr_parity_smallest_s = wr_addr_parity_reg;
		    end
			    
			
		    if (diw <= 8) begin
			if (wr_addr_smallest_s[4:3] == t_a) begin
			    wr_col_check_flag = 1;
			end
			else begin
			    wr_col_check_flag = 0;
			end
		    end
		    else if (diw == 16) begin
			if (({wr_addr_smallest_s[4], 1'b0} == t_a) || ({wr_addr_smallest_s[4], 1'b1} == t_a)) begin
			    wr_col_check_flag = 1;
			end
			else begin
			    wr_col_check_flag = 0;
			end
		    end
		    else if (diw == 32) begin
			wr_col_check_flag = 1;  // always loop 4 times
		    end

			// check di to do ports width and exit if their are identical (overwrite wr_col_check_flag of above) 
		    if (port == 0) begin
			if (diaw < dibw) begin
			    if (dibw >= doaw)
				wr_col_check_flag = 0;
			end
			else begin
			    if (diaw >= dobw)
				wr_col_check_flag = 0;
			end
		    end
		    else if (port == 1) begin
			if (diaw < dibw) begin
			    if (dibw >= doaw)
				wr_col_check_flag = 0;
			end
			else begin
			    if (diaw >= dobw)
				wr_col_check_flag = 0;
			end
		    end
		    
				
		    // permanetly disable cross collision checks -- this overwrites all the above assignment
		    wr_col_check_flag = 0;
			


		    if (addr_curr[4:0] > wr_addr_reg[4:0]) begin
			wr_addr_index = addr_curr[4:0];
			wr_addr_parity_index = addr_parity_curr[1:0];
		    end
		    else begin
			wr_addr_index = wr_addr_reg[4:0];
			wr_addr_parity_index = wr_addr_parity_reg[1:0];
		    end // else: !if(addr_curr[4:0] > addr_reg[4:0])

		
		    if (we_curr[t_a] === we_reg[t_a] && we_curr[t_a] === 1 && wr_col_check_flag == 1) begin

			case (diw)

			    1, 2, 4, 8 : begin
			    
				collision_table_task(sdata_index, sdata_parity_index,sdata_index_smaller_s, sdata_parity_index_smaller_s, port, wr_we_curr, wr_we_reg, di_curr, di_reg, dip_curr, dip_reg, addr_curr, addr_reg, setup_time, 2'b00, 2'b00, wr_addr_index, wr_addr_parity_index, wr_addr_smallest_s, wr_addr_parity_smallest_s, diw, dipw, out_curr, out_reg, outp_curr, outp_reg, junk);

			    end // case: 1, 2, 4, 8
			    16 : begin

				    if (t_a == 1 || t_a == 3) begin

					wr_addr_index = wr_addr_index + 8;
					wr_addr_parity_index = wr_addr_parity_index + 1;
					wr_addr_smallest_s = wr_addr_smallest_s + 8;
					wr_addr_parity_smallest_s = wr_addr_parity_smallest_s + 1;
					
				    end // if (t_a == 1 || t_a == 3)
			
				    diw = 8;
				    dipw = 1;
			    
				    collision_table_task(sdata_index, sdata_parity_index,sdata_index_smaller_s, sdata_parity_index_smaller_s, port, wr_we_curr, wr_we_reg, di_curr, di_reg, dip_curr, dip_reg, addr_curr, addr_reg, setup_time, 2'b00, 2'b00, wr_addr_index, wr_addr_parity_index, wr_addr_smallest_s, wr_addr_parity_smallest_s, diw, dipw, out_curr, out_reg, outp_curr, outp_reg, junk);

			         end // case: 16
		    
			    32 : begin

				     if (t_a != 0) begin// t_a = 1,2 or 3 means come in the 2nd time, so + 8

					 wr_addr_index = wr_addr_index + 8;
					 wr_addr_parity_index = wr_addr_parity_index + 1;
					 wr_addr_smallest_s = wr_addr_smallest_s + (8 * t_a);
					 wr_addr_parity_smallest_s = wr_addr_parity_smallest_s + t_a;

				     end
			
				     diw = 8;
			             dipw = 1;
			
			    
			             collision_table_task(sdata_index, sdata_parity_index,sdata_index_smaller_s, sdata_parity_index_smaller_s, port, wr_we_curr, wr_we_reg, di_curr, di_reg, dip_curr, dip_reg, addr_curr, addr_reg, setup_time, 2'b00, 2'b00, wr_addr_index, wr_addr_parity_index, wr_addr_smallest_s, wr_addr_parity_smallest_s, diw, dipw, out_curr, out_reg, outp_curr, outp_reg, junk);

			        end // case: 32

			endcase // case(diw)
			    

			
			if (wr_mode_curr == 2'b10) begin
			    out_curr = 32'b0;
			    outp_curr = 4'b0;
			end
			if (wr_mode_reg == 2'b10) begin
			    out_reg = 32'b0;
			    outp_reg = 4'b0;
			end

		    end // if (we_curr[t_a] === we_reg[t_a] && we_curr[t_a] === 1 && wr_col_check_flag == 1)

		    end // if (cross_wr_rd_ports_check)
			
		end // if (col_addr_curr === col_addr_reg)
    
	    end // for (t_a = 0; t_a <= 3; t_a = t_a + 1)


	    // shifting outputs
	    if (col_msg_flag != 3'b000 && (we_curr !== 4'b0000 || we_reg !== 4'b0000)) begin

		if (port == 0) begin

		    out_curr = out_curr >> address_read_a[4:0];
		    out_reg = out_reg >> address_read_b_reg[4:0];

		    if (dopaw != 0)
			outp_curr = outp_curr >> address_parity_read_a[1:0];

		    if (dopbw != 0)
			outp_reg = outp_reg >> address_parity_read_b_reg[1:0];
		    
		end
		else if (port == 1) begin

		    out_curr = out_curr >> address_read_b[4:0];
		    out_reg = out_reg >> address_read_a_reg[4:0];

		    if (dopbw != 0)
			outp_curr = outp_curr >> address_parity_read_b[1:0];

		    if (dopaw != 0)
			outp_reg = outp_reg >> address_parity_read_a_reg[1:0];

		end // if (port == 1)

	    end // if (col_msg_flag != 3'b000 && (we_curr !== 4'b0000 || we_reg !== 4'b0000) && ((diow_curr !== diow_reg) || diow_curr <= 8))
	end
	
    endtask // collision_task


    task collision_table_task;

	input integer sdata_index, sdata_parity_index;
	input integer sdata_index_smaller_s, sdata_parity_index_smaller_s;
	input port;
	input we_curr, we_reg;
	input [31:0] di_curr, di_reg;
	input [3:0] dip_curr, dip_reg;
	input [13:0] addr_curr, addr_reg;
	input integer setup_time;
	input [1:0] wr_mode_curr, wr_mode_reg;
	input [4:0] addr_index;
	input [1:0] addr_parity_index;

	input [13:0] addr_smallest_s;
	input [11:0] addr_parity_smallest_s;
	input integer diow, diopw;
	inout [31:0] out_curr, out_reg;
	inout [3:0] outp_curr, outp_reg;
	inout [2:0] col_msg_flag;
	
	integer t_0, t_0p, t_1, t_2, t_2p;
	
	integer i_t, i_tp, i_t0, i_t1;
	reg [7:0] di_curr_int, di_reg_int, mem_int;
	reg dip_curr_int, dip_reg_int, memp_int;
	reg no_check, no_check_parity;
	reg same_data_check;
	
	
	begin

	    no_check = 0;
	    di_curr_int = 8'b00000000;
	    di_reg_int = 8'b00000000;
	    mem_int = 8'b00000000;
	    dip_curr_int = 0;
	    dip_reg_int = 0;
	    same_data_check = 0;
	    

	    if (same_data_check) begin // disable same input data and meory checks for now

	    if (diopw == 0)
		no_check_parity = 1;
	    else
		no_check_parity = 0;


	    // same input data and memory check -- no use currently
	    if (port == 0) begin

		if (addr_curr == addr_reg) begin	

		    for (i_t = 0; i_t < diow; i_t = i_t + 1) begin

			di_curr_int[i_t] = di_curr[sdata_index + i_t];
			di_reg_int[i_t] = di_reg[sdata_index + i_t];
		    end
		end // if (addr_curr >= addr_reg)
	    
		else if (addr_curr < addr_reg) begin

			for (i_t = 0; i_t < diow; i_t = i_t + 1) begin

			    di_curr_int[i_t] = di_curr[sdata_index + i_t];
			    di_reg_int[i_t] = di_reg[sdata_index_smaller_s + i_t];

			end

		end // if (addr_curr < addr_reg)

		else if (addr_curr > addr_reg) begin

			for (i_t = 0; i_t < diow; i_t = i_t + 1) begin

			    di_curr_int[i_t] = di_curr[sdata_index_smaller_s + i_t];
			    di_reg_int[i_t] = di_reg[sdata_index + i_t];

			end

		end // if (addr_curr > addr_reg)
	    end // if (port == 0)
	    else if (port == 1) begin
		
		if (addr_curr == addr_reg) begin	

		    for (i_t = 0; i_t < diow; i_t = i_t + 1) begin

			di_curr_int[i_t] = di_curr[sdata_index + i_t];
			di_reg_int[i_t] = di_reg[sdata_index + i_t];
		    end

		end // if (addr_curr >= addr_reg)
	    	else if (addr_curr < addr_reg) begin
			
			for (i_t = 0; i_t < diow; i_t = i_t + 1) begin

			    di_curr_int[i_t] = di_curr[sdata_index + i_t];
			    di_reg_int[i_t] = di_reg[sdata_index_smaller_s + i_t];

			end
		    
		end // if (addr_curr < addr_reg)
		else if (addr_curr > addr_reg) begin

			for (i_t = 0; i_t < diow; i_t = i_t + 1) begin

			    di_curr_int[i_t] = di_curr[sdata_index_smaller_s + i_t];
			    di_reg_int[i_t] = di_reg[sdata_index + i_t];

			end

		end // if (addr_curr > addr_reg)
	    end // if (port == 1)

	    if (diopw != 0) begin
		if (port == 0) begin

		    if (addr_curr == addr_reg) begin	

			dip_curr_int = dip_curr[sdata_parity_index];
			dip_reg_int = dip_reg[sdata_parity_index];

		    end // if (addr_curr >= addr_reg)
	    
		else if (addr_curr < addr_reg) begin

		    dip_curr_int = dip_curr[sdata_parity_index];
		    dip_reg_int = dip_reg[sdata_parity_index_smaller_s];

		end // if (addr_curr < addr_reg)
		else if (addr_curr > addr_reg) begin

		    dip_curr_int = dip_curr[sdata_parity_index_smaller_s];
		    dip_reg_int = dip_reg[sdata_parity_index];

		end // if (addr_curr > addr_reg)
	    end // if (port == 0)
	    else if (port == 1) begin

		if (addr_curr == addr_reg) begin	

		    dip_curr_int = dip_curr[sdata_parity_index];
		    dip_reg_int = dip_reg[sdata_parity_index];

		end // if (addr_curr >= addr_reg)
	    
		else if (addr_curr < addr_reg) begin

		    dip_curr_int = dip_curr[sdata_parity_index];
		    dip_reg_int = dip_reg[sdata_parity_index_smaller_s];

		end // if (addr_curr < addr_reg)
		else if (addr_curr > addr_reg) begin
		    
		    dip_curr_int = dip_curr[sdata_parity_index_smaller_s];
		    dip_reg_int = dip_reg[sdata_parity_index];

		end // if (addr_curr > addr_reg)
	    end // if (port == 1)
	    end // if (diopw != 0)


	    for (i_t0 = 0; i_t0 < diow; i_t0 = i_t0 + 1) begin
		mem_int[i_t0] = mem[addr_smallest_s + i_t0];
	    end	    

	    if (diopw != 0) begin
		memp_int = mem[16384 + addr_parity_smallest_s];
	    end


	    if (we_curr == we_reg && we_curr == 1) begin
		    
		if (di_curr_int === di_reg_int && di_curr_int === mem_int) begin

		    no_check = 1;
		    
		end 
		
		if (dip_curr_int === dip_reg_int && dip_curr_int === memp_int) begin

		    no_check_parity = 1;
		
		end
	    end // if (we_curr == we_reg && we_curr == 1)
	    else if (we_curr == 1) begin

		if (di_curr_int === mem_int) begin

		    no_check = 1;

		end 
		
		if (dip_curr_int === memp_int) begin

		    no_check_parity = 1;
		end
	    end // if (we_curr == 1)
	    else if (we_reg == 1) begin

		if (di_reg_int === mem_int) begin

		    no_check = 1;
		    
		end 
		
		if (dip_reg_int === memp_int) begin

		    no_check_parity = 1;

		end
	    end // if (we_reg == 1)

	    end // if (same_data_check)
	    
	    // end - same data and memory checks
	    
	    //disable same data checks
	    no_check = 0;
	    no_check_parity = 0;

	    case ({we_curr, we_reg})

		2'b00 : ;
		2'b01 : begin
		            case (wr_mode_reg)
				2'b00  : begin
				            if (setup_time == 1 | setup_time == 0) begin

						if (!no_check || !no_check_parity) begin
						    col_msg_flag[1:0] = 2'b01;
						end

						if (!no_check) begin
						    for (t_2 = 0; t_2 < diow; t_2 = t_2 + 1)
							out_curr[addr_index + t_2] = 1'bx;
						end
						
						if (!no_check_parity) begin
						    if (diopw != 0)
							for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
							    outp_curr[addr_parity_index + t_2p] = 1'bx;
						end

					    end // if (setup_time == 1 | setup_time == 0)
				         end // case: 2'b00
				2'b01  : begin
				            if (setup_time == 3 || setup_time == 1) begin
						if (!no_check || !no_check_parity) begin
						    col_msg_flag[1:0] = 2'b01;
						end

						if (!no_check) begin
						
						    for (t_2 = 0; t_2 < diow; t_2 = t_2 + 1) begin
							out_curr[addr_index + t_2] = 1'bx;
						    end
						end
						
						if (!no_check_parity) begin
						    if (diopw != 0)
							for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
							    outp_curr[addr_parity_index + t_2p] = 1'bx;

						end
					    end // if (setup_time == 3 | setup_time == 0)
				        end // case: 2'b01
				2'b10 : begin
				            if (setup_time == 1 | setup_time == 0) begin

						if (!no_check || !no_check_parity) begin
						    col_msg_flag[1:0] = 2'b01;
						end

						if (!no_check) begin
						    for (t_1 = 0; t_1 < diow; t_1 = t_1 + 1) begin
							out_curr[addr_index + t_1] = 1'bx;
						    end
						end
						
						if (!no_check_parity) begin
						    if (diopw != 0)
							for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
							    outp_curr[addr_parity_index + t_2p] = 1'bx;
						end
						
					    end
				        end // case: 2'b01
			    endcase // case(wr_mode_reg)
		        end // case: 2'b01
		2'b10 : begin
		            case (wr_mode_curr)
				2'b00  : begin

				            if (setup_time == 1 | setup_time == 0) begin

						if (!no_check || !no_check_parity) begin
						    col_msg_flag[1:0] = 2'b10;
						end
						if (!no_check) begin
						    for (t_2 = 0; t_2 < diow; t_2 = t_2 + 1) begin
							out_reg[addr_index + t_2] = 1'bx;
						    end
						end
						if (!no_check_parity) begin
						    if (diopw != 0)
							for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
							    outp_reg[addr_parity_index + t_2p] = 1'bx;
						end
						
					    end // if (setup_time == 1 | setup_time == 0)
				         end // case: 2'b00
				2'b01 : ;
				2'b10 : begin

				            if (setup_time == 1 | setup_time == 0) begin

						if (!no_check || !no_check_parity) begin
						    col_msg_flag[1:0] = 2'b10;
						end
						if (!no_check) begin
						    for (t_1 = 0; t_1 < diow; t_1 = t_1 + 1) begin
							out_reg[addr_index + t_1] = 1'bx;
						    end
						end

						if (!no_check_parity) begin
						    if (diopw != 0)
							for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
							    outp_reg[addr_parity_index + t_2p] = 1'bx;
						    
						end
					    end
				        end // case: 2'b01
			    endcase // case(wr_mode_reg)
		        end // case: 2'b10

		2'b11 : begin
		            case (wr_mode_reg)
				2'b00  : begin
				            if (setup_time == 1 || setup_time == 0) begin
						
						if (!no_check || !no_check_parity) begin

						    col_msg_flag[2] = 1'b1;
						end
						
						if ((SIM_COLLISION_CHECK == "ALL") || (SIM_COLLISION_CHECK == "GENERATE_X_ONLY")) begin
						    
						    if (!no_check) begin
							for (t_0 = 0; t_0 < diow; t_0 = t_0 + 1) begin
							    mem[addr_smallest_s + t_0] <= 1'bx;
							end
						    end

						    if (!no_check_parity) begin
							if (diopw != 0) begin
							    for (t_0p = 0; t_0p < diopw; t_0p = t_0p + 1) begin
								mem[16384 + addr_parity_smallest_s + t_0p] <= 1'bx;
							    end
							end
						    end
						end // if ((SIM_COLLISION_CHECK == "ALL") && (SIM_COLLISION_CHECK == "GENERATE_X_ONLY"))


						if (wr_mode_curr == 2'b10) begin
						    
						    if (!no_check) begin
							for (t_1 = 0; t_1 < diow; t_1 = t_1 + 1) begin
							    out_reg[addr_index + t_1] = 1'bx;
							end
						    end
						    if (!no_check_parity) begin
							if (diopw != 0)
							    for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
								outp_reg[addr_parity_index + t_2p] = 1'bx;
						    end
						    
						end // if (wr_mode_curr == 2'b10)
						else begin // setup_time = 0 or 1
						    						
						    if (!no_check) begin
							for (t_1 = 0; t_1 < diow; t_1 = t_1 + 1) begin
							    out_reg[addr_index + t_1] = 1'bx;
							
							end
							for (t_2 = 0; t_2 < diow; t_2 = t_2 + 1) begin
							    out_curr[addr_index + t_2] = 1'bx;
							end
							
						    end
						    
						    if (!no_check_parity) begin
							if (diopw != 0) begin
							    for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
								outp_curr[addr_parity_index + t_2p] = 1'bx;
							    
							    for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
								outp_reg[addr_parity_index + t_2p] = 1'bx;
							end
						    end
						    
						    // output = x and mem = x
						end
					    end // if (setup_time == 1 | setup_time == 0)
				         end // case: 2'b00
				2'b01  : begin
				            if (setup_time == 3 || setup_time == 1 || setup_time == 0) begin

						if (!no_check || !no_check_parity) begin

						    col_msg_flag[2] = 1'b1;
						end
						
						if ((SIM_COLLISION_CHECK == "ALL") || (SIM_COLLISION_CHECK == "GENERATE_X_ONLY")) begin
						    
						    if (!no_check) begin
							for (t_0 = 0; t_0 < diow; t_0 = t_0 + 1) begin
							    mem[addr_smallest_s + t_0] <= 1'bx;
							end
						    end

						    if (!no_check_parity) begin
							if (diopw != 0) begin
							    for (t_0p = 0; t_0p < diopw; t_0p = t_0p + 1) begin
								mem[16384 + addr_parity_smallest_s + t_0p] <= 1'bx;
							    end
							end
						    end
						end // if ((SIM_COLLISION_CHECK == "ALL") && (SIM_COLLISION_CHECK == "GENERATE_X_ONLY"))


						
						if (wr_mode_curr == 2'b10) begin
						    if (!no_check) begin
							for (t_1 = 0; t_1 < diow; t_1 = t_1 + 1) begin
							    out_reg[addr_index + t_1] = 1'bx;
							end
						    end
						    if (!no_check_parity) begin
							if (diopw != 0)
							    for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
								outp_reg[addr_parity_index + t_2p] = 1'bx;
							
						    end
						end
						else begin // setup_time = 0 or 1
						    if (!no_check) begin
							for (t_1 = 0; t_1 < diow; t_1 = t_1 + 1) begin
							    out_reg[addr_index + t_1] = 1'bx;
							end
							for (t_2 = 0; t_2 < diow; t_2 = t_2 + 1) begin
							    out_curr[addr_index + t_2] = 1'bx;
							end
						    end
						    if (!no_check_parity) begin
							if (diopw != 0) begin
							    for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
								outp_curr[addr_parity_index + t_2p] = 1'bx;

							    for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
								outp_reg[addr_parity_index + t_2p] = 1'bx;
							end
						    end

						end
					    end // if (setup_time == 3 | setup_time == 0)
				        end // case: 2'b01
				2'b10 : begin
				            if (setup_time == 1 | setup_time == 0) begin

						if (!no_check || !no_check_parity) begin

						    col_msg_flag[2] = 1'b1;
						end
						
						if ((SIM_COLLISION_CHECK == "ALL") || (SIM_COLLISION_CHECK == "GENERATE_X_ONLY")) begin
						    
						    if (!no_check) begin
							for (t_0 = 0; t_0 < diow; t_0 = t_0 + 1) begin
							    mem[addr_smallest_s + t_0] <= 1'bx;
							end
						    end

						    if (!no_check_parity) begin
							if (diopw != 0) begin
							    for (t_0p = 0; t_0p < diopw; t_0p = t_0p + 1) begin
								mem[16384 + addr_parity_smallest_s + t_0p] <= 1'bx;
							    end
							end
						    end
						end // if ((SIM_COLLISION_CHECK == "ALL") && (SIM_COLLISION_CHECK == "GENERATE_X_ONLY"))


						if (wr_mode_curr != 2'b10) begin
						    if (!no_check) begin
						    for (t_1 = 0; t_1 < diow; t_1 = t_1 + 1) begin
							out_curr[addr_index + t_1] = 1'bx; // output b = no change, a = x and mem = x
						    end
						    end
						    if (!no_check_parity) begin
						    if (diopw != 0) begin
							for (t_2p = 0; t_2p < diopw; t_2p = t_2p + 1)
							    outp_curr[addr_parity_index + t_2p] = 1'bx;
						    end
						    end
						    
						    
						end
					    end
				        end // case: 2'b10
			    endcase // case(wr_mode_reg)
		        end // case: 2'b11
	    endcase // case({we_curr, we_reg})
	    
	    end
    endtask // collision_table_task
    

    
    task collision_message_task;

	input port;

	begin
	    
	    if (port == 0) begin

		if (col_msg_flag[2] == 1)

		    $display("Memory Collision Error on RAMB16BWE : %m at simulation time %.3f ns.\nA write was requested to the same address simultaneously at both port A and port B of the RAM. The contents written to the RAM at address location %h (hex) of port A and address location %h (hex) of port B are unknown.", $time/1000.0, address_write_a, address_write_b_reg);

		else if (col_msg_flag[1:0] == 2'b01)
		    
		    $display("Memory Collision Error on RAMB16BWE : %m at simulation time %.3f ns.\nA read was performed on address %h (hex) of port A while a write was requested to the same address on port B. The write will be successful however the read value on port A is unknown until the next CLKA cycle.", $time/1000.0, address_read_a);

		else if (col_msg_flag[1:0] == 2'b10)

		    $display("Memory Collision Error on RAMB16BWE : %m at simulation time %.3f ns.\nA read was performed on address %h (hex) of port B while a write was requested to the same address on port A. The write will be successful however the read value on port B is unknown until the next CLKB cycle.", $time/1000.0, address_read_b_reg);

	    end // if (port == 0)
	    else if (port == 1) begin


		if (col_msg_flag[2] == 1)
		    
		    $display("Memory Collision Error on RAMB16BWE : %m at simulation time %.3f ns.\nA write was requested to the same address simultaneously at both port A and port B of the RAM. The contents written to the RAM at address location %h (hex) of port A and address location %h (hex) of port B are unknown.", $time/1000.0, address_write_a_reg, address_write_b);

		else if (col_msg_flag[1:0] == 2'b01)
		    
		    $display("Memory Collision Error on RAMB16BWE : %m at simulation time %.3f ns.\nA read was performed on address %h (hex) of port B while a write was requested to the same address on port A. The write will be successful however the read value on port B is unknown until the next CLKB cycle.", $time/1000.0, address_read_b);

		else if (col_msg_flag[1:0] == 2'b10)
		    
		    $display("Memory Collision Error on RAMB16BWE : %m at simulation time %.3f ns.\nA read was performed on address %h (hex) of port A while a write was requested to the same address on port B. The write will be successful however the read value on port A is unknown until the next CLKA cycle.", $time/1000.0, address_read_a_reg);


	    end // if (port == 0)
	    
	end
    endtask // collision_message_task


    task output_opposite_port_task;

	input port;
	integer t_i1, t_i1p;
	
	begin

	    if (out_reg !== 32'b0) begin

		if (port == 0) begin
		    
		    if ((dibw <= 8) || (dibw == 16 && dobw > dibw) || wr_mode_b != 2'b00) begin

			dob_out_col = dob_out_buf;

		    end
		    else if ((dibw == 16 && dobw <= dibw) || dibw == 32) begin


			for (t_i1 = 0; t_i1 < dobw; t_i1 = t_i1 + 1)
			    dob_out_col[t_i1] = dob_out_buf[(dob_index * dobw) + t_i1];
		    end

		    dob_out <= dob_out_col ^ out_reg;

		end // if (port == 0)
		else if (port == 1) begin
		    
		    if ((diaw <= 8) || (diaw == 16 && doaw > diaw) || wr_mode_a != 2'b00) begin

			doa_out_col = doa_out_buf;

		    end
		    else if ((diaw == 16 && doaw <= diaw) || diaw == 32) begin

			for (t_i1 = 0; t_i1 < doaw; t_i1 = t_i1 + 1)
			    doa_out_col[t_i1] = doa_out_buf[(doa_index * doaw) + t_i1];
		    end

		    doa_out <= doa_out_col ^ out_reg;

		end // if (port == 1)

	    end // if (out_reg !== 32'b0)

	    if (outp_reg !== 4'b0) begin

		if (port == 0) begin

		    if ((dibw <= 8) || (dibw == 16 && dobw > dibw) || wr_mode_b != 2'b00) begin
		    
			dopb_out_col = dopb_out_buf;

		    end
		    else if ((dibw == 16 && dobw <= dibw) || dibw == 32) begin
			
			if (dopbw_1 != -1) begin

			    for (t_i1p = 0; t_i1p < dopbw; t_i1p = t_i1p + 1)
				dopb_out_col[t_i1p] = dopb_out_buf[(dopb_index * dopbw) + t_i1p];

			end // if (dopbw_1 != -1)
			
		    end

		    dopb_out <= dopb_out_col ^ outp_reg;

		end // if (port == 0)
		else if (port == 1) begin

		    if ((diaw <= 8) || (diaw == 16 && doaw > diaw) || wr_mode_a != 2'b00) begin
		    
			dopa_out_col = dopa_out_buf;

		    end
		    else if ((diaw == 16 && doaw <= diaw) || diaw == 32) begin
			
			if (dopaw_1 != -1) begin

			    for (t_i1p = 0; t_i1p < dopaw; t_i1p = t_i1p + 1)
				dopa_out_col[t_i1p] = dopa_out_buf[(dopa_index * dopaw) + t_i1p];

			end // if (dopaw_1 != -1)
			
		    end

		    dopa_out <= dopa_out_col ^ outp_reg;

		end // if (port == 1)

	    end // if (outp_reg !== 4'b0)
	end

    endtask // output_opposite_port_task


    task collision_call0_task;

	input port;
	
	begin
	    if (SIM_COLLISION_CHECK == "NONE" || SIM_COLLISION_CHECK == "WARNING_ONLY") begin

		if (port == 0) begin
		    doa_out <= doa_out_buf;
		    dopa_out <= dopa_out_buf;
		end
		else if (port == 1) begin
		    dob_out <= dob_out_buf;
		    dopb_out <= dopb_out_buf;
		end
			    
		if (SIM_COLLISION_CHECK == "WARNING_ONLY") begin

		    col_msg_flag = 3'b0;

		    collision_task(port, SETUP_ALL, SETUP_READ_FIRST, out_curr, out_reg, outp_curr, outp_reg, col_msg_flag);

		    if (col_msg_flag != 3'b000)
			collision_message_task(port);

		end
    
	    end
	    else if (SIM_COLLISION_CHECK == "ALL" || SIM_COLLISION_CHECK == "GENERATE_X_ONLY") begin

		out_curr = 32'b0;
		out_reg = 32'b0;
		outp_curr = 4'b0;
		outp_reg = 4'b0;
		col_msg_flag = 3'b0;

		collision_task(port, SETUP_ALL, SETUP_READ_FIRST, out_curr, out_reg, outp_curr, outp_reg, col_msg_flag);
			    
		if (port == 0) begin
		    doa_out_col = doa_out_buf ^ out_curr;
		    dopa_out_col = dopa_out_buf ^ outp_curr;
		    doa_out <= doa_out_col;
		    dopa_out <= dopa_out_col;
		end
		else if (port == 1) begin
		    dob_out_col = dob_out_buf ^ out_curr;
		    dopb_out_col = dopb_out_buf ^ outp_curr;
		    dob_out <= dob_out_col;
		    dopb_out <= dopb_out_col;
		end

		if (col_msg_flag != 3'b000 && ((port === 0 && ssrb_reg_col !== 1) || (port === 1 && ssra_reg_col !== 1)))
		    output_opposite_port_task(port);

		if (col_msg_flag != 3'b000 && SIM_COLLISION_CHECK == "ALL")
		    collision_message_task(port);
			    
	    end // if (SIM_COLLISION_CHECK == "ALL" || SIM_COLLISION_CHECK == "GENERATE_X_ONLY")

	end

    endtask // collision_call_task
    

    task collision_call1_task;

	input port;
	
	begin

	    if (SIM_COLLISION_CHECK == "NONE" || SIM_COLLISION_CHECK == "WARNING_ONLY") begin

		if (port == 0) begin

		    for (i_4 = 0; i_4 < doaw; i_4 = i_4 + 1)
			doa_out[i_4] <= doa_out_buf[(doa_index * doaw) + i_4];
		    
		    if (dopaw_1 != -1)
			for (i_4p = 0; i_4p < dopaw; i_4p = i_4p + 1)
			    dopa_out[i_4p] <= dopa_out_buf[(dopa_index * dopaw) + i_4p];

		end
		else if (port == 1) begin

		    for (i_4 = 0; i_4 < dobw; i_4 = i_4 + 1)
			dob_out[i_4] <= dob_out_buf[(dob_index * dobw) + i_4];

		    if (dopbw_1 != -1)
			for (i_4p = 0; i_4p < dopbw; i_4p = i_4p + 1)
			    dopb_out[i_4p] <= dopb_out_buf[(dopb_index * dopbw) + i_4p];
		end

		if (SIM_COLLISION_CHECK == "WARNING_ONLY") begin

		    col_msg_flag = 3'b0;

		    collision_task(port, SETUP_ALL, SETUP_READ_FIRST, out_curr, out_reg, outp_curr, outp_reg, col_msg_flag);

		    if (col_msg_flag != 3'b000)
			collision_message_task(port);
				
		end
	    end // if (SIM_COLLISION_CHECK == "NONE" || SIM_COLLISION_CHECK == "WARNING_ONLY")
	    else if (SIM_COLLISION_CHECK == "ALL" || SIM_COLLISION_CHECK == "GENERATE_X_ONLY") begin

		out_curr = 32'b0;
		out_reg = 32'b0;
		outp_curr = 4'b0;
		outp_reg = 4'b0;
		col_msg_flag = 3'b0;
		
		collision_task(port, SETUP_ALL, SETUP_READ_FIRST, out_curr, out_reg, outp_curr, outp_reg, col_msg_flag);
		
		if (port == 0) begin				

		    for (i_4 = 0; i_4 < doaw; i_4 = i_4 + 1)
			doa_out_col[i_4] = doa_out_buf[(doa_index * doaw) + i_4];

		    if (dopaw_1 != -1) begin

			for (i_4p = 0; i_4p < dopaw; i_4p = i_4p + 1)
			    dopa_out_col[i_4p] = dopa_out_buf[(dopa_index * dopaw) + i_4p];

		    end // if (dopaw_1 != -1)

		    doa_out <= doa_out_col ^ out_curr;
		    dopa_out <= dopa_out_col ^ outp_curr;

		end
		else if (port == 1) begin

		    for (i_4 = 0; i_4 < dobw; i_4 = i_4 + 1)
			dob_out_col[i_4] = dob_out_buf[(dob_index * dobw) + i_4];

		    if (dopbw_1 != -1) begin

			for (i_4p = 0; i_4p < dopbw; i_4p = i_4p + 1)
			    dopb_out_col[i_4p] = dopb_out_buf[(dopb_index * dopbw) + i_4p];

		    end // if (dopaw_1 != -1)

		    dob_out <= dob_out_col ^ out_curr;
		    dopb_out <= dopb_out_col ^ outp_curr;

		end // if (port == 1)

		if (col_msg_flag != 3'b000 && ((port === 0 && ssrb_reg_col !== 1) || (port === 1 && ssra_reg_col !== 1)))
		    output_opposite_port_task(port);
		
		if (col_msg_flag != 3'b000 && SIM_COLLISION_CHECK == "ALL")
		    collision_message_task(port);

	    end // if (SIM_COLLISION_CHECK == "ALL" || SIM_COLLISION_CHECK == "GENERATE_X_ONLY")
	    
	end
	
    endtask // collision_call_task

    specify

        (CLKA => DOA[0]) = (100, 100);
        (CLKA => DOA[1]) = (100, 100);
        (CLKA => DOA[2]) = (100, 100);
        (CLKA => DOA[3]) = (100, 100);
        (CLKA => DOA[4]) = (100, 100);
        (CLKA => DOA[5]) = (100, 100);
        (CLKA => DOA[6]) = (100, 100);
        (CLKA => DOA[7]) = (100, 100);
        (CLKA => DOA[8]) = (100, 100);
        (CLKA => DOA[9]) = (100, 100);
        (CLKA => DOA[10]) = (100, 100);
        (CLKA => DOA[11]) = (100, 100);
        (CLKA => DOA[12]) = (100, 100);
        (CLKA => DOA[13]) = (100, 100);
        (CLKA => DOA[14]) = (100, 100);
        (CLKA => DOA[15]) = (100, 100);
        (CLKA => DOA[16]) = (100, 100);
        (CLKA => DOA[17]) = (100, 100);
        (CLKA => DOA[18]) = (100, 100);
        (CLKA => DOA[19]) = (100, 100);
        (CLKA => DOA[20]) = (100, 100);
        (CLKA => DOA[21]) = (100, 100);
        (CLKA => DOA[22]) = (100, 100);
        (CLKA => DOA[23]) = (100, 100);
        (CLKA => DOA[24]) = (100, 100);
        (CLKA => DOA[25]) = (100, 100);
        (CLKA => DOA[26]) = (100, 100);
        (CLKA => DOA[27]) = (100, 100);
        (CLKA => DOA[28]) = (100, 100);
        (CLKA => DOA[29]) = (100, 100);
        (CLKA => DOA[30]) = (100, 100);
        (CLKA => DOA[31]) = (100, 100);
        (CLKA => DOPA[0]) = (100, 100);
        (CLKA => DOPA[1]) = (100, 100);
        (CLKA => DOPA[2]) = (100, 100);
        (CLKA => DOPA[3]) = (100, 100);
        (CLKB => DOB[0]) = (100, 100);
        (CLKB => DOB[1]) = (100, 100);
        (CLKB => DOB[2]) = (100, 100);
        (CLKB => DOB[3]) = (100, 100);
        (CLKB => DOB[4]) = (100, 100);
        (CLKB => DOB[5]) = (100, 100);
        (CLKB => DOB[6]) = (100, 100);
        (CLKB => DOB[7]) = (100, 100);
        (CLKB => DOB[8]) = (100, 100);
        (CLKB => DOB[9]) = (100, 100);
        (CLKB => DOB[10]) = (100, 100);
        (CLKB => DOB[11]) = (100, 100);
        (CLKB => DOB[12]) = (100, 100);
        (CLKB => DOB[13]) = (100, 100);
        (CLKB => DOB[14]) = (100, 100);
        (CLKB => DOB[15]) = (100, 100);
        (CLKB => DOB[16]) = (100, 100);
        (CLKB => DOB[17]) = (100, 100);
        (CLKB => DOB[18]) = (100, 100);
        (CLKB => DOB[19]) = (100, 100);
        (CLKB => DOB[20]) = (100, 100);
        (CLKB => DOB[21]) = (100, 100);
        (CLKB => DOB[22]) = (100, 100);
        (CLKB => DOB[23]) = (100, 100);
        (CLKB => DOB[24]) = (100, 100);
        (CLKB => DOB[25]) = (100, 100);
        (CLKB => DOB[26]) = (100, 100);
        (CLKB => DOB[27]) = (100, 100);
        (CLKB => DOB[28]) = (100, 100);
        (CLKB => DOB[29]) = (100, 100);
        (CLKB => DOB[30]) = (100, 100);
        (CLKB => DOB[31]) = (100, 100);
        (CLKB => DOPB[0]) = (100, 100);
        (CLKB => DOPB[1]) = (100, 100);
        (CLKB => DOPB[2]) = (100, 100);
        (CLKB => DOPB[3]) = (100, 100);
	specparam PATHPULSE$ = 0;
    endspecify


endmodule // RAMB16BWE

