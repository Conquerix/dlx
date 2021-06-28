module WB(input  logic [31:0] d_data_read,
          input  logic [31:0] ALU_out_WB,
          input  logic        d_load_enable_WB,
          output logic [31:0] reg_in_WB);

    always @(*) begin
        if(d_load_enable_WB)
            reg_in_WB = d_data_read;
        else
            reg_in_WB = ALU_out_WB;
    end


endmodule