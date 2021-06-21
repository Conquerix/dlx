module ctrl
(
    input  logic    clk,
    input  logic    reset_n,

    output logic    IF,
    output logic    ID,
    output logic    EX,
    output logic    MEM,
    output logic    WB,
);

enum logic[2:0] {sIF,sID,sEX,sMEM,sWB} state, n_state;

always @(*)  begin
    case(state)
        sIF: n_state <= sID;
        sID: n_state <= sEX;
        sEX: n_state <= sMEM;
       sMEM: n_state <= sWB;
        sWB: n_state <= sIF;
    endcase
end 

always @(posedge clk) begin
    if(!reset_n)
        state <= '0;
    else
        state <= n_state;
end

always @(*) begin
    {IF,ID,EX,MEM,WB} <= '0;
    case(state)
        sIF:  IF  <= '1;
        sID:  ID  <= '1;
        sEX:  EX  <= '1;
        sMEM: MEM <= '1;
        sWB:  WB  <= '1;
    endcase
    
end

endmodule