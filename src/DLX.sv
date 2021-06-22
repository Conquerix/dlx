module DLX
  (
   input logic 	       clk,
   input logic 	       reset_n,

   // RAM contenant les données
   output logic [31:0] d_address,
   input logic [31:0]  d_data_read,
   output logic [31:0] d_data_write,
   output logic        d_write_enable,
   input logic 	       d_data_valid,

   // ROM contenant les instructions
   output logic [31:0] i_address,
   input logic [31:0]  i_data_read,
   input logic 	       i_data_valid
   );


// signaux de l'automate de controle
  logic IF,ID,EX,MEM,WB;

// signaux du decodeur
  logic d_load_enable;
  logic Iv_alu;
  logic Pc_alu;
  logic [1:1] Pc_cmd;
  logic [3:0] I;
  logic [4:0] Rs1,Rs2Rd;
  logic[31:0] Iv;


endmodule // DLX
