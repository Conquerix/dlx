module ALU_tb();

    logic[3:0] I;
    logic EX;
    logic clk;

    logic[31:0] E1, E2, S;
    logic carry,z;


    ALU ALU1(.I(I),
             .EX(EX),
             .clk(clk),
             .op1(E1),
             .op2(E2),
             .res1(E1),
             .carry(carry),
             .z(z));
    

endmodule
