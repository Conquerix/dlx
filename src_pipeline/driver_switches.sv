module driver_switches(output logic[31:0] data,
                       input logic[9:0] sw);

    always@(*)
        data = {22'b0, sw};
endmodule