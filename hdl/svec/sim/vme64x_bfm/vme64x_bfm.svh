`ifndef __VME64X_BFM_SVH
 `define __VME64X_BFM_SVH 1

`timescale 1ns/1ps

`include "simdrv_defs.svh"

`define assert_wait(name, condition, timeout) \
begin\
   time t=$time;\
   while(!(condition)) begin\
      #1ns;\
      if($time - t > timeout) begin\
         $display("Wait timeout : ", `"name`"); \
        //   $stop;\
           break;\
             end\
      end\
end





interface IVME64X ( input sys_rst_n_i );

   wire as_n;
   wire rst_n;
   wire write_n;
   wire [5:0] am;
   wire [1:0] ds_n;
   wire [5:0] ga;
   wire berr_n, dtack_n;
   wire retry_n;
   wire lword_n;
   wire [31:1] addr;
   wire [31:0] data;
   wire bbsy_n;
   wire [6:0]  irq_n;
   wire iackin_n, iackout_n, iack_n;

   logic q_as_n = 1'bz;
   logic q_rst_n = 1'bz;
   logic q_write_n = 1'bz;
   logic [5:0] q_am = 6'bz;
   logic [1:0] q_ds_n = 2'bz;
   logic [5:0] q_ga = 6'bz;
   logic q_berr_n = 1'bz, q_dtack_n = 1'bz;
   logic q_retry_n = 1'bz;
   logic q_lword_n = 1'bz;
   logic [31:1] q_addr = 31'bz;
   logic [31:0] q_data = 32'bz;
   logic q_bbsy_n = 1'bz;
   logic [6:0] q_irq_n = 7'bz;
   logic q_iackin_n = 1'bz, q_iackout_n = 1'bz, q_iack_n = 1'bz;


   /* SystemVerilog does not allow pullups inside interfaces or on logic type */
   
   assign as_n = q_as_n;
   assign rst_n = q_rst_n;
   assign write_n = q_write_n;
   assign am = q_am;
   assign ds_n = q_ds_n;
   assign ga = q_ga;
   assign berr_n = q_berr_n;
   assign dtack_n = q_dtack_n;
   assign retry_n = q_retry_n;
   assign lword_n = q_lword_n;
   assign addr = q_addr;
   assign data = q_data;
   assign bbsy_n = q_bbsy_n;
   assign irq_n = q_irq_n;
   assign iackin_n = q_iackin_n;
   assign iackout_n = q_iackout_n;
   assign iack_n = q_iack_n;
   
 //  VME Master
   modport tb
     (
      output as_n, 
      output rst_n, 
      output write_n, 
      output am, 
      output ds_n, 
      output ga, 
      output bbsy_n,
      output iackin_n,
      output iack_n,
      input  berr_n, 
      input  irq_n, 
      input  iackout_n,
      inout  addr,
      inout  data, 
      inout  lword_n, 
      inout  retry_n, 
      inout  dtack_n,

      input q_as_n, 
      input q_rst_n, 
      input q_write_n, 
      input q_am, 
      input q_ds_n, 
      input q_ga, 
      input q_bbsy_n,
      input q_iackin_n,
      input q_iack_n,
      input  q_berr_n, 
      input  q_irq_n, 
      input  q_iackout_n,
      input  q_addr,
      input  q_data, 
      input  q_lword_n, 
      input  q_retry_n, 
      input  q_dtack_n
      );

    modport master
     (
      output as_n, 
      output rst_n, 
      output write_n, 
      output am, 
      output ds_n, 
      output ga, 
      output bbsy_n,
      output iackin_n,
      output iack_n,
      input  berr_n, 
      input  irq_n, 
      input  iackout_n,
      inout  addr,
      inout  data, 
      inout  lword_n, 
      inout  retry_n, 
      inout  dtack_n);
   
   
   //  VME Slave
   modport slave
     (
      input  as_n, 
      input  rst_n, 
      input  write_n, 
      input  am, 
      input  ds_n, 
      input  ga, 
      input  bbsy_n, 
      input  iackin_n,
      input iack_n,
      output berr_n, 
      output irq_n, 
      output iackout_n,
      inout  addr, 
      inout  data, 
      inout  lword_n, 
      inout  retry_n, 
      inout  dtack_n
      );

   initial forever begin
      @(posedge sys_rst_n_i);
      #100ns;
      q_rst_n = 0;
      #100ns;
      q_rst_n = 1;
   end
   
   

