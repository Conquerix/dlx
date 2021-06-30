module driver_keys(output logic [31:0] data,
                   input  logic [3:0]  key);

    always@(*)
        data = {28'b0, ~key};
endmodule
