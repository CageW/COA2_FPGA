module CU(
	input clk,
	input rst,
	input [7:0]Flag,//标志寄存器
	input [7:0]OPCODE_IN,//操作码
	output reg [15:0]C = 16'b0,//寄存器控制信号
	output reg [10:0]fn = 11'b0//ALU控制信号
	);
	reg[5:0] uMA; // 6位微地址字段
	reg[7:0] OPCODE;
	reg[7:0] cycle = 8'h0;
	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				if(C13 == 1'b1)
					begin
						OPCODE = OPCODE_IN;
					end
				case(uMA)
					6'h00:
						begin
                            fn <= 11'b00000000000;
							C <= 16'b0000000000000100;// MAR ← (PC)  C2
							uMA <= 6'h01; 
						end
					6'h01:
						begin
							C <= 16'b1000000000100001;//MBR ← Memory PC ← (PC) +1 C0,C5,C15
							uMA <= 6'h02;
						end
					6'h02:
						begin
							C <= 16'b0000000000010000;//IR ← (MBR)  C4
							uMA <= 6'h03;
						end
					6'h03:
						begin
							C <= 16'b0010000000000000;//IR -> CU  C13
							uMA <= 6'h04;
						end
					6'h04:
						begin//根据指令进行操作
							C <= 16'b0000000000000000;
							case(OPCODE)
								8'b00000001:
									begin//ACC->[X]
										cycle <= 8'h3;
                                        case(cycle)
                                            8'h3:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h2;
                                                end
                                            8'h2:
                                                begin
                                                    C <= 16'b0000100000000000;//MBR ← (ACC) C11
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0001000000000000;//Memory ← (MBR) C12
                                                    cycle <= 8'h0;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00000010:
									begin//[X]->ACC 
										cycle <= 8'h3;
                                        case(cycle)
                                            8'h3:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h2;
                                                end
                                            8'h2:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0000010000000000;//ACC ← MBR C10
                                                    cycle <= 8'h0;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00000011:
									begin//ACC+[X]->ACC 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000001000000;//BR ← (MBR) C6
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0100001010000000;//ACC ← (ACC) + (MBR)   C7 C14 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00000000010;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00000100:
									begin//ACC-[X]->ACC 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000001000000;//BR ← (MBR) C6
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0100001010000000;//ACC ← (ACC) - (MBR)   C7 C14 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00000000100;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00000101:
									begin//If ACC>=0 then X->PC  else PC+1->PC 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000000000000;//
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000000000;//
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000000000000;//
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0000000000000000;//
                                                    cycle <= 8'h0;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00000110:
									begin//X->PC 
										C <= 16'b0000000000001000;// PC ← IR(Address)  C3
                                        uMA <= 6'h00;
									end
								8'b00000111:
									begin//Halt a program 
										
									end
								8'b00001000:
									begin//ACC*[X]->ACC, MR 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000001000000;//BR ← (MBR) C6
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0100001010000000;//ACC ← (ACC) - (MBR)   C7 C14 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00000001000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00001001:
									begin//ACC÷[X]->ACC, DR 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000001000000;//BR ← (MBR) C6
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0100001010000000;//ACC ← (ACC) - (MBR)   C7 C14 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00000010000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00001010:
									begin//ACC and [X]->ACC 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000001000000;//BR ← (MBR) C6
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0100001010000000;//ACC ← (ACC) - (MBR)   C7 C14 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00000100000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00001011:
									begin//ACC or [X]->ACC 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000001000000;//BR ← (MBR) C6
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0100001010000000;//ACC ← (ACC) - (MBR)   C7 C14 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00001000000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00001100:
									begin//NOT [X]->ACC 
										cycle <= 8'h4;
                                        case(cycle)
                                            8'h4:
                                                begin 
                                                    C <= 16'b0000000100000000;//MAR ← (IR(Address))  C8
                                                    cycle <= 8'h3;
                                                end
                                            8'h3:
                                                begin
                                                    C <= 16'b0000000000100000;//MBR ← Memory  C5
                                                    cycle <= 8'h2;
                                                end
                                             8'h2:
                                                begin
                                                    C <= 16'b0000000001000000;//BR ← (MBR) C6
                                                    cycle <= 8'h1;
                                                end
                                            8'h1:
                                                begin
                                                    C <= 16'b0100001000000000;//NOT [X]->ACC    C14 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00010000000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                                end
                                            default:
                                                begin 

                                                end
									end
								8'b00001101:
									begin//SHIFT ACC to Right 1bit, Logic Shift 
										cycle <= 8'h1;
                                        case(cycle)
                                            8'h1:
                                                begin 
                                                    C <= 16'b0000001010000000;//  C7 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b00100000000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                            default:
                                                begin 

                                                end
									end
								8'b00001110:
									begin//SHIFT ACC to Left 1bit, Logic Shift 
										cycle <= 8'h1;
                                        case(cycle)
                                            8'h1:
                                                begin 
                                                    C <= 16'b0000001010000000;//  C7 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b01000000000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                            default:
                                                begin 

                                                end
									end
								8'b00001111:
									begin//Not (ACC) -> ACC
										cycle <= 8'h1;
                                        case(cycle)
                                            8'h1:
                                                begin 
                                                    C <= 16'b0000001010000000;// Not (ACC) -> ACC  C7 C9
                                                    cycle <= 8'h0;
                                                    fn <= 11'b10000000000;
                                                    OPCODE <= 8'b00000000;
                                                    uMA <= 6'h00;
                                            default:
                                                begin 

                                                end
									end
								
								default:
									begin
										
									end
						end
				endcase


			end
		else 
			begin
				C = 16'b0;
				fn = 8'b0;
			end
	end



endmodule






module top(
	input clk,rst,
	output [7:0]Flag
	);
	wire clk2 = ~clk;
	wire [7:0]OPCODE;
	wire [15:0]C;
	wire [7:0]fn;
	CU U0(
		.clk(clk),
		.rst(rst),
		.Flag(Flag),
		.OPCODE(OPCODE),
		.C(C),
		.fn(fn)
		);
endmodule