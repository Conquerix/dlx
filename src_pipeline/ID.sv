module ID(input logic         clk,
          input logic         reset_n,
          input logic [31:0]  i_data_read,

/////////////////////////////////////// signaux qui remontent le temps
          input logic         pc_cmd_EX,
          /// ce signal indique qu'un saut 
          /// est pris à partir du bloc EX
          ///
          /// il faut donc nullifier l'instruction en cours de decodage


          input logic [4:0]   Rd_MEM,
          input logic [31:0]  ALU_out_MEM,

          output logic        Pc_cmd_id,
          output logic [31:0] pc_in_ID,

/////////////////////////////////////// registres
          output logic [4:0]  Rs1_ID,
          output logic [4:0]  Rs2_ID,
          input  logic [31:0] S1_ID,
          input  logic [31:0] S2_ID,

/////////////////////////////////////// signaux qui redescendent le temps
          input  logic [31:0] PC_ID,
          output logic        nullify,
          output logic        d_write_enable_EX,
          output logic        d_load_enable_EX,
          output logic        Iv_alu_EX,
          output logic        Pc_alu_EX,
          output logic [4:0]  I_EX,
          output logic [4:0]  Rd_EX,
          output logic [4:0]  Rs1_EX,
          output logic [4:0]  Rs2_EX,
          output logic [31:0] Iv_EX,
          output logic [31:0] S1_EX,
          output logic [31:0] S2_EX);

    logic        Pc_cmd_ex_ID;
    logic        Pc_add;

    logic        d_write_enable_ID;
    logic        d_load_enable_ID;
    logic        Iv_alu_ID;
    logic        Pc_alu_ID;
    logic [4:0]  I_ID;
    logic [4:0]  Rd_ID;
    logic [31:0] Iv_ID;

    logic [31:0] S1_EX0,S2_EX0;/// S1,S2 avant correction avec la phase MEM


    decoder decoder1(.clk(clk),
                .reset_n(reset_n),
                .i_data_read(i_data_read),
                .d_write_enable(d_write_enable_ID),
                .d_load_enable(d_load_enable_ID),
                .Iv_alu(Iv_alu_ID),
                .Pc_alu(Pc_alu_ID),
                .Pc_cmd_ID(Pc_cmd_id),
                .Pc_cmd_EX(Pc_cmd_ex_ID),
                .Pc_add(Pc_add),
                .I(I_ID),
                .Rs1(Rs1_ID),
                .Rs2(Rs2_ID),
                .Rd(Rd_ID),
                .Iv(Iv_ID));


    /// bascule D sur tous les signaux...
    always @(posedge clk) begin
        if(!reset_n || pc_cmd_EX) begin
            d_write_enable_EX   <= 0;
            d_load_enable_EX    <= 0;
            Iv_alu_EX           <= 0;
            Pc_alu_EX           <= 0;
            Rd_EX               <= 0;
            I_EX                <= 0;
            Iv_EX               <= 0;
            nullify             <= 0;
            Rs1_EX              <= 0;
            Rs2_EX              <= 0;
            
        end
        else begin
            d_write_enable_EX   <= d_write_enable_ID;
            d_load_enable_EX    <= d_load_enable_ID;
            Iv_alu_EX           <= Iv_alu_ID;
            Pc_alu_EX           <= Pc_alu_ID;
            Rd_EX               <= Rd_ID;
            I_EX                <= I_ID;
            Iv_EX               <= Iv_ID;
            nullify             <= Pc_cmd_ex_ID;
            Rs1_EX              <= Rs1_ID;
            Rs2_EX              <= Rs2_ID;
        end
    end

    always@(*) begin
        /// additionneur + multiplexeur
        if(Pc_add)
            pc_in_ID = PC_ID + Iv_ID;
        else
            pc_in_ID = S1_ID;


          //  if(Rd_MEM == Rs1_EX)
          //      S1_EX = ALU_out_MEM;
          //  else
          //      S1_EX = S1_EX0;
          //
          //  if(Rd_MEM == Rs2_EX)
          //      S2_EX = ALU_out_MEM;
          //  else
          //      S2_EX = S2_EX0;
    end

endmodule