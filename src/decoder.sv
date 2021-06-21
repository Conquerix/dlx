module decoder(input logic        clk,
               input logic        reset_n,
               input logic        ID,
               input logic [31:0] i_data_read,

               output logic d_write_enable,
               output logic d_load_enable,
               output logic Iv_alu,
               output logic Pc_alu,

               output logic [1:0] Pc_cmd,

               output logic [3:0] I,

               output logic [4:0] Rs1,
               output logic [4:0] Rs2,
               output logic [4:0] Rd,

               output logic [31;0] Iv);

        always@(posedge clk)
          if(!reset_n)
            begin
              d_write_enable <= '0;
              d_load_enable  <= '0;
              Iv_alu         <= '0;
              Pc_alu         <= '0;
              Pc_cmd         <= '0;
              I              <= '0;
              Rs1            <= '0;
              Rs2            <= '0;
              Rd             <= '0;
              Iv             <= '0;
            end
          else
            
