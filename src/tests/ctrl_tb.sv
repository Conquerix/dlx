module ctrl_tb() ;


// entrés
    logic clk,reset_n;
    // sorties
    logic IF,ID,EX,MEM,WB;


    ctrl ctrl1( .clk(clk),
                .reset_n(reset_n),
                .IF(IF),
                .ID(ID),
                .EX(EX),
                .MEM(MEM),
                .WB(WB));
    always begin
        #5ns
        clk <= !clk;
    end
    initial begin
        clk <= '0;
        reset_n <= '0;
        #10
        reset_n <= '1;

    end


endmodule