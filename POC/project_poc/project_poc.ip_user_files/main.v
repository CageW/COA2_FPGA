module Processor(
  input func,
  input CLK,
  input RSTn,
  input IRQ,//�ж�����
  input [7:0] data_input,
  input [7:0] Dout,//���������CPU
  output reg[1:0] RW = 2'b00,//��д����
  output reg[7:0] Din = 8'b00000000,//��������POC
  output reg ADDR = 0//��ַ
  );
  always @ ( posedge CLK or negedge RSTn )
    if(RSTn)
      begin
        if (IRQ == 1'b0) 
          begin//�ж�ģʽ
            if(func ==1'b1 ) //Ҫ���붫��
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
                ADDR = 1'b1;//ֱ��ѡ��BR
                RW = 2'b11;
                #8
                RW = 2'b00;
              end
            else RW = 2'b00;
          end
        else 
          begin//��ѯģʽ
            if(func ==1'b1 ) //Ҫ���붫��
              begin
                ADDR = 1'b0;//CPUͨ�����ʵĵ�ַѡ��SR�Ĵ�������ѯSR7��Ϣ
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
                    ADDR = 1'b1;//ֱ��ѡ��BR
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
  input CLK,//ʱ��
  input RSTn,
  input [1:0] RW,//��д����
  input [7:0] Din,//��������POC
  input RDY,
  input ADDR,//��ַ
  output reg TR = 0,
  output reg[7:0]PD = 8'b00000000,
  output reg IRQ = 1,//�ж�����
  output reg[7:0] Dout = 8'b00000000//���������CPU
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

          if (SR[0] == 1'b0) begin//��ѯ��ʽ��SR0һֱΪ0
              IRQ = 1'b1;
              if (RW == 2'b11)//��CPU��  Din
                begin
                  case(ADDR)
                    1'b1: //���SR7=1��CPUѡ��BR�Ĵ���,��Ҫ��ӡ��һ���ֽڵ�����д��BR
                      begin
                        BR[7] = Din[7];
                        BR[6] = Din[6];
                        BR[5] = Din[5];
                        BR[4] = Din[4];
                        BR[3] = Din[3];
                        BR[2] = Din[2];
                        BR[1] = Din[1];
                        BR[0] = Din[0];
                        SR[7] = 0;//��ɺ�CPU��SR7�Ĵ�����Ϊ0
                      end
                    default:begin
                      end
                  endcase
                end
              else if(RW == 2'b10)//д��CPU  Dout
                begin
                  case(ADDR)
                    1'b0: //CPUͨ�����ʵĵ�ַѡ��SR�Ĵ�������ѯSR7��Ϣ
                      begin
                        Dout[7] = SR[7];
                      end
                    default:begin
                      end
                  endcase
                end
              else//������д
                begin
                end
              if(!SR[7])//����CPU�Ѿ�д������������δ������
                //��ʼ������(��ӡ��)���ֲ�����������ɺ�POC��SR7�Ĵ�����Ϊ1,��"׼����"״̬��
                begin
                  //POC����� CPU�����ֺ󣬽������͵�PD�˿�
                  PD[7] = BR[7];
                  PD[6] = BR[6];
                  PD[5] = BR[5];
                  PD[4] = BR[4];
                  PD[3] = BR[3];
                  PD[2] = BR[2];
                  PD[1] = BR[1];
                  PD[0] = BR[0];
                  if (RDY == 1'b1) 
                    begin//POC��⵽��ӡ����RDY=1����TR��������
                      if (flag == 2'b00) 
                        begin//��ʼ������
                          flag = 2'b01;
                        end
                      if (flag == 2'b10) 
                        begin
                        //�ӳ�һ��ʱ�䣬��ӡ��ɺ󣬴�ӡ���ֽ�RDY��Ϊ1
                          flag <= 2'b00;
                          SR[7] <= 1'b1;
                          IRQ <= 1'b1;//ʹ��IRQ�ź�����Ϊ�͵�ƽ0���������ж�����
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
                      TR = 1'b0;//��⵽TR�󣬽�RDY��Ϊ0������PD������������ӡ
                    end
                end
            end
          else if (SR[0] == 1'b1)//�жϷ�ʽ
            begin
              if (RW == 2'b11)//��CPU��  Din
                begin
                  case(ADDR)
                    1'b1: //���SR7=1��CPUѡ��BR�Ĵ���,��Ҫ��ӡ��һ���ֽڵ�����д��BR
                      begin
                        BR[7] = Din[7];
                        BR[6] = Din[6];
                        BR[5] = Din[5];
                        BR[4] = Din[4];
                        BR[3] = Din[3];
                        BR[2] = Din[2];
                        BR[1] = Din[1];
                        BR[0] = Din[0];
                        SR[7] = 0;//��ɺ�CPU��SR7�Ĵ�����Ϊ0
                      end
                    default:begin
                      end
                  endcase
                end
              else if(RW == 2'b10)//д��CPU  Dout
                begin
                  case(ADDR)
                    1'b0: //CPUͨ�����ʵĵ�ַѡ��SR�Ĵ�������ѯSR7��Ϣ
                      begin
                        Dout[7] = SR[7];
                      end
                    default:begin
                      end
                  endcase
                end
              else//������д
                begin
                end
              if(!SR[7])//����CPU�Ѿ�д������������δ������
                //��ʼ������(��ӡ��)���ֲ�����������ɺ�POC��SR7�Ĵ�����Ϊ1,��"׼����"״̬��
                begin
                  //POC����� CPU�����ֺ󣬽������͵�PD�˿�
                  PD[7] = BR[7];
                  PD[6] = BR[6];
                  PD[5] = BR[5];
                  PD[4] = BR[4];
                  PD[3] = BR[3];
                  PD[2] = BR[2];
                  PD[1] = BR[1];
                  PD[0] = BR[0];
                  if (RDY == 1'b1) 
                    begin//POC��⵽��ӡ����RDY=1����TR��������
                      if (flag == 2'b00) 
                        begin//��ʼ������
                          flag = 2'b01;
                        end
                      if (flag == 2'b10) 
                        begin
                        //�ӳ�һ��ʱ�䣬��ӡ��ɺ󣬴�ӡ���ֽ�RDY��Ϊ1
                          flag = 2'b00;
                          SR[7] = 1'b1;
                          IRQ = 1'b0;//ʹ��IRQ�ź�����Ϊ�͵�ƽ0���������ж�����
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
                      TR = 1'b0;//��⵽TR�󣬽�RDY��Ϊ0������PD������������ӡ
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
  input CLK,//ʱ��
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
            flag_printer = 2'b01;//����PD������������ӡ
            RDY = 1'b0;
          end
        if (flag_printer == 2'b01)//����PD������������ӡ
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
            RDY = #13 (1'b1);//�ӳ�13����ӡ��ɺ󣬴�ӡ���ֽ�RDY��Ϊ1������׼���á�
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
  wire IRQ;//�ж�����
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
    IRQ,//�ж�����
    data_input,
    Dout,//���������CPU
    RW,//��д����
    Din,//��������POC
    ADDR//��ַ
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
