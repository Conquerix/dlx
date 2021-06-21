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


endmodule // DLX
