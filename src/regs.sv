module regs(input  logic clk,
            // phase d'ecriture
            input  logic WB,

      // Numéros des registres
            input  logic [4:0]  Rs1,
            input  logic [4:0]  Rs2,
            input  logic [4:0]  Rd,

            input  logic [31:0] reg_s,
            output logic [31:0] S1,
            output logic [31:0] S2);

      logic [31:0] regs[32];

      always@(*)
        regs[0] = '0;

      always@(posedge clk)
          begin
            S1 <= regs[Rs1];
            S2 <= regs[Rs2];
            if(WB && Rd != '0)
              regs[Rd] <= reg_s;

          end
endmodule
