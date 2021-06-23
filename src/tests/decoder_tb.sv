module decoder_tb();

  logic        clk;
  logic        reset_n;
  logic        ID;
  logic [31:0] i_data_read;

  logic d_write_enable;
  logic d_load_enable;
  logic Iv_alu;
  logic Pc_alu;
  logic [1:0] Pc_cmd;
  logic [1:0] Pc_val;
  logic [3:0] I;
  logic [4:0] Rs1;
  logic [4:0] Rs2;
  logic [4:0] Rd;
  logic [31:0] Iv;

  decoder decoder1(.clk(clk),.reset_n(reset_n),
                   .ID(ID),
                   .i_data_read(i_data_read),
                   .d_write_enable(d_write_enable),
                   .d_load_enable(d_load_enable),
                   .Iv_alu(Iv_alu),
                   .Pc_alu(Pc_alu),
                   .Pc_cmd(Pc_cmd),
                   .Pc_val(Pc_val),
                   .I(I),
                   .Rs1(Rs1),
                   .Rs2(Rs2),
                   .Rd(Rd),
                   .Iv(Iv));


  always
    begin
      #5ns
      clk <= !clk;
    end

  initial
    begin
      #1ns
      clk = 0;
      reset_n = 0;
      ID      = 1;
      #12ns
      reset_n = 1;

      // On commence par les instructions R
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_100000;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_100100;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_100101;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_101000;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_101100;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_000100;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_101111;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_101001;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_000111;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_000110;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_100010;
      #10ns
      i_data_read = 32'b000000_01101_11000_00110_00000_100110;

      // Ensuite les deux instructions J
      #10ns
      i_data_read = 32'b000010_01101110000011000000100110;
      #10ns
      i_data_read = 32'b000011_01101110000011000000100110;

      // Et enfin les instructions I

      #10ns
      i_data_read = 32'b001000_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b001100_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b000100_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b000101_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b010011_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b010010_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b001111_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b100011_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b001101_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b011000_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b011100_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b010100_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b011010_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b011001_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b010111_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b010110_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b001010_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b101011_01101_11000_0011000000100110;
      #10ns
      i_data_read = 32'b001110_01101_11000_0011000000100110;


    end
endmodule