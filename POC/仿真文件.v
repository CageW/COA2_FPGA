`timescale 1ns / 1ps

//需要将vga.v里的两个延时计数改为d5
module test; //声明test名称
  reg CLK;
  reg func;
  reg RSTn; //信号声明
  reg [7:0]data_input;
  reg Switch;
  wire [7:0]data;
  //下面的shift_reg设计的实例化
  top dut(
  .CLK (CLK), 
  .func (func),
  .RSTn (RSTn), 
  .data_input (data_input),
  .Switch (Switch),
  .data(data));

  //此进程块设置自由运行时钟
  initial begin
  CLK = 0;
  forever #1 CLK = ~CLK;
  end
  initial 
  begin//此过程块指定刺激。
    RSTn = 0;
    Switch = 1'b0;//查询方式
    #200
    RSTn = 1;
    data_input = 8'b11110000;
    func = 1'b1;
    #200
    func = 1'b0;
    #200
    data_input = 8'b00001111;
    func = 1'b1;
    #200
    func = 1'b0;
    #200
    Switch = 1'b1;//中断方式
    #200
    data_input = 8'b01101111;
    func = 1'b1;
    #200
    func = 1'b0;
    #1000 $stop;
  end
endmodule
