module regs_tb();

  logic clk;
  logic WB;
  logic [4:0]  Rs1;
  logic [4:0]  Rs2;
  logic [4:0]  Rd;
  logic [31:0] reg_s;
  logic [31:0] S1;
  logic [31:0] S2;

  regs regs1(.clk(clk),.Rs1(Rs1),.Rs2(Rs2),.reg_s(reg_s),.S1(S1),.S2(S2));

  always
  begin
    #5ns
    clk <= !clk;
  end

  always@(posedge clk)
    begin
      #13ns
      Rs1 <= 'd1;
      Rs2 <= 'd24;
      Rd  <= 'd7;
      reg_s  <= 'd111111;
      #10ns
      reg_s  <= 'd222222;
      #10ns
      reg_s  <= 'd333333;
      #10ns
      reg_s  <= 'd444444;
      #10ns
      reg_s  <= 'd555555;
      #10ns
      reg_s  <= 'd666666;
      #10ns
      reg_s  <= 'd777777;
      #10ns
      reg_s  <= 'd888888;
      #10ns
      reg_s  <= 'd999999;
    end

  initial
    begin
      clk <= 0;
    end
