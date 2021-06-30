module driver_7seg(output logic [6:0]  hex0,
                   output logic [6:0]  hex1,
                   output logic [6:0]  hex2,
                   output logic [6:0]  hex3,
                   output logic [6:0]  hex4,
                   output logic [6:0]  hex5,
                   input logic         clk,
                   input logic         reset_n,
                   input logic         write_enable,
                   input logic         cs_7seg,
                   input logic [31:0]  data_write,
                   input logic [31:0]  address,
                   output logic [31:0] data_read);

    always@(posedge clk)
    begin
        if(!reset_n) begin
            {hex0,hex1,hex2,hex3,hex4,hex5} <= '0;
        end
        else if(write_enable & cs_7seg)
            case (address)
                3:  {hex0[0],hex1[0],hex2[0],hex3[0],hex4[0],hex5[0]} <= data_write[5:0]; 
                4:  {hex0[1],hex0[5],hex1[1],hex1[5],hex2[1],hex2[5],
                     hex3[1],hex3[5],hex4[1],hex4[5],hex5[1],hex5[5]} <= data_write[11:0]; 
                5:  {hex0[6],hex1[6],hex2[6],hex3[6],hex4[6],hex5[6]} <= data_write[5:0]; 
                6:  {hex0[4],hex0[2],hex1[4],hex1[2],hex2[4],hex2[2],
                     hex3[4],hex3[2],hex4[4],hex4[2],hex5[4],hex5[2]} <= data_write[11:0]; 
                7:  {hex0[3],hex1[3],hex2[3],hex3[3],hex4[3],hex5[3]} <= data_write[5:0]; 
        
        
        endcase
                case (address)
            3:  data_read[5:0]  <= {hex0[0],hex1[0],hex2[0],hex3[0],hex4[0],hex5[0]}; 
            4:  data_read[11:0] <= {hex0[1],hex0[5],hex1[1],hex1[5],hex2[1],hex2[5],
                                    hex3[1],hex3[5],hex4[1],hex4[5],hex5[1],hex5[5]};
            5:  data_read[5:0]  <= {hex0[6],hex1[6],hex2[6],hex3[6],hex4[6],hex5[6]}; 
            6:  data_read[11:0] <= {hex0[4],hex0[2],hex1[4],hex1[2],hex2[4],hex2[2],
                                    hex3[4],hex3[2],hex4[4],hex4[2],hex5[4],hex5[2]};
            7:  data_read[5:0]  <= {hex0[3],hex1[3],hex2[3],hex3[3],hex4[3],hex5[3]}; 
        endcase
    end


endmodule