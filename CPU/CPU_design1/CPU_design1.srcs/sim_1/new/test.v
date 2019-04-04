`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/03 11:42:46
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test;
reg clk;
reg C1;
reg C2;
wire[15:0] acc;
top dut(
  .clk (clk), 
  .C1 (C1),
  .C2 (C2), 
  .acc (acc) 
  );
initial begin
    clk = 0;
    forever #1 clk = ~clk;
    end
    initial 
    begin//此过程块指定刺激。
      C1 = 0;
      C2 = 0;
      #200
      C2 = 1;
      C1 = 1;
      #1
      C1 = 0;
      C2 = 0;
    end
  
endmodule
