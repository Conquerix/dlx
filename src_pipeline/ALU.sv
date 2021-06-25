module ALU(
    input  logic        clk,
    input  logic [4:0]  I,
    input  logic [31:0] op1,
    input  logic [31:0] op2,

    output logic [31:0] res1);

logic [31:0] out_comb;
/**
*   1.  ADD: r <= op1 + op2
*   2.  SUB: r <= op1 - op2
*   3.  AND: r <= op1 & op2
*   4.  OR:  r <= op1 | op2
*   5.  XOR: r <= op1 ^ op2
*   6.  SLL: r <= op1 << (op2 % 8)
*   7.  SRL: r <= op1 >> (op2 % 8)
*   8.  ???: r <= op1 == 0   ? op2 : 0RSN
*   9.  ???: r <= op1 != 0   ? op2 : 0
*   10. SEQ: r <= op1 == op2 ? 1 : 0
*   11. SLE: r <= op1 <= op2 ? 1 : 0
*   12. SLT: r <= op1 <  op2 ? 1 : 0
*   13. SNE: r <= op1 != op2 ? 1 : 0
*   14. SRA: r <= op1 >>> (op2 % 8)
**/

always@(*) begin
    case(I)
            0:  out_comb               =  op2 << 16;
            1:  out_comb               =  op1+op2;
            2:  out_comb               =  op1-op2;
            3:  out_comb               =  op1&op2;
            4:  out_comb               =  op1|op2;
            5:  out_comb               =  op1^op2;
            6:  out_comb               =  op1 << op2[2:0];
            7:  out_comb               =  op1 >> op2[2:0];
            8:  out_comb               =  op1 == 32'b0  ? op2    : 32'b0;
            9:  out_comb               =  op1 != 32'b0  ? op2    : 32'b0;
            10: out_comb               =  op1 == op2    ? 32'b1  : 32'b0;
            11: out_comb               = (op1 <= op2)   ? 32'b1  : 32'b0;
            12: out_comb               =  op1 <  op2    ? 32'b1  : 32'b0;
            13: out_comb               =  op1 != op2    ? 32'b1  : 32'b0;
            14: out_comb               =  op1 >>> op2[2:0];
            15: out_comb               =  op1 + 4;
            16: out_comb               =  op1 == 32'b0  ? op2    : 32'b100;
            17: out_comb               =  op1 != 32'b0  ? op2    : 32'b100;

    endcase
end

always@(posedge clk)
    begin
        res1  <= out_comb;
    end
endmodule
