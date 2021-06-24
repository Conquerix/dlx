module decoder(input logic        clk,
               input logic        reset_n,
               input logic        ID,
               input logic [31:0] i_data_read,

               output logic d_write_enable,
               output logic d_load_enable,
               output logic Iv_alu,
               output logic Pc_alu,

               output logic [1:0] Pc_cmd,
               output logic [1:0] Pc_val,


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
<<<<<<< HEAD
            if(i_data_read[31:26] == '0)
              begin
                case(i_data_read[5:0])
                  'h20    : I <= 4'd1;
                  'h24    : I <= 4'd3;
                  'h25    : I <= 4'd4;
                  'h28    : I <= 4'd10;
                  'h2c    : I <= 4'd11;
                  'h04    : I <= 4'd6;
                  'h2a    : I <= 4'd12;
                  'h29    : I <= 4'd13;
                  'h07    : I <= 4'd14;
                  'h06    : I <= 4'd7;
                  'h22    : I <= 4'd2;
                  'h26    : I <= 4'd5;
                  default : I <= 4'd0;
                endcase
                Rs1            <= i_data_read[25:21];
                Rs2            <= i_data_read[20:16];
                Rd             <= i_data_read[15:11];
                Pc_cmd         <= '0;
                Iv_alu         <= '0;
                Pc_alu         <= '0;
                Pc_val         <= '0;
                d_write_enable <= '0;
                d_load_enable  <= '0;
              end
            else
              if(i_data_read[31:27] == 5'b00001)
                begin
                  Pc_cmd         <= 2'b10;
                  Pc_alu         <= 1;
                  Iv_alu         <= 0;
                  d_write_enable <= 0;
                  d_load_enable  <= 0;
                  Rs1            <= 0;
                  Rs2            <= 0;
                  Pc_val         <= 2'b01;
                  Iv             <= {6{i_data_read[25]},i_data_read[25:0]};
                  if(i_data_read[26] == 1)
                    begin
                      I  <= 4'd15;
                      Rd <= 5'd31;
                    end
                  else
                    begin
                      I  <= 4'd0;
                      Rd <= 5'd0;
                    end
                end
              else
=======
            if(ID)
              if(i_data_read[31:26] == '0)
>>>>>>> 1e252add7aa17fbf7e4b88dca1ddad28f5484516
                begin
                  case(i_data_read[5:0])
                    'h20    : I <= 4'd1;
                    'h24    : I <= 4'd3;
                    'h25    : I <= 4'd4;
                    'h28    : I <= 4'd10;
                    'h2c    : I <= 4'd11;
                    'h04    : I <= 4'd6;
                    'h2a    : I <= 4'd12;
                    'h29    : I <= 4'd13;
                    'h07    : I <= 4'd14;
                    'h06    : I <= 4'd7;
                    'h22    : I <= 4'd2;
                    'h26    : I <= 4'd5;
                    default : I <= 4'd0;
                  endcase
                  Rs1            <= i_data_read[25:21];
                  Rs2            <= i_data_read[20:16];
<<<<<<< HEAD
                  Rd             <= i_data_read[20:16];
                  d_load_enable  <= 0;
                  d_write_enable <= 0;
                  Pc_cmd         <= 0;
                  Pc_val         <= 0;
                  Iv_alu         <= 1;
                  Iv             <= 0;
                  case(i_data_read[31:26])
                    'h08 :
                      begin
                        I  <= 4'd1;
                        Iv <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h0c :
                      begin
                        I  <= 4'd3;
                        Iv <= {16'b0, i_data_read[15:0]};
                      end
                    'h04 :
                      begin
                        Pc_cmd <= 2'b10;
                        I      <= 4'd8;
                        Iv     <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h05 :
                      begin
                        Pc_cmd <= 2'b10;
                        I      <= 4'd9;
                        Iv     <= {16{i_data_read[15]},i_data_read[15:0]};
                        Rd     <= 0;
                      end
                    'h13 :
                      begin
                        I      <= 4'd15;
                        Rd     <= 5'd31;
                        Pc_cmd <= 2'b11;
                        Pc_val <= 2'b11;
                        Iv     <= {16'b0, i_data_read[15:0]};
                      end
                    'h12 :
                      begin
                        I      <= 4'd0;
                        Pc_cmd <= 2'b11;
                        Pc_val <= 2'b11;
                        Rd     <= 0;
                        Iv     <= {16'b0, i_data_read[15:0]};
                      end
                    'h0f :
                      begin
                        I  <= 4'd0;
                        Iv <= {16'b0, i_data_read[15:0]};
                      end
                    'h23 :
                      begin
                        I             <= 4'd1;
                        d_load_enable <= 1;
                        Iv            <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h0d :
                      begin
                        I  <= 4'd4;
                        Iv <= {16'b0, i_data_read[15:0]};
                      end
                    'h18 :
                      begin
                        I  <= 4'd10;
                        Iv <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h1c :
                      begin
                        I  <= 4'd11;
                        Iv <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h14 :
                      begin
                        I  <= 4'd6;
                        Iv <= {16'b0, i_data_read[15:0]};
                      end
                    'h1a :
                      begin
                        I  <= 4'd12;
                        Iv <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h19 :
                      begin
                        I  <= 4'd13;
                        Iv <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h17 :
                      begin
                        I  <= 4'd14;
                        Iv <= {16'b0, i_data_read[15:0]};
                      end
                    'h16 :
                      begin
                        I  <= 4'd7;
                        Iv <= {16'b0, i_data_read[15:0]};
                      end
                    'h0a :
                      begin
                        I  <= 4'd2;
                        Iv <= {16{i_data_read[15]},i_data_read[15:0]};
                      end
                    'h2b :
                      begin
                        I              <= 4'd1;
                        Iv             <= {16{i_data_read[15]},i_data_read[15:0]};
                        d_write_enable <= 1;
                        Rd             <= 5'd0;
                      end
                    'h0e :
                      begin
                        I  <= 4'd5;
                        Iv <= {16'b0, i_data_read[15:0]};
                      end
                  endcase
                end
=======
                  Rd             <= i_data_read[15:11];
                  Pc_cmd         <= '0;
                  Iv_alu         <= '0;
                  Pc_alu         <= '0;
                  Pc_val         <= '0;
                  d_write_enable <= '0;
                  d_load_enable  <= '0;
                end
              else
                if(i_data_read[31:27] == 5'b00001)
                  begin
                    Pc_cmd         <= 2'b10;
                    Pc_alu         <= 1;
                    Iv_alu         <= 0;
                    d_write_enable <= 0;
                    d_load_enable  <= 0;
                    Rs1            <= 0;
                    Rs2            <= 0;
                    Pc_val         <= 2'b01;
                    Iv             <= {6'(i_data_read[25]),i_data_read[25:0]};
                    if(i_data_read[26] == 1)
                      begin
                        I  <= 4'd15;
                        Rd <= 5'd31;
                      end
                    else
                      begin
                        I  <= 4'd0;
                        Rd <= 5'd0;
                      end
                  end
                else
                  begin
                    Rs1            <= i_data_read[25:21];
                    Rs2            <= i_data_read[20:16];
                    Rd             <= i_data_read[20:16];
                    d_load_enable  <= 0;
                    d_write_enable <= 0;
                    Pc_cmd         <= 0;
                    Pc_val         <= 0;
                    Iv_alu         <= 1;
                    Iv             <= 0;
                    case(i_data_read[31:26])
                      'h08 :
                        begin
                          I  <= 4'd1;
                          Iv <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h0c :
                        begin
                          I  <= 4'd3;
                          Iv <= {16'b0, i_data_read[15:0]};
                        end
                      'h04 :
                        begin
                          Pc_cmd <= 2'b10;
                          I      <= 4'd8;
                          Iv     <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h05 :
                        begin
                          Pc_cmd <= 2'b10;
                          I      <= 4'd9;
                          Iv     <= {16'(i_data_read[15]),i_data_read[15:0]};
                          Rd     <= 0;
                        end
                      'h13 :
                        begin
                          I      <= 4'd15;
                          Rd     <= 5'd31;
                          Pc_cmd <= 2'b11;
                          Pc_val <= 2'b11;
                          Iv     <= {16'b0, i_data_read[15:0]};
                        end
                      'h12 :
                        begin
                          I      <= 4'd0;
                          Pc_cmd <= 2'b11;
                          Pc_val <= 2'b11;
                          Rd     <= 0;
                          Iv     <= {16'b0, i_data_read[15:0]};
                        end
                      'h0f :
                        begin
                          I  <= 4'd0;
                          Iv <= {16'b0, i_data_read[15:0]};
                        end
                      'h23 :
                        begin
                          I             <= 4'd1;
                          d_load_enable <= 1;
                          Iv            <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h0d :
                        begin
                          I  <= 4'd4;
                          Iv <= {16'b0, i_data_read[15:0]};
                        end
                      'h18 :
                        begin
                          I  <= 4'd10;
                          Iv <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h1c :
                        begin
                          I  <= 4'd11;
                          Iv <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h14 :
                        begin
                          I  <= 4'd6;
                          Iv <= {16'b0, i_data_read[15:0]};
                        end
                      'h1a :
                        begin
                          I  <= 4'd12;
                          Iv <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h19 :
                        begin
                          I  <= 4'd13;
                          Iv <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h17 :
                        begin
                          I  <= 4'd14;
                          Iv <= {16'b0, i_data_read[15:0]};
                        end
                      'h16 :
                        begin
                          I  <= 4'd7;
                          Iv <= {16'b0, i_data_read[15:0]};
                        end
                      'h0a :
                        begin
                          I  <= 4'd2;
                          Iv <= {16'(i_data_read[15]),i_data_read[15:0]};
                        end
                      'h2b :
                        begin
                          I              <= 4'd1;
                          Iv             <= {16'(i_data_read[15]),i_data_read[15:0]};
                          d_write_enable <= 1;
                          Rd             <= 5'd0;
                        end
                      'h0e :
                        begin
                          I  <= 4'd5;
                          Iv <= {16'b0, i_data_read[15:0]};
                        end
                    endcase
                  end
>>>>>>> 1e252add7aa17fbf7e4b88dca1ddad28f5484516
endmodule
