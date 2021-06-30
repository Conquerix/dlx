module ALU(
    input  logic [4:0]  I,
    input  logic [31:0] op1,
    input  logic [31:0] op2,

    output logic [31:0] res,
    output logic        ZF);
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
    res = 0;
    case(I)
         0: res =  op2 << 16;
         1: res =  op1+op2;
         2: res =  op1-op2;
         3: res =  op1&op2;
         4: res =  op1|op2;
         5: res =  op1^op2;
         6: res =  op1 << op2[2:0];
         7: res =  op1 >> op2[2:0];
         8: res =  op1 == 32'b0  ? op2    : 32'b0;
         9: res =  op1 != 32'b0  ? op2    : 32'b0;
        10: res =  op1 == op2    ? 32'b1  : 32'b0;
        11: res = (op1 <= op2)   ? 32'b1  : 32'b0;
        12: res =  op1 <  op2    ? 32'b1  : 32'b0;
        13: res =  op1 != op2    ? 32'b1  : 32'b0;
        14: res =  op1 >>> op2[2:0];
        15: res =  op1 + 4;
        16: res =  op1 == 32'b0  ? op2    : 32'b100;
        17: res =  op1 != 32'b0  ? op2    : 32'b100;
    endcase
    
    ZF = (res == 0);
    
    if(I == 8)
        ZF = (op1 != 0);
    else if(I == 9)
        ZF = (op1 == 0);
end
endmodule
