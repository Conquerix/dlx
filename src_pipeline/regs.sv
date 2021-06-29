module regs(input  logic clk,

      // Numéros des registres
            input  logic [4:0]  Rs1,
            input  logic [4:0]  Rs2,
            input  logic [4:0]  Rs3,
            input  logic [4:0]  Rd,

            input  logic [31:0] reg_in,
            output logic [31:0] S1,
            output logic [31:0] S2,
            output logic [31:0] S3);

      logic [31:0] regs[31:0];

      always@(*)
      begin
        if(Rs1 == '0)
          S1 = 0;
        else if(Rd == Rs1)
          S1 = reg_in;
        else
          S1 = regs[Rs1];


        if(Rs2 == '0)
          S2 = 0;
        else if(Rd == Rs2)
          S2 = reg_in;
        else
          S2 = regs[Rs2];


        if(Rs3 == '0)
          S3 = 0;
        else if(Rd == Rs3)
          S3 = reg_in;
        else
          S3 = regs[Rs3];
      end


      always@(posedge clk)
          regs[Rd] = reg_in;
endmodule
