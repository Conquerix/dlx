module driver_switches(output logic[31:0] data,
                       input logic[9:0] ledr);

    always@(*)
        data = {22'b0, ledr};
endmodule