module pc(input  logic        clk,
          input  logic        reset_n,
          input  logic        IF,
          input  logic [0:1]  pc_cmd,
          input  logic [31:0] pc_v,
          output logic [31:0] i_address);

      logic [31:0] pc;

      always@(*)
        if(!reset_n)
          pc = '0;
        else
          if(IF)
            begin
              if(pc_cmd[0] == 1)
                if(pc_cmd[1] == 1)
                  pc = pc_v;
                else
                  pc = pc + pc_v;
              else
                pc = pc + 4;
            end

      always@(posedge clk)
        if(IF)
          i_address <= pc;
endmodule
