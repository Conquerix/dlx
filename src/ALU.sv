module ALU(
    input  logic[3:0] I,
    input  logic EX,

    input  logic[31:0] op1,
    input  logic[31:0] op2,
    output logic[31:0] res1
);

wire[15:0] out;
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
**/

always@(*) begin
        //1
        out[1]  <= op1+op2;
        out[2]  <= op1-op2;
        out[3]  <= op1&op2;
        out[4]  <= op1|op2;
        out[5]  <= op1^op2;
        out[6]  <= op1 << (op2 % '8);
        out[7]  <= op1 >> (op2 % '8);
        out[8]  <= op1 == '0   ? op2 : '0;
        out[9]  <= op1 != '0   ? op2 : '0;
        out[10] <= op1 == op2  ? '1  : '0;
        out[11] <=(op1 <= op2) ? '1  : '0;
        out[12] <= op1 <  op2  ? '1  : '0;
        out[13] <= op1 != op2  ? '1  : '0;
end

// multiplexeur des resultats
always@(*)
    res1 <= out[I];

endmodule