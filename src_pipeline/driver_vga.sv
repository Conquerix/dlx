module driver_vga(input logic clock_50,
                  input logic reset_n,
                  input logic [31:0] data,
                  input logic chip_select,
                  input logic write_enable,
                  
                  output logic 	VGA_CLK,
                  output logic 	VGA_HS,
                  output logic 	VGA_VS,
                  output logic 	VGA_BLANK,
                  output logic [7:0] VGA_R,
                  output logic [7:0] VGA_G,
                  output logic [7:0] VGA_B,
                  output logic 	VGA_SYNC);


        logic [9:0] sx,sy;
        logic pixels[59:0][79:0];
        logic hsync, vsync, de;
        logic clock_pix = 0;

        always@(posedge clock_50)
            begin
                clock_pix <= !clock_pix;
                if(chip_select & write_enable)
                    begin
                        pixels[data[13:8]][data[7:1]] <= data[0];
                    end
            end

        always@(*)
            begin
                VGA_CLK   = clock_pix;
                VGA_HS    = hsync;
                VGA_VS    = vsync;
                VGA_BLANK = de;
                VGA_SYNC  = 0;
            end

        always_comb
            begin
                if(pixels[sy[8:3]][sx[9:3]])
                    begin
                        VGA_R = 8'hff;
                        VGA_G = 8'hff;
                        VGA_B = 8'hff;
                    end
                else
                    begin
                        VGA_R = 0;
                        VGA_G = 0;
                        VGA_B = 0;
                    end
                if(!VGA_BLANK)
                    begin
                        VGA_R = 0;
                        VGA_G = 0;
                        VGA_B = 0;
                    end
            end
        
        simple_display_timings_480p display_timings(.clock_pix(clock_pix),
                                                    .reset_n(reset_n),
                                                    .sx(sx),
                                                    .sy(sy),
                                                    .hsync(hsync),
                                                    .vsync(vsync),
                                                    .de(de));





endmodule