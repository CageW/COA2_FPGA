module Processor(
  input func,
  input CLK,
  input RSTn,
  input IRQ,//中断请求
  input [7:0] data_input,
  input [7:0] Dout,//数据输出到CPU
  output reg[1:0] RW = 2'b00,//读写控制
  output reg[7:0] Din = 8'b00000000,//数据输入POC
  output reg ADDR = 0//地址
  );
  always @ ( posedge CLK or negedge RSTn )
    if(RSTn)
      begin
        if (IRQ == 1'b0) 
          begin//中断模式
            if(func ==1'b1 ) //要输入东西
              begin
                Din[7] = data_input[7];
                Din[6] = data_input[6]; 
                Din[5] = data_input[5];
                Din[4] = data_input[4];
                Din[3] = data_input[3];
                Din[2] = data_input[2];
                Din[1] = data_input[1];
                Din[0] = data_input[0];
                #3
                ADDR = 1'b1;//直接选中BR
                RW = 2'b11;
                #8
                RW = 2'b00;
              end
            else RW = 2'b00;
          end
        else 
          begin//查询模式
            if(func ==1'b1 ) //要输入东西
              begin
                ADDR = 1'b0;//CPU通过合适的地址选中SR寄存器，查询SR7信息
                RW = 2'b10;
                #3
                if(Dout[7]==1'b1)
                  begin
                    Din[7] = data_input[7];
                    Din[6] = data_input[6]; 
                    Din[5] = data_input[5];
                    Din[4] = data_input[4];
                    Din[3] = data_input[3];
                    Din[2] = data_input[2];
                    Din[1] = data_input[1];
                    Din[0] = data_input[0];
                    #3
                    ADDR = 1'b1;//直接选中BR
                    RW = 2'b11;
                    #8
                    RW = 2'b00;
                  end
                else RW = 2'b00;
              end
          end
      end
    else 
      begin
        RW = 2'b00;
        Din = 8'b00000000;
        ADDR = 0;
      end
endmodule

module POC(
  input Switch,
  input CLK,//时钟
  input RSTn,
  input [1:0] RW,//读写控制
  input [7:0] Din,//数据输入POC
  input RDY,
  input ADDR,//地址
  output reg TR = 0,
  output reg[7:0]PD = 8'b00000000,
  output reg IRQ = 1,//中断请求
  output reg[7:0] Dout = 8'b00000000//数据输出到CPU
    );
    reg[1:0] flag = 2'b00;
    reg[7:0] BR = 8'b00000000; //Buffer Register
    reg[7:0] SR = 8'b10000000;//Status Register  
    //SR7--Ready flag bit
    //SR0--interrupt bit
    //SR6-SR1--empty
    always @ ( posedge CLK or negedge RSTn )
      if(RSTn)
        begin
          if( (SR[0] == 1'b1) )
            if(SR[7]== 1'b1)
                IRQ = 1'b0;
            else IRQ = 1'b1;
          else IRQ = 1'b1;
        end
      else IRQ = 1'b1;
    
    always @ ( posedge CLK or negedge RSTn )
      if(RSTn)
        begin
          if(Switch == 1'b0) SR[0] = 1'b0;
          else if(Switch == 1'b1) SR[0] = 1'b1;

          if (SR[0] == 1'b0) begin//查询方式：SR0一直为0
              IRQ = 1'b1;
              if (RW == 2'b11)//从CPU读  Din
                begin
                  case(ADDR)
                    1'b1: //如果SR7=1，CPU选中BR寄存器,将要打印的一个字节的数据写入BR
                      begin
                        BR[7] = Din[7];
                        BR[6] = Din[6];
                        BR[5] = Din[5];
                        BR[4] = Din[4];
                        BR[3] = Din[3];
                        BR[2] = Din[2];
                        BR[1] = Din[1];
                        BR[0] = Din[0];
                        SR[7] = 0;//完成后CPU将SR7寄存器置为0
                      end
                    default:begin
                      end
                  endcase
                end
              else if(RW == 2'b10)//写给CPU  Dout
                begin
                  case(ADDR)
                    1'b0: //CPU通过合适的地址选中SR寄存器，查询SR7信息
                      begin
                        Dout[7] = SR[7];
                      end
                    default:begin
                      end
                  endcase
                end
              else//不读不写
                begin
                end
              if(!SR[7])//表明CPU已经写入新数据且尚未被处理。
                //开始与外设(打印机)握手操作，操作完成后POC将SR7寄存器置为1,即"准备好"状态。
                begin
                  //POC完成与 CPU的握手后，将数据送到PD端口
                  PD[7] = BR[7];
                  PD[6] = BR[6];
                  PD[5] = BR[5];
                  PD[4] = BR[4];
                  PD[3] = BR[3];
                  PD[2] = BR[2];
                  PD[1] = BR[1];
                  PD[0] = BR[0];
                  if (RDY == 1'b1) 
                    begin//POC检测到打印机的RDY=1，在TR发送脉冲
                      if (flag == 2'b00) 
                        begin//开始传数据
                          flag = 2'b01;
                        end
                      if (flag == 2'b10) 
                        begin
                        //延迟一段时间，打印完成后，打印机又将RDY置为1
                          flag <= 2'b00;
                          SR[7] <= 1'b1;
                          IRQ <= 1'b1;//使得IRQ信号拉低为低电平0，即发出中断请求
                        end
                      else begin
                        TR = 1'b1;
                      end
                    end
                  else 
                    begin
                      if (flag == 2'b01) 
                        begin
                          flag <= 2'b10;
                        end
                      TR = 1'b0;//检测到TR后，将RDY置为0，接收PD的数据送至打印
                    end
                end
            end
          else if (SR[0] == 1'b1)//中断方式
            begin
              if (RW == 2'b11)//从CPU读  Din
                begin
                  case(ADDR)
                    1'b1: //如果SR7=1，CPU选中BR寄存器,将要打印的一个字节的数据写入BR
                      begin
                        BR[7] = Din[7];
                        BR[6] = Din[6];
                        BR[5] = Din[5];
                        BR[4] = Din[4];
                        BR[3] = Din[3];
                        BR[2] = Din[2];
                        BR[1] = Din[1];
                        BR[0] = Din[0];
                        SR[7] = 0;//完成后CPU将SR7寄存器置为0
                      end
                    default:begin
                      end
                  endcase
                end
              else if(RW == 2'b10)//写给CPU  Dout
                begin
                  case(ADDR)
                    1'b0: //CPU通过合适的地址选中SR寄存器，查询SR7信息
                      begin
                        Dout[7] = SR[7];
                      end
                    default:begin
                      end
                  endcase
                end
              else//不读不写
                begin
                end
              if(!SR[7])//表明CPU已经写入新数据且尚未被处理。
                //开始与外设(打印机)握手操作，操作完成后POC将SR7寄存器置为1,即"准备好"状态。
                begin
                  //POC完成与 CPU的握手后，将数据送到PD端口
                  PD[7] = BR[7];
                  PD[6] = BR[6];
                  PD[5] = BR[5];
                  PD[4] = BR[4];
                  PD[3] = BR[3];
                  PD[2] = BR[2];
                  PD[1] = BR[1];
                  PD[0] = BR[0];
                  if (RDY == 1'b1) 
                    begin//POC检测到打印机的RDY=1，在TR发送脉冲
                      if (flag == 2'b00) 
                        begin//开始传数据
                          flag = 2'b01;
                        end
                      if (flag == 2'b10) 
                        begin
                        //延迟一段时间，打印完成后，打印机又将RDY置为1
                          flag = 2'b00;
                          SR[7] = 1'b1;
                          IRQ = 1'b0;//使得IRQ信号拉低为低电平0，即发出中断请求
                        end
                      else begin
                        TR = 1'b1;
                      end
                    end
                  else 
                    begin
                      if (flag == 2'b01) 
                        begin
                          flag <= 2'b10;
                        end
                      TR = 1'b0;//检测到TR后，将RDY置为0，接收PD的数据送至打印
                    end
                end
            end
        end
      else 
        begin
          flag = 2'b00;
          TR = 0;
          PD = 8'b00000000;
          IRQ = 1;
          Dout = 8'b00000000;
          BR = 8'b00000000;
          SR = 8'b10000000;
        end
endmodule

module printer(
  input CLK,//时钟
  input RSTn,
  input TR,
  input [7:0]PD,
  output reg RDY = 1'b1,
  output reg [7:0]data = 8'b00000000
    );
  reg[1:0] flag_printer = 2'b00;
  always @(posedge CLK or negedge RSTn)
    if(RSTn) 
      begin
        if (TR == 1'b1) 
          begin
            flag_printer = 2'b01;//接收PD的数据送至打印
            RDY = 1'b0;
          end
        if (flag_printer == 2'b01)//接收PD的数据送至打印
          begin
            data[7] = PD[7];
            data[6] = PD[6];
            data[5] = PD[5];
            data[4] = PD[4];
            data[3] = PD[3];
            data[2] = PD[2];
            data[1] = PD[1];
            data[0] = PD[0];
            flag_printer <= 2'b00;
            RDY = #13 (1'b1);//延迟13，打印完成后，打印机又将RDY置为1，表明准备好。
          end
      end
    else 
      begin
        flag_printer = 2'b00;
        RDY = (1'b1);
        data = 8'b00000000;
      end
endmodule
    
module top( 
  input CLK,
  input func,
  input RSTn,
  input [7:0] data_input,
  input Switch,
  output [7:0]data
  ); 
  wire IRQ;//中断请求
  wire [7:0] Dout;
  wire [1:0] RW;
  wire [7:0] Din;
  wire ADDR;
  wire RDY;
  wire TR;
  wire [7:0] PD;
  Processor U0
  (
    func,
    CLK,
    RSTn,
    IRQ,//中断请求
    data_input,
    Dout,//数据输出到CPU
    RW,//读写控制
    Din,//数据输入POC
    ADDR//地址
  );
  POC U1
  (    
    Switch,  
    CLK,
    RSTn,
    RW,
    Din,
    RDY,
    ADDR,
    TR,
    PD,
    IRQ,
    Dout
  );
  printer U2
  (
    CLK,
    RSTn,
    TR,
    PD,
    RDY,
    data
  );
endmodule
