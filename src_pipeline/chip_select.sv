module chip_select (input logic [31:0] address,

                    output logic cs_led,
                    output logic cs_ram);

            always@(*)
              begin
                if(address == 0'b1)
                  begin
                    cs_led = 1;
                    cs_ram = 0;
                  end
                else if(address != '0)
                  begin
                    cs_led = 0;
                    cs_ram = 1;
                  end
                else
                  begin
                    cs_led = '0;
                    cs_ram = '0;
                  end
              end
endmodule //
