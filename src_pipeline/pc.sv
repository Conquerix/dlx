module pc(input  logic        clk,
          input  logic        reset_n,
          input  logic        pc_set,
          input  logic [31:0] pc_in,
          output logic [31:0] Pc_out);

    // registre interne
      logic [31:0] pc_reg;

      always@(posedge clk) begin
        if(!reset_n)
          pc_reg = 0;
        else 
        begin
          if(pc_set)
            pc_reg = pc_in + 4;
          else
            pc_reg = Pc_out + 4;
        end
      end

endmodule
