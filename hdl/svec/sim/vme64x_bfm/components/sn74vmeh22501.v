`timescale 1ns/1ns 

module sn74vmeh22501 (
    input   oeab1,
            oeby1_n,
            a1,
    output  y1,
    inout   b1,

    input   oeab2,
            oeby2_n,
            a2,
    output  y2,
    inout   b2,

    input   oe_n,
    input   dir,    
            clkab,
            le,
            clkba,
    inout   [1:8] a3,
    inout   [1:8] b3);

assign b1   = oeab1   ? a1      : 1'bz;
assign y1   = oeby1_n ? 1'bz    : b1;

assign b2   = oeab2   ? a2      : 1'bz;
assign y2   = oeby2_n ? 1'bz    : b2;

reg [1:8] b3LFF;
always @(posedge clkab) if (~le) b3LFF <= #1 a3;
always @* if (le) b3LFF = a3;
assign b3   = (~oe_n && dir) ? b3LFF : 8'hz;

reg [1:8] a3LFF;
always @(posedge clkba) if (~le) a3LFF <= #1 b3;
always @* if (le) a3LFF = b3;
assign a3   = (~oe_n && ~dir) ? a3LFF : 8'hz;

endmodule

