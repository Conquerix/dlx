module EX(
        input  logic        clk,
        input  logic        reset_n, 
/////////////////////////////////////// signaux qui remontent le temps

        // dependance de controle
        output logic        pc_cmd_EX,
        output logic [31:0] pc_in_EX,

        // dépendance de données
        input  logic [31:0] ALU_out_MEM_backward,
        input  logic [4:0]  Rd_MEM_backward,
        

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
        input  logic [4:0]  Rs1_EX,
        input  logic [4:0]  Rs2_EX,
        input  logic        Pc_add_EX,

        input  logic [31:0] PC_EX,

        output logic [31:0] ALU_out_MEM,
        output logic        d_write_enable_MEM,
        output logic        d_load_enable_MEM,
        output logic [4:0]  Rd_MEM,
        output logic [4:0]  Rs2_MEM
        );

    logic [31:0] ALU_op1, ALU_op2, ALU_res;

    // valeur des registres Rs1,Rs2
    // ou bien, s'ils ne sont pas encore enregistrés,
    // la valeur calculée 
    logic [31:0] reg1, reg2;
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
            ALU_op1 = reg1;

        if(Iv_alu_EX)
            ALU_op2 = Iv_EX;
        else
            ALU_op2 = reg2;
    end


    // bascules D
    always @(posedge clk) begin
        if(!reset_n) begin
            ALU_out_MEM        <= '0;
            d_write_enable_MEM <= '0;
            d_load_enable_MEM  <= '0;
            Rs2_MEM            <= '0;
            Rd_MEM             <= '0;
        end
        else
             begin
            ALU_out_MEM        <= ALU_res;
            d_write_enable_MEM <= d_write_enable_EX;
            d_load_enable_MEM  <= d_load_enable_EX;
            Rs2_MEM            <= Rs2_EX;
            Rd_MEM             <= Rd_EX;
        end 
    end

    always@(*) begin

            // multiplexeurs en entré de l'ALU
    // pour prendre en compte les valeurssim:/DE1_SoC_tb/SoC1/dlx/ALU_out_WB

        if(Rs1_EX == Rd_MEM_backward && Rs1_EX != 0)
            reg1 = ALU_out_MEM_backward;
        else 
            reg1 = S1_EX;

        if(Rs2_EX == Rd_MEM_backward && Rs2_EX != 0)
            reg2 = ALU_out_MEM_backward;
        else 
            reg2 = S2_EX;

        // la nouvelle valeur du pc ssi l'instruction est un jmp ET le resultat de l'ALU est non nul
        if(Pc_add_EX)
            pc_in_EX = PC_EX + Iv_EX;
        else
            pc_in_EX = reg1;
        // JR et companie

        /// signal  de modification de la valeur du PC
            pc_cmd_EX = Pc_cmd_ex_EX & !(ALU_ZF & Pc_add_EX);
    end
endmodule