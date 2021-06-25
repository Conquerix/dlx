module regs(input  logic clk,

      // Numéros des registres
            input  logic [4:0]  Rs1,
            input  logic [4:0]  Rs2,
            input  logic [4:0]  Rd,

            input  logic [31:0] reg_s,
            output logic [31:0] S1,
            output logic [31:0] S2);

      logic [31:0] regs[31:0];
      logic [31:0] P1,P2;

      always@(*)
      begin
        if(Rs1 != '0)
          P1 = regs[Rs1];
        else
          P1 = 0;
        if(Rs2 != '0)
          P2 = regs[Rs2];
        else
          P2 = 0;


        if(Rd == Rs1)
          S1 = reg_s;
        else
          S1 = P1;
        if(Rd == Rs2)
          S2 = reg_s;
        else
          S2 = P2;
      end


      always@(posedge clk)
          regs[Rd] <= reg_s;
endmodule
