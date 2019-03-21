`timescale 1ns / 1ps

//��Ҫ��vga.v���������ʱ������Ϊd5
module test; //����test����
  reg CLK;
  reg func;
  reg RSTn; //�ź�����
  reg [7:0]data_input;
  reg Switch;
  wire [7:0]data;
  //�����shift_reg��Ƶ�ʵ����
  top dut(
  .CLK (CLK), 
  .func (func),
  .RSTn (RSTn), 
  .data_input (data_input),
  .Switch (Switch),
  .data(data));

  //�˽��̿�������������ʱ��
  initial begin
  CLK = 0;
  forever #1 CLK = ~CLK;
  end
  initial 
  begin//�˹��̿�ָ���̼���
    RSTn = 0;
    Switch = 1'b0;//��ѯ��ʽ
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
    Switch = 1'b1;//�жϷ�ʽ
    #200
    data_input = 8'b01101111;
    func = 1'b1;
    #200
    func = 1'b0;
    #200
    Switch = 1'b0;//��ѯ��ʽ
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
    #200 $stop;
  end
endmodule
