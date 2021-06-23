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


// signaux de l'automate de controle
  logic IF,ID,EX,MEM,WB;

// signaux du decodeur
  logic        d_load_enable;
  logic        d_write_enable_d;
  logic        Iv_alu;
  logic        Pc_alu;
  logic [1:0]  Pc_cmd;
  logic [1:0]  Pc_val;
  logic [3:0]  I;
  logic [4:0]  Rs1,Rs2,Rd;
  logic [31:0] Iv;

// signaux des registres
  logic [31:0] S1,S2;
  logic [31:0] regs_in;

// signaux de l'ALU
  logic [31:0] V1,V2;
  logic [31:0] ALU_out;
  logic        CF,ZF;

// signaux du PC
  logic [31:0] Pc_in;

  ALU ALU1(.I(I),
           .EX(EX),
           .clk(clk),
           .op1(V1),
           .op2(V2),
           .res1(ALU_out),
           .carry(CF),
           .z(ZF));

  regs regs1(.clk(clk),
             .WB(WB),
             .Rs1(Rs1),
             .Rs2(Rs2),
             .Rd(Rd),
             .reg_s(regs_in),
             .S1(S1),
             .S2(S2));

  pc pc1(.clk(clk),
         .reset_n(reset_n),
         .IF(IF),
         .pc_cmd(Pc_cmd),
         .pc_v(Pc_in),
         .i_address(i_address));

  decoder decoder1(.clk(clk),
                   .reset_n(reset_n),
                   .ID(ID),
                   .i_data_read(i_data_read),
                   .d_write_enable(d_write_enable_d),
                   .d_load_enable(d_load_enable),
                   .Iv_alu(Iv_alu),
                   .Pc_alu(Pc_alu),
                   .Pc_cmd(Pc_cmd),
                   .Pc_val(Pc_val),
                   .I(I),
                   .Rs1(Rs1),
                   .Rs2(Rs2),
                   .Rd(Rd),
                   .Iv(Iv));

ctrl ctrl1(.clk(clk),
           .reset_n(reset_n),
           .IF(IF),
           .ID(ID),
           .EX(EX),
           .MEM(MEM),
           .WB(WB));

  always @(*)
    begin

// multiplexeurs d'entré à l'ALU
    if(Pc_alu)
      V1 = i_address;
    else
      V1 = S1;

    if(Iv_alu)
      V2 = Iv;
    else
      V2 = S2;

// multiplexeur d'entrée aux registres
  if(d_load_enable)
    regs_in = d_data_read;
  else
    regs_in = ALU_out;

// multiplexeur d'entré du PC
  case(Pc_val)
    0'b00: Pc_in = ALU_out;
    0'b01: Pc_in = Iv;
    0'b10: Pc_in = S2;
    0'b11: Pc_in = S1;
  endcase

// on écrit dans la mémoire uniquement au cycle MEM
  if(MEM)
    d_write_enable = d_write_enable_d;
  else
    d_write_enable = 0;

  end
endmodule // DLX
