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
    always @(posedge clk) begin
        
        I <= I + 1;
    end

    always begin
        #5ns
        clk <= !clk;
    end
    initial begin
        clk <= 0;
        E1 <= 11;
        E2 <= 2;
        I <= 1;
        
        EX <= 1;
        
    end

endmodule
