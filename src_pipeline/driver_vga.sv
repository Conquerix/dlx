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
        logic pixels[0:59][0:79];
        logic hsync, vsync, de;
        logic clock_pix = 0;

        wire [6:0] col_w = data[7:1];
        wire [5:0] lin_w = data[13:8];

        always@(posedge clock_50)
        begin
            if(chip_select & write_enable)
                begin
                    pixels[lin_w][col_w] <= data[0];
                end
        end


        always@(posedge clock_50 or negedge reset_n)
        if(!reset_n)
            clock_pix <= 1'b0;
        else
            clock_pix <= !clock_pix;

        
        assign VGA_CLK   = clock_pix;

        always@(*)
            begin
                VGA_HS    = hsync;
                VGA_VS    = vsync;
                VGA_BLANK = de;
                VGA_SYNC  = 0;
            end

        wire [6:0] col_r = sx[9:3];
        wire [5:0] lin_r = sy[8:3];
        wire pix_is_one  = pixels[lin_r][col_r];

//`define MIRE
        always_comb
            begin
                `ifndef MIRE
                if(pix_is_one)
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
                `else
                    VGA_R = {col_r,1'b0};
                    VGA_G = {lin_r, 2'b00};
                    VGA_B = '1;
                `endif
            end
        
        simple_display_timings_480p display_timings(.clock_pix(clock_pix),
                                                    .reset_n(reset_n),
                                                    .sx(sx),
                                                    .sy(sy),
                                                    .hsync(hsync),
                                                    .vsync(vsync),
                                                    .de(de));





endmodule