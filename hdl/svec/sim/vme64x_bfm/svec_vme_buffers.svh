`include "components/sn74vmeh22501.v"

`include "vme64x_bfm.svh"

module bidir_buf(
    a,
    b,
    dir, /* 0: a->b, 1: b->a */
    oe_n );

   parameter g_width = 1;

   inout [g_width-1:0] a,b;
   input               dir, oe_n;

   assign b = (!dir && !oe_n) ? a : 'bz;
   assign a = (dir && !oe_n) ? b : 'bz;
endmodule // bidir_buf




module svec_vme_buffers (
    output       VME_AS_n_o,
    output       VME_RST_n_o,
    output       VME_WRITE_n_o,
    output [5:0] VME_AM_o,
    output [1:0] VME_DS_n_o,
    output [5:0] VME_GA_o,
    input        VME_BERR_i,
    input        VME_DTACK_n_i,
    input        VME_RETRY_n_i,
    input        VME_RETRY_OE_i,
    inout        VME_LWORD_n_b,
    inout [31:1] VME_ADDR_b,
    inout [31:0] VME_DATA_b,
    output       VME_BBSY_n_o,
    input [6:0]  VME_IRQ_n_i,
    output       VME_IACKIN_n_o,
    input        VME_IACKOUT_n_i,
    output        VME_IACK_n_o,
    input        VME_DTACK_OE_i,
    input        VME_DATA_DIR_i,
    input        VME_DATA_OE_N_i,
    input        VME_ADDR_DIR_i,
    input        VME_ADDR_OE_N_i,

    IVME64X.slave slave
    );

   pullup(slave.as_n);
   pullup(slave.rst_n);
   pullup(slave.irq_n[0]);
   pullup(slave.irq_n[1]);
   pullup(slave.irq_n[2]);
   pullup(slave.irq_n[3]);
   pullup(slave.irq_n[4]);
   pullup(slave.irq_n[5]);
   pullup(slave.irq_n[6]);
   pullup(slave.iack_n);
   pullup(slave.dtack_n);
   pullup(slave.retry_n);
   pullup(slave.ds_n[1]);
   pullup(slave.ds_n[0]);
   pullup(slave.lword_n);
   pullup(slave.berr_n);
   pullup(slave.write_n);
   pulldown(slave.bbsy_n);
   pullup(slave.iackin_n);

   assign VME_RST_n_o = slave.rst_n;

   assign VME_AS_n_o     = slave.as_n;
   assign VME_GA_o     = slave.ga;
   assign VME_WRITE_n_o  = slave.write_n;
   assign VME_AM_o = slave.am;
   assign VME_DS_n_o = slave.ds_n;
   assign VME_BBSY_n_o = slave.bbsy_n;
   assign VME_IACKIN_n_o = slave.iackin_n;
   assign VME_IACK_n_o = slave.iack_n;

   bidir_buf #(1)  b0 (slave.lword_n, VME_LWORD_n_b, VME_ADDR_DIR_i, VME_ADDR_OE_N_i);
   bidir_buf #(31) b1 (slave.addr, VME_ADDR_b, VME_ADDR_DIR_i, VME_ADDR_OE_N_i);
   bidir_buf #(33) b2 (slave.data, VME_DATA_b, VME_DATA_DIR_i, VME_DATA_OE_N_i);

   pulldown(VME_BERR_i);
   pulldown(VME_ADDR_DIR_i);
   pulldown(VME_ADDR_OE_N_i);
   pulldown(VME_DATA_DIR_i);
   pulldown(VME_DATA_OE_N_i);


   assign slave.dtack_n = VME_DTACK_n_i;
   assign slave.berr_n = ~VME_BERR_i;
   assign slave.retry_n = VME_RETRY_n_i;
endmodule


`define DECLARE_VME_BUFFERS(iface) \
    wire VME_AS_n;\
    wire VME_RST_n;\
    wire VME_WRITE_n;\
    wire [5:0] VME_AM;\
    wire [1:0] VME_DS_n;\
    wire VME_BERR;\
    wire VME_DTACK_n;\
    wire VME_RETRY_n;\
    wire VME_RETRY_OE;\
    wire VME_LWORD_n;\
    wire [31:1]VME_ADDR;\
    wire [31:0]VME_DATA;\
    wire VME_BBSY_n;\
    wire [6:0]VME_IRQ_n;\
    wire VME_IACKIN_n,VME_IACK_n;\
    wire VME_IACKOUT_n;\
    wire VME_DTACK_OE;\
    wire VME_DATA_DIR;\
    wire VME_DATA_OE_N;\
    wire VME_ADDR_DIR;\
    wire VME_ADDR_OE_N;\
    svec_vme_buffers U_VME_Bufs ( \
    .VME_AS_n_o(VME_AS_n),\
    .VME_RST_n_o(VME_RST_n),\
    .VME_WRITE_n_o(VME_WRITE_n),\
    .VME_AM_o(VME_AM),\
    .VME_DS_n_o(VME_DS_n),\
    .VME_BERR_i(VME_BERR),\
    .VME_DTACK_n_i(VME_DTACK_n),\
    .VME_RETRY_n_i(VME_RETRY_n),\
    .VME_RETRY_OE_i(VME_RETRY_OE),\
    .VME_LWORD_n_b(VME_LWORD_n),\
    .VME_ADDR_b(VME_ADDR),\
    .VME_DATA_b(VME_DATA),\
    .VME_IRQ_n_i(VME_IRQ_n),\
    .VME_IACK_n_o(VME_IACK_n),\
    .VME_IACKIN_n_o(VME_IACKIN_n),\
    .VME_IACKOUT_n_i(VME_IACKOUT_n),\
    .VME_DTACK_OE_i(VME_DTACK_OE),\
    .VME_DATA_DIR_i(VME_DATA_DIR),\
    .VME_DATA_OE_N_i(VME_DATA_OE_N),\
    .VME_ADDR_DIR_i(VME_ADDR_DIR),\
    .VME_ADDR_OE_N_i(VME_ADDR_OE_N),\
    .slave(iface)\
    );

function automatic bit[5:0] _gen_ga(int slot);
     bit[4:0] slot_id = slot;
     return {^slot_id, ~slot_id};
endfunction // _gen_ga



`define WIRE_VME_PINS(slot_id) \
    .vme_as_n_i(VME_AS_n),\
    .vme_sysreset_n_i(VME_RST_n),\
    .vme_write_n_i(VME_WRITE_n),\
    .vme_am_i(VME_AM),\
    .vme_ds_n_i(VME_DS_n),\
    .vme_ga_i(_gen_ga(slot_id)),\
    .vme_berr_o(VME_BERR),\
    .vme_dtack_n_o(VME_DTACK_n),\
    .vme_retry_n_o(VME_RETRY_n),\
    .vme_retry_oe_o(VME_RETRY_OE),\
    .vme_lword_n_b(VME_LWORD_n),\
    .vme_addr_b(VME_ADDR),\
    .vme_data_b(VME_DATA),\
    .vme_irq_n_o(VME_IRQ_n),\
    .vme_iack_n_i(VME_IACK_n),\
    .vme_iackin_n_i(VME_IACKIN_n),\
    .vme_iackout_n_o(VME_IACKOUT_n),\
    .vme_dtack_oe_o(VME_DTACK_OE),\
    .vme_data_dir_o(VME_DATA_DIR),\
    .vme_data_oe_n_o(VME_DATA_OE_N),\
    .vme_addr_dir_o(VME_ADDR_DIR),\
    .vme_addr_oe_n_o(VME_ADDR_OE_N)
