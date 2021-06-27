module DLX
  (
   input logic 	       clk,
   input logic 	       reset_n,

   // RAM contenant les données
   input  logic 	     d_data_valid,
   input  logic [31:0] d_data_read,
   output logic [31:0] d_address,
   output logic [31:0] d_data_write,
   output logic        d_write_enable,

   // ROM contenant les instructions
   input  logic 	     i_data_valid,
   input  logic [31:0] i_data_read,
   output logic [31:0] i_address
   );

// signaux des registres

// signaux ID
  logic [31:0] PC_ID;
  logic [4:0]  Rs1_ID;
  logic [4:0]  Rs2_ID;
  logic [31:0] S1_ID;
  logic [31:0] S2_ID;

// signaux EX
  logic        Pc_cmd_ex_EX;
  logic        d_write_enable_EX;
  logic        d_load_enable_EX;
  logic        Iv_alu_EX;
  logic        Pc_alu_EX;
  logic [4:0]  I_EX;
  logic [4:0]  Rd_EX;
  logic [31:0] Iv_EX;
  logic [31:0] S1_EX;
  logic [31:0] S2_EX;
  logic [31:0] PC_EX;
  logic        pc_cmd_EX;
  logic [31:0] pc_in_EX;

// signaux MEM

  logic [31:0] ALU_out_MEM;
  logic        d_write_enable_MEM;
  logic        d_load_enable_MEM;
  logic [4:0]  Rd_MEM;
  logic [4:0]  Rs3_MEM;
  logic [31:0] S3_MEM;

  logic [4:0]  Rd_MEM_backward;
  logic [31:0] ALU_out_MEM_backward;
  
// signaux WB
  logic [31:0] reg_in_WB;

// signaux WB
  logic        d_write_enable_WB;
  logic        d_load_enable_WB;
  logic [4:0]  Rd_WB;
  logic [4:0]  Rs3_WB;
  logic [31:0] S3_WB;

    regs regs1(.clk(clk),
               .Rs1(Rs1_ID),
               .Rs2(Rs2_ID),
               .Rs3(Rs3_WB),
               .S1(S1_ID),
               .S2(S2_ID),
               .S3(S3_MEM),
               .Rd(Rd_WB),
               .reg_in(reg_in_WB));

    IF IF1(.clk(clk), .reset_n(reset_n));

    MEM MEM1(.clk(clk),
             .reset_n(reset_n),
             .d_data_valid(d_data_valid),
             .d_data_read(d_data_read),
             .d_address(d_address),
             .d_data_write(d_data_write),
             .d_write_enable(d_write_enable),
             .ALU_out_MEM(ALU_out_MEM),
             .ALU_out_MEM_backward(ALU_out_MEM_backward),
             .Rd_MEM_backward(Rd_MEM_backward),
             .d_load_enable_MEM(d_load_enable_MEM),
             .d_write_enable_MEM(d_write_enable_MEM),
             .Rd_MEM(Rd_MEM),            
             .d_load_enable_WB(d_load_enable_WB),
             .Rd_WB(Rd_WB),
             .Rs3_MEM(Rs3_MEM),
             .S3_MEM(S3_MEM));


endmodule // DLX
