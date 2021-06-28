module MEM(input  logic clk,
           input  logic reset_n,

           input  logic 	   d_data_valid,
           output logic [31:0] d_address,
           output logic [31:0] d_data_write,
           output logic        d_write_enable,

            /// signaux qui remontent le temps
           output logic [31:0] ALU_out_MEM_backward,
           output logic [4:0]  Rd_MEM_backward,


           output logic [4:0]  Rs3_MEM,
           input  logic [31:0] S3_MEM, 

           input  logic [31:0] ALU_out_MEM,
           input  logic        d_write_enable_MEM,
           input  logic        d_load_enable_MEM,
           input  logic [4:0]  Rd_MEM,
           
            
           output logic        d_load_enable_WB,
           output logic [4:0]  Rd_WB,
           output logic [31:0] ALU_out_WB);



always@(*) begin
    d_address    = ALU_out_MEM;
    
    d_data_write   = S3_MEM;
    Rs3_MEM        = Rd_MEM;
    d_write_enable = d_write_enable_MEM;

    ALU_out_MEM_backward  = ALU_out_MEM;
    Rd_MEM_backward       = Rd_MEM;

end

/// bascules D
always @(posedge clk) begin
    if(!reset_n) begin
        d_load_enable_WB  <= 0;
        Rd_WB             <= 0;
        ALU_out_WB        <= 0;
    end
    else begin
        d_load_enable_WB  <= d_load_enable_MEM;
        Rd_WB             <= Rd_MEM;
        ALU_out_WB        <= ALU_out_MEM;
    end
end


endmodule