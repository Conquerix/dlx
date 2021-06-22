module decoder(input logic        clk,
               input logic        reset_n,
               input logic        ID,
               input logic [31:0] i_data_read,

               output logic d_write_enable,
               output logic d_load_enable,
               output logic Iv_alu,
               output logic Pc_alu,

               output logic [0:1] Pc_cmd,

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
                  0x20 :
                    begin

                    end
                  0x24 :
                    begin

                    end
                  0x25 :
                    begin

                    end
                  0x28 :
                    begin

                    end
                  0x2c :
                    begin

                    end
                  0x04 :
                    begin

                    end
                  0x2a :
                    begin

                    end
                  0x29 :
                    begin

                    end
                  0x07 :
                    begin

                    end
                  0x06 :
                    begin

                    end
                  0x22 :
                    begin

                    end
                  0x26 :
                    begin

                    end

              endcase
              Rs1 <= I[25:21];
              Rs2 <= I[20:16];
              Rd  <= I[15:11];
              Pc_cmd <= '0;
              Iv_alu <= '0;
              Pc_alu <= '0;
            end
