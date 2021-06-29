module ID(input logic         clk,
          input logic         reset_n,
          input logic         reset_n2,
          input logic [31:0]  i_data_read,

/////////////////////////////////////// signaux qui remontent le temps

          /// ce signal indique qu'un saut
          /// est pris à partir du bloc EX
          ///
          /// il faut donc nullifier l'instruction en cours de decodage
          input logic         nullify,


          input logic [4:0]   Rd_MEM,
          input logic [31:0]  ALU_out_MEM,

          output logic        Pc_cmd_id,
          output logic [31:0] pc_in_ID,

/////////////////////////////////////// registres
          output logic [4:0]  Rs1_ID,
          output logic [4:0]  Rs2_ID,

/////////////////////////////////////// signaux qui redescendent le temps
          input  logic [31:0] PC_ID,
          output logic        Pc_cmd_ex_EX,
          output logic        d_write_enable_EX,
          output logic        d_load_enable_EX,
          output logic        Iv_alu_EX,
          output logic        Pc_alu_EX,
          output logic [4:0]  I_EX,
          output logic [4:0]  Rd_EX,
          output logic [4:0]  Rs1_EX,
          output logic [4:0]  Rs2_EX,
          output logic [31:0] Iv_EX,
          output logic        Pc_add_EX);

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

    logic [4:0] register_store;
    logic [4:0] register_store_d;
    logic load_word_wait_enable;
    logic load_word_wait_enable_d;
    logic jmp;
    logic [31:0] i_data_read_dec;


    always@(*)
      begin
        jmp = 0;
        if(load_word_wait_enable_d)
          begin
            if(i_data_read[31:26] == '0)
              jmp = (i_data_read[25:21] != '0 && i_data_read[25:21] == register_store_d) || (i_data_read[20:16] != '0 && i_data_read[20:16] == register_store_d);
            else if(i_data_read[31:27] != 5'b00001)
              jmp = (i_data_read[25:21] != '0 && i_data_read[25:21] == register_store_d);
          end
      end

    always @(*)
    register_store = Rd_ID;

    always@(*)
      if(jmp)
        i_data_read_dec = 32'h08000000;
      else
        i_data_read_dec = i_data_read;

    decoder decoder1(.clk(clk),
                .reset_n(reset_n & reset_n2),
                .i_data_read(i_data_read_dec),
                .d_write_enable(d_write_enable_ID),
                .d_load_enable(d_load_enable_ID),
                .Iv_alu(Iv_alu_ID),
                .Pc_alu(Pc_alu_ID),
                .Pc_cmd_ID(Pc_cmd_id),
                .Pc_cmd_EX(Pc_cmd_ex_ID),
                .Pc_add(Pc_add),
                .load_word_wait_enable(load_word_wait_enable),
                .I(I_ID),
                .Rs1(Rs1_ID),
                .Rs2(Rs2_ID),
                .Rd(Rd_ID),
                .Iv(Iv_ID));

    /// bascule D sur tous les signaux...
    always @(posedge clk) begin
        if(!reset_n || !reset_n2 || nullify) begin
            d_write_enable_EX   <= 0;
            d_load_enable_EX    <= 0;
            Iv_alu_EX           <= 0;
            Pc_alu_EX           <= 0;
            Rd_EX               <= 0;
            I_EX                <= 0;
            Iv_EX               <= 0;
            Pc_cmd_ex_EX        <= 0;
            Rs1_EX              <= 0;
            Rs2_EX              <= 0;
            Pc_add_EX           <= 0;
        end
        else begin
            d_write_enable_EX   <= d_write_enable_ID;
            d_load_enable_EX    <= d_load_enable_ID;
            Iv_alu_EX           <= Iv_alu_ID;
            Pc_alu_EX           <= Pc_alu_ID;
            Rd_EX               <= Rd_ID;
            I_EX                <= I_ID;
            Iv_EX               <= Iv_ID;
            Pc_cmd_ex_EX        <= Pc_cmd_ex_ID;
            Rs1_EX              <= Rs1_ID;
            Rs2_EX              <= Rs2_ID;
            Pc_add_EX           <= Pc_add;
        end
    end

    always@(*) begin
        // nouvelle valeur de PC ssi l'instruction est un saut inconditionnel
        pc_in_ID = PC_ID + Iv_ID;
    end

    always@(posedge clk)
      begin
        load_word_wait_enable_d <= load_word_wait_enable;
        if(!reset_n || !load_word_wait_enable)
          register_store_d <= 0;
        else
          register_store_d <= register_store;
      end
endmodule
