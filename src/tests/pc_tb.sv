module pc_tb();

// entrés
    logic clk,reset_n,  IF;
    logic[1:0] pc_cmd;
    logic[31:0] pc_v;
// sorties
    logic[31:0] i_address;
    
    pc pc1(.clk(clk),
       .reset_n(reset_n),
       .IF(IF),
       .pc_cmd(pc_cmd),
       .pc_v(pc_v),
       .i_address(i_address));

    always begin
        #5ns
        clk <= !clk;
    end
    initial begin
        clk <= '0;
        reset_n <= '0;

        #9ns
        reset_n <= '1;

        IF <= 0;
        pc_v <= 8;

        pc_cmd <= 2'b00;
        #14ns
        IF <= '1;
        #40ns
        pc_cmd <= 2'b10;

        #30ns
        pc_cmd <= 2'b11;

    end


endmodule