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
  logic [31:0] pc_in_ID;
  logic pc_cmd_ID;
  logic reset_n2;

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
  logic [4:0] Rs1_EX;
  logic [4:0] Rs2_EX;
  logic [31:0] PC_EX;
  logic        pc_cmd_EX;
  logic        Pc_add_EX;
  logic [31:0] pc_in_EX;

// signaux MEM

  logic [31:0] ALU_out_MEM;
  logic        d_write_enable_MEM;
  logic        d_load_enable_MEM;
  logic [4:0]  Rd_MEM;
  logic [4:0]  Rs2_MEM;
  logic [4:0]  Rs3_MEM;
  logic [31:0] S3_MEM;

  logic [4:0]  Rd_MEM_backward;
  logic [31:0] ALU_out_MEM_backward;

// signaux WB
  logic [31:0] reg_in_WB;

// signaux WB
  logic        d_load_enable_WB;
  logic [4:0]  Rd_WB;
  logic [31:0] ALU_out_WB;

    regs regs1(.clk(clk),
               .Rs1(Rs1_EX),
               .Rs2(Rs2_EX),
               .Rs3(Rs3_MEM),
               .S1(S1_EX),
               .S2(S2_EX),
               .S3(S3_MEM),
               .Rd(Rd_WB),
               .reg_in(reg_in_WB));

    IF IF1(.clk(clk), .reset_n(reset_n),
           .pc_cmd_ID(pc_cmd_ID),
           .pc_cmd_EX(pc_cmd_EX),
           .pc_in_ID(pc_in_ID),
           .pc_in_EX(pc_in_EX),
           .i_address(i_address));

    ID ID1(.clk(clk),
           .reset_n(reset_n),
           .reset_n2(reset_n2), // il faut attendre d'avoir fetch l'instruction après avoir reset : sinon on l'execute 2 fois
           .i_data_read(i_data_read),

           // l'instruction doit etre nullifiée si on se rend compte qu'il faut jump
           // lors de l'EX
           .nullify(pc_cmd_EX),

           .Rd_MEM(Rd_MEM),
           .ALU_out_MEM(ALU_out_MEM),
           .Pc_cmd_id(pc_cmd_ID),
           .pc_in_ID(pc_in_ID),
           .Rs1_ID(Rs1_ID),
           .Rs2_ID(Rs2_ID),
           .Pc_add_EX(Pc_add_EX),
           .PC_ID(PC_ID),
           .Pc_cmd_ex_EX(Pc_cmd_ex_EX),
           .d_write_enable_EX(d_write_enable_EX),
           .d_load_enable_EX(d_load_enable_EX),
           .Iv_alu_EX(Iv_alu_EX),
           .Pc_alu_EX(Pc_alu_EX),
           .I_EX(I_EX),
           .Rd_EX(Rd_EX),
           .Rs1_EX(Rs1_EX),
           .Rs2_EX(Rs2_EX),
           .Iv_EX(Iv_EX));

    EX EX1(.clk(clk),
           .reset_n(reset_n),
           .pc_cmd_EX(pc_cmd_EX),
           .pc_in_EX(pc_in_EX),
           .Pc_cmd_ex_EX(Pc_cmd_ex_EX),
           .d_write_enable_EX(d_write_enable_EX),
           .d_load_enable_EX(d_load_enable_EX),
           .Iv_alu_EX(Iv_alu_EX),
           .Pc_alu_EX(Pc_alu_EX),
           .Pc_add_EX(Pc_add_EX),
           .I_EX(I_EX),
           .Rd_EX(Rd_EX),
           .Iv_EX(Iv_EX),
           .S1_EX(S1_EX),
           .S2_EX(S2_EX),
           .PC_EX(PC_EX),
           .Rs2_MEM(Rs2_MEM),
           .ALU_out_MEM(ALU_out_MEM),
           .ALU_out_MEM_backward(ALU_out_MEM_backward),
           .Rd_MEM_backward(Rd_MEM_backward),
           .Rs1_EX(Rs1_EX),
           .Rs2_EX(Rs2_EX),
           .d_write_enable_MEM(d_write_enable_MEM),
           .d_load_enable_MEM(d_load_enable_MEM),
           .Rd_MEM(Rd_MEM));

    MEM MEM1(.clk(clk),
             .reset_n(reset_n),
             .d_data_valid(d_data_valid),
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
             .Rs2_MEM(Rs2_MEM),
             .Rs3_MEM(Rs3_MEM),
             .S3_MEM(S3_MEM),
             .ALU_out_WB(ALU_out_WB));

    WB WB1(.d_data_read(d_data_read),
           .ALU_out_WB(ALU_out_WB),
           .d_load_enable_WB(d_load_enable_WB),
           .reg_in_WB(reg_in_WB));

  always@(posedge clk) begin
    // bascules PC
    if(!reset_n) begin
      PC_EX <= 0;
      PC_ID <= 0;
      reset_n2 <= 0;
    end
    else begin
      reset_n2 <= reset_n;
      PC_ID <= i_address;
      PC_EX <= PC_ID;
    end
  end

endmodule // DLX
