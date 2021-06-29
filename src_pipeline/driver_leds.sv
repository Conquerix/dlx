module driver_leds(input logic       clk,
                   input logic       reset_n,
                   
                   input logic       chip_select,
                   input logic       write_enable,
                   input logic[31:0] data_write,
                   output logic[31:0]data_read,
                   
                   output logic[9:0] ledr);

    always@(posedge clk) begin
        if(reset_n)
            ledr <= 0;
        else if(chip_select & write_enable)
            ledr <= data_write[9:0];
        
        if(chip_select)
            data_read <= {22'b0,ledr};
    end
endmodule