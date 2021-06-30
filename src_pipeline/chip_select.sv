module chip_select (input logic [31:0] address,

                    output logic cs_led,
                    output logic cs_ram,
                    output logic cs_switches,
                    output logic cs_7seg,
                    output logic cs_buttons);

            always@(*)
              begin
                {cs_led,cs_switches,cs_ram,cs_buttons, cs_7seg} = 5'b0;

                if(address == 0)
                  cs_switches = 1;
                else if(address == 1)
                  cs_buttons  = 1;
                else if(address == 2)
                  cs_led      = 1;
                else if(address <= 7)
                  cs_7seg  = 1;
                else
                  cs_ram   = 1;
                  
              end
endmodule
