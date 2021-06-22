module decoder(input logic        clk,
               input logic        reset_n,
               input logic        ID,
               input logic [31:0] i_data_read,

               output logic d_write_enable,
               output logic d_load_enable,
               output logic Iv_alu,
               output logic Pc_alu,

               output logic [0:1] Pc_cmd,
               output logic [0:1] Pc_val,


               output logic [3:0] I,

               output logic [4:0] Rs1,
               output logic [4:0] Rs2,
               output logic [4:0] Rd,

               output logic [31:0] Iv);

        always@(posedge clk)
          if(!reset_n)
            begin
              d_write_enable <= '0;
              d_load_enable  <= '0;
              Iv_alu         <= '0;
              Pc_alu         <= '0;
              Pc_cmd         <= '0;
              Pc_val         <= '0;
              I              <= '0;
              Rs1            <= '0;
              Rs2            <= '0;
              Rd             <= '0;
              Iv             <= '0;
            end
          else
            if(i_data_read[31:26] == '0)
              begin
                case(i_data_read[5:0])
                  0x20    : I <= 4'd1;
                  0x24    : I <= 4'd3;
                  0x25    : I <= 4'd4;
                  0x28    : I <= 4'd10;
                  0x2c    : I <= 4'd11;
                  0x04    : I <= 4'd6;
                  0x2a    : I <= 4'd12;
                  0x29    : I <= 4'd13;
                  0x07    : I <= 4'd14;
                  0x06    : I <= 4'd7;
                  0x22    : I <= 4'd2;
                  0x26    : I <= 4'd5;
                  default : I <= 4'd0;
                endcase
                Rs1 <= i_data_read[25:21];
                Rs2 <= i_data_read[20:16];
                Rd  <= i_data_read[15:11];
                Pc_cmd <= '0;
                Iv_alu <= '0;
                Pc_alu <= '0;
                Pc_val <= '0;
                d_write_enable <= '0;
                d_load_enable <= '0;
              end
            else
              if(i_data_read[31:27] == 5'b00001)
                begin
                  Pc_cmd <= 2'b10;
                  Pc_alu <= 1;
                  Iv_alu <= 0;
                  d_write_enable <= 0;
                  d_load_enable  <= 0;
                  Rs1 <= 0;
                  Rs2 <= 0;
                  Pc_val <= 2'b01;
                  Iv <= {6'i_data_read[25],i_data_read[25:0]};
                  if(i_data_read[26] == 1)
                    begin
                      I <= 4d'15;
                      Rd <= 5d'31;
                    end
                  else
                    begin
                      I <= 4d'0;
                      Rd <= 5d'0;
                    end
                end
              else
                begin
                  Rs1 <= i_data_read[25:21];
                  Rs2 <= i_data_read[20:16];
                  Rd  <= i_data_read[20:16];
                  d_load_enable <= 0;
                  d_write_enable <= 0;
                  Pc_cmd <= 0;
                  Pc_val <= 0;
                  Iv_alu <= 1;
                  Iv <= 0;
                  case(i_data_read[31:26])
                    0x08 :
                      begin
                        I <= 4'd1;
                          Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x0c :
                      begin
                        I <= 4'd3;
                        Iv <= i_data_read[15:0];
                      end
                    0x04 :
                      begin
                        Pc_cmd <= 2'b10;
                        I <= 4'd8;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x05 :
                      begin
                        Pc_cmd <= 2'b10;
                        I <= 4'd9;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                        Rd <= 0;
                      end
                    0x13 :
                      begin
                        I <= 4'd15;
                        Rd <= 5'd31;
                        Pc_cmd <= 2'b11;
                        Pc_val <= 2'b11;
                        Iv <= i_data_read[15:0];
                      end
                    0x12 :
                      begin
                        I <= 4'd0;
                        Pc_cmd <= 2'b11;
                        Pc_val <= 2'b11;
                        Rd <= 0;
                        Iv <= i_data_read[15:0];
                      end
                    0x0f :
                      begin
                        I <= 4'd0;
                        Iv <= i_data_read[15:0];
                      end
                    0x23 :
                      begin
                        I <= 4'd1;
                        d_load_enable <= 1;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x0d :
                      begin
                        I <= 4'd4;
                        Iv <= i_data_read[15:0];
                      end
                    0x18 :
                      begin
                        I <= 4'd10;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x1c :
                      begin
                        I <= 4'd11;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x14 :
                      begin
                        I <= 4'd6;
                        Iv <= i_data_read[15:0];
                      end
                    0x1a :
                      begin
                        I <= 4'd12;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x19 :
                      begin
                        I <= 4'd13;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x17 :
                      begin
                        I <= 4'd14;
                        Iv <= i_data_read[15:0];
                      end
                    0x16 :
                      begin
                        I <= 4'd7;
                        Iv <= i_data_read[15:0];
                      end
                    0x0a :
                      begin
                        I <= 4'd2;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                      end
                    0x2b :
                      begin
                        I <= 4'd1;
                        Iv <= {16'i_data_read[15],i_data_read[15:0]};
                        d_write_enable <= 1;
                        Rd <= 5'd0;
                      end
                    0x0e :
                      begin
                        I <= 4'd5;
                        Iv <= i_data_read[15:0];
                      end
                end
endmodule
