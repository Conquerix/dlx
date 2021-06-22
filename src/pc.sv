module pc(input  logic        clk,
          input  logic        reset_n,
          input  logic        IF,
          input  logic [1:0]  pc_cmd,
          input  logic [31:0] pc_v,
          output logic [31:0] i_address);

      logic [31:0] pc;

      always@(posedge clk)
        if(!reset_n)
          pc <= '0;
        else
          if(IF)
            begin
              if(pc_cmd[1] == 1)
                if(pc_cmd[0] == 1)
                  pc <= pc_v;
                else
                  pc <= pc + pc_v;
              else
                pc <= pc + 4;
            end

      always@(*)
          i_address = pc;
endmodule
