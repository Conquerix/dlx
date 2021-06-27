module IF(input  logic        clk,
          input  logic        reset_n,

/////////////////////////////////////// signaux qui remontent le temps
          input  logic        pc_cmd_ID,
          input  logic        pc_cmd_EX,
          input  logic [31:0] pc_in_ID,
          input  logic [31:0] pc_in_EX,

/////////////////////////////////////// signaux qui redescendent le temps
            output logic [31:0] i_address);

    logic [31:0] Pc_out;
    logic [31:0] pc_in;
    logic        pc_set;

    pc pc1(.clk(clk), .reset_n(reset_n),
        .pc_set(pc_set),
        .pc_in(pc_in),
        .Pc_out(Pc_out));


    always@(*) begin
        // deux jumps ne peuvent se faire en même temps,
        // on modifie le pc si une commande se fait
        pc_set = pc_cmd_EX | pc_cmd_ID;

        // et on choisi l'adresse de jump grace a un multiplexeur
        // le premier jump doit être pris en priorité: en EX
        if(pc_cmd_EX)
            pc_in = pc_in_EX;
        else
            pc_in = pc_in_ID;

        // multiplexeur:
        //  si on modifie le pc en entré, 
        //  on modifie le pc en sortie en assynchrone
        if(pc_set)
            i_address = pc_in;
        else
            i_address = Pc_out;
    end

endmodule