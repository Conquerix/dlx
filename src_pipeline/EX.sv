module EX(
        input  logic        clk,
/////////////////////////////////////// signaux qui remontent le temps

        // dependance de controle
        output logic        pc_cmd_EX,
        output logic [31:0] pc_in_EX,
        

/////////////////////////////////////// signaux qui redescendent le temps
        input  logic        Pc_cmd_ex_EX,
        input  logic        d_write_enable_EX,
        input  logic        d_load_enable_EX,
        input  logic        Iv_alu_EX,
        input  logic        Pc_alu_EX,
        input  logic [4:0]  I_EX,
        input  logic [4:0]  Rd_EX,
        input  logic [31:0] Iv_EX,
        input  logic [31:0] S1_EX,
        input  logic [31:0] S2_EX,

        input  logic [31:0] PC_EX,

        output logic [31:0] ALU_out_MEM,
        output logic        d_write_enable_MEM,
        output logic        d_load_enable_MEM,
        output logic [4:0]  Rd_MEM);

    logic [31:0] ALU_op1, ALU_op2, ALU_res;
    logic ALU_ZF;

    ALU ALU1(
        .I(I_EX),
        .op1(ALU_op1),
        .op2(ALU_op2),
        .res(ALU_res),
        .ZF(ALU_ZF));

    // multiplexeurs d'entré à l'ALU
    always @(*) begin
        if(Pc_alu_EX)
        ALU_op1 = PC_EX;
        else
        ALU_op1 = S1_EX;

        if(Iv_alu_EX)
        ALU_op2 = Iv_EX;
        else
        ALU_op2 = S2_EX;
    end


    // bascules D
    always @(posedge clk) begin
        ALU_out_MEM        <= ALU_res;
        d_write_enable_MEM <= d_write_enable_EX;
        d_load_enable_MEM  <= d_load_enable_EX;
        Rd_MEM             <= Rd_EX;
    end

    // additionneur
    always@(*) begin
        if(Pc_cmd_ex_EX & ALU_ZF)
            pc_in_EX = PC_EX + Iv_EX;

        pc_cmd_EX = Pc_cmd_ex_EX;
    end

endmodule