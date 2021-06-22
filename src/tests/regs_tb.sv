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

  initial
    begin
      #5ns
      WB <= 1;
      #13ns
      Rs1    <= 'd1;
      Rs2    <= 'd24;
      Rd     <= 'd7;
      reg_s  <= 'd111111;
      #10ns
      Rs1    <= 'd7;
      Rs2    <= 'd0;
      Rd     <= 'd3;
      reg_s  <= 'd222222;
      #10ns
      Rs1    <= 'd13;
      Rs2    <= 'd31;
      Rd     <= 'd13;
      reg_s  <= 'd333333;
      #10ns
      Rs1    <= 'd3;
      Rs2    <= 'd3;
      Rd     <= 'd10;
      reg_s  <= 'd444444;
      #10ns
      Rs1    <= 'd7;
      Rs2    <= 'd3;
      Rd     <= 'd7;
      reg_s  <= 'd555555;
    end
