module decoder(input logic        clk,
               input logic        reset_n,
               input logic [31:0] i_data_read,

               output logic d_write_enable,
               output logic d_load_enable,
               output logic Iv_alu,
               output logic Pc_alu,

               output logic Pc_cmd_ID,
               output logic Pc_cmd_EX,
               output logic Pc_add,


               output logic [4:0] I,

               output logic [4:0] Rs1,
               output logic [4:0] Rs2,
               output logic [4:0] Rd,

               output logic [31:0] Iv);

        always@(*) begin
              d_write_enable = '0;
              d_load_enable  = '0;
              Iv_alu         = '0;
              Pc_alu         = '0;
              Pc_cmd_ID      = '0;
              Pc_cmd_EX      = '0;
              Pc_add         = '0;
              I              = '0;
              Rs1            = '0;
              Rs2            = '0;
              Rd             = '0;
              Iv             = '0;
            if(!reset_n) begin
              // garder les valeurs par defaut
            end
            else if(i_data_read[31:26] == '0)
              begin
                case(i_data_read[5:0])
                  'h20    : I = 5'd1;
                  'h24    : I = 5'd3;
                  'h25    : I = 5'd4;
                  'h28    : I = 5'd10;
                  'h2c    : I = 5'd11;
                  'h04    : I = 5'd6;
                  'h2a    : I = 5'd12;
                  'h29    : I = 5'd13;
                  'h07    : I = 5'd14;
                  'h06    : I = 5'd7;
                  'h22    : I = 5'd2;
                  'h26    : I = 5'd5;
                  default : I = 5'd0;
                endcase
                Rs1            = i_data_read[25:21];
                Rs2            = i_data_read[20:16];
                Rd             = i_data_read[15:11];
              end
            else
              if(i_data_read[31:27] == 5'b00001)
                begin
                  Pc_cmd_ID = 1;
                  Pc_alu         = 1;
                  Pc_add         = 1;
                  Iv             = {{6{i_data_read[25]}},i_data_read[25:0]};
                  if(i_data_read[26] == 1)
                    begin
                      I  = 5'd15;
                      Rd = 5'd31;
                    end
                  else
                    begin
                      I  = 5'd0;
                      Rd = 5'd0;
                    end
                end
              else
                begin
                  Rs1            = i_data_read[25:21];
                  Rs2            = i_data_read[20:16];
                  Rd             = i_data_read[20:16];
                  Iv_alu         = 1;
                  case(i_data_read[31:26])
                    'h08 :
                      begin
                        I  = 5'd1;
                        Iv = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h0c :
                      begin
                        I  = 5'd3;
                        Iv = {16'b0, i_data_read[15:0]};
                      end
                    'h04 :
                      begin
                        Pc_cmd_EX = 1;
                        I      = 5'd16;
                        Iv     = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h05 :
                      begin
                        Pc_cmd_EX = 1;
                        I      = 5'd17;
                        Iv     = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h13 :
                      begin
                        I      = 5'd15;
                        Rd     = 5'd31;
                        Pc_cmd_ID = 1;
                        Iv     = {16'b0, i_data_read[15:0]};
                      end
                    'h12 :
                      begin
                        I      = 5'd0;
                        Pc_cmd_ID = 1;
                        Iv     = {16'b0, i_data_read[15:0]};
                      end
                    'h0f :
                      begin
                        I  = 5'd0;
                        Iv = {16'b0, i_data_read[15:0]};
                      end
                    'h23 :
                      begin
                        I             = 5'd1;
                        d_load_enable = 1;
                        Iv            = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h0d :
                      begin
                        I  = 5'd4;
                        Iv = {16'b0, i_data_read[15:0]};
                      end
                    'h18 :
                      begin
                        I  = 5'd10;
                        Iv = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h1c :
                      begin
                        I  = 5'd11;
                        Iv = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h14 :
                      begin
                        I  = 5'd6;
                        Iv = {16'b0, i_data_read[15:0]};
                      end
                    'h1a :
                      begin
                        I  = 5'd12;
                        Iv = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h19 :
                      begin
                        I  = 5'd13;
                        Iv = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h17 :
                      begin
                        I  = 5'd14;
                        Iv = {16'b0, i_data_read[15:0]};
                      end
                    'h16 :
                      begin
                        I  = 5'd7;
                        Iv = {16'b0, i_data_read[15:0]};
                      end
                    'h0a :
                      begin
                        I  = 5'd2;
                        Iv = {{16{i_data_read[15]}},i_data_read[15:0]};
                      end
                    'h2b :
                      begin
                        I              = 5'd1;
                        Iv             = {{16{i_data_read[15]}},i_data_read[15:0]};
                        d_write_enable = 1;
                        Rd             = 5'd0;
                      end
                    'h0e :
                      begin
                        I  = 5'd5;
                        Iv = {16'b0, i_data_read[15:0]};
                      end
                  endcase
                end
        end
endmodule