endinterface // IVME64x



const uint64_t CSR_BAR             = 'h7FFFF;
const uint64_t CSR_BIT_SET_REG     = 'h7FFFB;
const uint64_t CSR_BIT_CLR_REG     = 'h7FFF7;
const uint64_t CSR_CRAM_OWNER      = 'h7FFF3;
const uint64_t CSR_USR_BIT_SET_REG = 'h7FFEF;
const uint64_t CSR_USR_BIT_CLR_REG = 'h7FFEB;

typedef enum { DONT_CARE = 'h100, 
               A16       = 'h200, 
               A24       = 'h300, 
               A32       = 'h400, 
               A64       = 'h500 
               } vme_addr_size_t;

typedef enum { 
               SINGLE = 'h10, CR_CSR='h20, MBLT='h30, BLT='h40, LCK='h50, TwoeVME='h60, TwoeSST='h70 } vme_xfer_type_t;

typedef enum { D08Byte0='h1, D08Byte1='h2, D08Byte2='h3, D08Byte3='h4, D16Byte01='h5, D16Byte23='h6, D32='h7 } vme_data_type_t ;
   
class CBusAccessor_VME64x extends CBusAccessor;

   const bit [3:0] dt_map [vme_data_type_t] =
                   '{
                     D08Byte0  : 4'b0101,	
                     D08Byte1  : 4'b1001,
                     D08Byte2  : 4'b0111,	
                     D08Byte3  : 4'b1011,
                     D16Byte01 : 4'b0001,
                     D16Byte23 : 4'b0011,
                     D32       : 4'b0000};
   
   protected bit [7:0] m_ba;
   protected bit [4:0] m_ga;
   virtual             IVME64X.tb vme;

   function new(virtual IVME64X.tb _vme);
      vme = _vme;
      m_ga = 6'b010111;
      vme.q_ga = m_ga;
      m_ba = 8'b10000000;
   endfunction // new

   protected task set_address(uint64_t addr_in, vme_addr_size_t asize, vme_xfer_type_t xtype);
      bit[63:0] a = addr_in;
      bit [31:0] a_out;
      
     const bit [5:0] am_map [int] = 
                      '{
                        A32 | CR_CSR : 6'b101111,
                        A24 | CR_CSR : 6'b101111,
                        A16 | SINGLE: 6'b101001,
                        A16 | LCK : 6'b101100,
                        A24 | SINGLE: 6'b111001,
                        A24 | BLT : 6'b111011,
                        A24 | MBLT : 6'b111000,
                        A24 | LCK : 6'b110010,
                        A32 | SINGLE: 6'b001001,
                        A32 | BLT : 6'b001011,
                        A32 | MBLT : 6'b001000,
                        A32 | LCK : 6'b000101,
                        A64 | SINGLE: 6'b000001,
                        A64 | BLT : 6'b000011,
                        A64 | MBLT : 6'b000000,
                        A64 | LCK : 6'b001000,
                        A32 | TwoeVME : 6'b100000,
                        A64 | TwoeVME : 6'b100000,
                        A32 | TwoeSST : 6'b100000,
                        A64 | TwoeSST : 6'b100000};

      vme.q_am = am_map[asize|xtype];

      
      if(xtype == CR_CSR)
        a_out = {8'h0, ~m_ga[4:0], a[18:0]};
      else case(asize)
        A16: 
          a_out = {16'h0, m_ba[7:3], a[10:2], 2'b00};
        A24: 
          a_out = {8'h0, m_ba[7:3], a[18:2], 2'b00};
        A32:
          a_out = {m_ba[7:3], a[26:2], 2'b00};
      endcase // case (xtype)

      vme.q_addr[31:2] = a_out[31:2];
      
   endtask // set_address

   
   protected task release_bus();
      vme.q_as_n = 1'bz;
      vme.q_write_n = 1'bz;
      vme.q_ds_n = 2'bzz;
      vme.q_lword_n = 1'bz;
      vme.q_addr = 0;
      vme.q_data = 32'bz;
   endtask // release_bus
   

/* Simple generic VME read/write: single, BLT and CSR xfers */
   protected task rw_generic(bit write, uint64_t _addr, ref uint64_t _data[], input vme_addr_size_t asize, input vme_xfer_type_t xtype, vme_data_type_t dtype);
      bit[3:0] dt;
      int      i;
      
      `assert_wait(tmo_rws_bus_free, vme.dtack_n && vme.berr_n, 10us)
      release_bus();
      #10ns;

      set_address(_addr, asize, xtype);
      dt = dt_map[dtype];

      vme.q_lword_n = dt[0];
      vme.q_addr[1] = dt[1];
      vme.q_write_n = !write;
      
      #35ns;
      
      vme.q_as_n = 0;
      #10ns;

//      $display("RWG %x\n", _data.size());
      
      
      for(i=0;i<_data.size();i++)
        begin
           
           if(write)
             vme.q_data = (dtype == D08Byte0 || dtype == D08Byte2) ? (_data[i] << 8) : (_data[i]);

           #35ns;
           vme.q_ds_n = dt[3:2]; 

           `assert_wait(tmo_rws_bus_idle, !vme.dtack_n || !vme.berr_n, 4us)
           if(!vme.berr_n)
             $error("[rw_simple_generic]: VME bus error.");

           if(!write)
             _data[i] = (dtype == D08Byte0 || dtype == D08Byte2) ? (vme.data >> 8) : (vme.data);
           #10ns;
           
           end // for (i=0;i<_data.size();i++)
      
      release_bus();
   endtask // rw_generic

   protected task extract_xtype(int s, ref vme_xfer_type_t xtype, vme_addr_size_t asize, vme_data_type_t dtype);
      xtype = vme_xfer_type_t'( s & 'h0f0);
      asize = vme_addr_size_t'( s & 'hf00);
      dtype = vme_data_type_t'( s & 'h00f);
   endtask // extract_xtype

   protected int m_default_modifiers = A32 | SINGLE | D32;
   
   
   task set_default_modifiers(int mods);
      m_default_modifiers = mods;
   endtask // set_default_modifiers
   
   
   task writem(uint64_t addr[], uint64_t data[], input int size = m_default_modifiers, ref int result);
      int    i;
      vme_addr_size_t asize;
      vme_data_type_t dtype;
      vme_xfer_type_t xtype;
      
      extract_xtype(size, xtype, asize, dtype);
      if(xtype == SINGLE || xtype == CR_CSR)
        for(i=0;i<addr.size();i++)
          begin
             uint64_t tmp[];
             tmp = new[1];
             tmp[0] = data[i];
             rw_generic(1, addr[i], tmp, asize, xtype, dtype);
          end
      else if (xtype == BLT)
           rw_generic(1, addr[0], data, asize, xtype, dtype);
      
   endtask // writem
   
   task readm(uint64_t addr[], ref uint64_t data[], input int size = m_default_modifiers, ref int result);
      int    i;

      vme_addr_size_t asize;
      vme_data_type_t dtype;
      vme_xfer_type_t xtype;
      
      extract_xtype(size, xtype, asize, dtype);
      if(xtype == SINGLE || xtype == CR_CSR)
        for(i=0;i<addr.size();i++)
          begin
             uint64_t tmp[];
             tmp=new[1];
             
             rw_generic(0, addr[i], tmp, asize, xtype, dtype);
             data[i] = tmp[0];
          end

   endtask // readm

   task read(uint64_t addr, ref uint64_t data, input int size = m_default_modifiers, ref int result = _null);
      int res;
      uint64_t aa[1], da[];

      da= new[1];

      
      aa[0]  = addr;
      readm(aa, da, size, res);
      data  = da[0];
   endtask

   task write(uint64_t addr, uint64_t data, input int size = m_default_modifiers, ref int result = _null);
      uint64_t aa[], da[];
      aa=new[1];
      da=new[1];

//      $display("VMEWrite s %x", size);
      
      
      aa[0]  = addr;
      da[0]  = data;

      
      writem(aa, da, size, result);
   endtask

   
endclass // CBusAccessor_VME64x

  


   
`endif //  `ifndef __VME64X_BFM_SVH
