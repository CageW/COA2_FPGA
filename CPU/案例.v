module CPU(clk,reset,interrupt,T1,T2,PC,MAR,IR,uMA,A,B,ALU,R0,R1,R2,R3,LDR,LDIR,BUS,OUT,FC,HIGH,LOW);
	input clk,reset,interrupt;
	output T1,T2,PC,MAR,IR,uMA,A,B,ALU,R0,R1,R2,R3,LDR,LDIR,BUS,OUT,FC,HIGH,LOW;
	reg[7:0] IN; //输入设备
	reg[7:0] MEM0,MEM1,MEM2,MEM3,MEM4,MEM5,MEM6,MEM7,MEM8; //内存中的普通程序
	reg[7:0] MEM20,MEM21,MEM22,MEM23; // 内存中的中断程序
	reg[7:0] R0,R1,R2,R3,ALU,A,B,PC,BUS,MAR,IR,OUT;
	reg[7:0] OLDPC; //发生中断时,保存的PC值
	reg[2:0] IOM;  // 3位读写控制字段
	reg[1:0] S;  // 2位ALU控制字段
	reg[2:0] LDXXX,XXX_B,C; // 三个控制字段
	reg[5:0] uMA; // 6位微地址字段
	//T1时刻直接XXX_B、设置LDXXX控制信号, T2时刻根据LDXXX信号 从BUS传数据
	reg LDA,LDB,LDR,LDPC,LDOUT,LDMAR,LDIR,INC_PC,FC,STOR_PC; // 微控制信号
	reg[1:0] SET_PC; //10将入口地址送入PC，11恢复PC
	reg P1,P2,P3,P4,P5,STI,CLI;
	reg T1;
	wire T2;
	//乘法的实现
	reg[7:0] HIGH,LOW,TEMP; //乘法所用到的寄存器
	reg[3:0] CR;  //计数器
	reg[2:0] ASSVAL;  //控制乘法涉及到的赋值
	reg[7:0] TEMPA,TEMPB; //临时累加寄存器
	
	//产生时序T1 T2；初始内存中的机器指令
	always @(posedge clk)
	begin
		if(reset)
			begin
				T1 <= 1'b0;
				//内存初始赋值（输入机器指令）MEM----------------		
			    IN <= 8'h44;
				MEM0 <= 8'b10100000; //立即数传值->R0
				MEM1 <= 8'b00000001;
				MEM2 <= 8'b10100100; //立即数传值->R1
				MEM3 <= 8'b00000010;
				MEM4 <= 8'b01010100; //R0*R1
				
			end
		else
			T1 <= ~T1;
	end
	
	assign T2=~T1;
	
	//T1 设置微代码各字段
	always @(posedge T1)
	begin
		if(reset)
			uMA <= 6'b000000;
		else
			begin
				case(uMA)
						6'h00:
							begin
								S <= 2'b00;
								XXX_B <= 3'b101;
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h01:
							begin
								S <= 2'b00;
								XXX_B <= 3'b000;
								LDXXX <= 3'b000;
								C <= 3'b001; //P<1>判断
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								if(interrupt)
									uMA <= 6'h20;//中断地址
								else 
									uMA <= 6'h02;
							end
						6'h02:
							begin
								S <= 2'b00;
								XXX_B <= 3'b011;
								LDXXX <= 3'b101;
								C <= 3'b000;
								INC_PC <= 1'b1;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h03;
							end
						6'h03:
							begin
								S <= 2'b00;
								XXX_B <= 3'b110;
								LDXXX <= 3'b110;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h04;
							end
						6'h04:
							begin
								S <= 2'b00;
								XXX_B <= 3'b000;
								LDXXX <= 3'b000;
								C <= 3'b010; //P<2>判断 各指令的分支
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								case({IR[7],IR[6],IR[5],IR[4]})
									4'b0000:
										uMA <= 6'h05; //IN
									4'b0001:
										uMA <= 6'h06; //OUT
									4'b0010:
										uMA <= 6'h07; //MOV
									4'b0011:
										uMA <= 6'h08; //ADD
									4'b0101:
										uMA <= 6'h30; //MUL
									4'b0110:
										uMA <= 6'h12; //STI
									4'b0111:
										uMA <= 6'h13; //CLI
									4'b1000:
										uMA <= 6'h14; //IRET
									4'b1001:
										uMA <= 6'h15; //HLT
									4'b1010:
										uMA <= 6'h16; //LDI
									4'b1110:
										uMA <= 6'h18; //JC
								endcase
							end
						6'h05:
							begin
								S <= 2'b00;
								XXX_B <= 3'b111;
								LDXXX <= 3'b011;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h06:
							begin
								S <= 2'b00;
								XXX_B <= 3'b010;
								LDXXX <= 3'b100;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h07:
							begin
								S <= 2'b00;
								XXX_B <= 3'b010;
								LDXXX <= 3'b011;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h08: //RD->A
							begin
								S <= 2'b00;
								XXX_B <= 3'b010;
								LDXXX <= 3'b001;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h09;
							end
						6'h09://RS->B
							begin
								S <= 2'b00;
								XXX_B <= 3'b010;
								LDXXX <= 3'b010;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h0A;
							end
						6'h0A:  //A+B->RD
							begin
								S <= 2'b01;
								XXX_B <= 3'b001;
								LDXXX <= 3'b011;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h12:  //STI
							begin
								S <= 2'b00;
								XXX_B <= 3'b100;
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h13:  //CLI
							begin
								S <= 2'b00;
								XXX_B <= 3'b101;
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h14:  //IREt
							begin
								S <= 2'b00;
								XXX_B <= 3'b000;
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b11;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h15:  //HLT NOP
							begin
								S <= 2'b00;
								XXX_B <= 3'b000;
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h15;
							end
						6'h16:  //LDI
							begin
								S <= 2'b00;
								XXX_B <= 3'b011;
								LDXXX <= 3'b101;
								C <= 3'b000;
								INC_PC <= 1'b1;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h17;
							end
						6'h17:  
							begin
								S <= 2'b00;
								XXX_B <= 3'b110;
								LDXXX <= 3'b011;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h18:    //JC 
							begin
								S <= 2'b00;
								XXX_B <= 3'b011;
								LDXXX <= 3'b101;
								C <= 3'b000;
								INC_PC <= 1'b1;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h19;
							end
						6'h19:  
							begin
								S <= 2'b00;
								XXX_B <= 3'b110;
								LDXXX <= 3'b101;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h1A;
							end
						6'h1A:  
							begin
								S <= 2'b00;
								XXX_B <= 3'b000;
								LDXXX <= 3'b000;
								C <= 3'b101;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								if(FC==1'b1)
									uMA <= 6'h1C;
								else
									uMA <= 6'h1B;
							end
						6'h1B:  
							begin
								S <= 2'b00;
								XXX_B <= 3'b000;
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h1C:  
							begin
								S <= 2'b00;
								XXX_B <= 3'b110;
								LDXXX <= 3'b111;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0;
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h01;
							end
						6'h20:  //中断分支
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; //PC_B
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b1; //保存PC
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								uMA <= 6'h21;
							end
						6'h21:  // 将入口地址送入PC
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; //保存PC
								SET_PC <= 2'b10;
								ASSVAL <= 3'b000;
								uMA <= 6'h02;
							end
						//实现乘法
						6'h30: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SiET_PC <= 2'b00;
								ASSVAL <= 3'b001;
								uMA <= 6'h31;
							end
						6'h31: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SET_PC <= 2'b00;
								ASSVAL <= 3'b010;
								uMA <= 6'h32;
							end
						6'h32: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b011; //P<3>
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								if(LOW[0])
									uMA <= 6'h33;
								else
									uMA <= 6'h34;
							end
						6'h33: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SET_PC <= 2'b00;
								ASSVAL <= 3'b011;
								uMA <= 6'h35;
							end
						6'h34: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SET_PC <= 2'b00;
								ASSVAL <= 3'b100;
								uMA <= 6'h35;
							end
						6'h35: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SET_PC <= 2'b00;
								ASSVAL <= 3'b101;
								uMA <= 6'h36;
							end
						6'h36: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b000;
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SET_PC <= 2'b00;
								ASSVAL <= 3'b110;
								uMA <= 6'h37;
							end
						6'h37: 
							begin
								S <= 2'b00;
								XXX_B <= 3'b000; 
								LDXXX <= 3'b000;
								C <= 3'b100; //P<4>
								INC_PC <= 1'b0;
								STOR_PC <= 1'b0; 
								SET_PC <= 2'b00;
								ASSVAL <= 3'b000;
								if(CR == 4'b1000) //CR==8?
									uMA <= 6'h01;
								else 
									uMA <= 6'h31;
							end
				endcase
			end
	end
	
	//设置每字段的控制信号
	always @(S or LDXXX or XXX_B or ASSVAL)
	begin	
		//ALU运算控制
		case(S)
				2'b00:
					begin
						ALU <= ALU;
					end
				2'b01:
					begin
						{FC,ALU} <= A + B;
					end	
				2'b10:
					begin
						ALU <= A && B;
					end	
				//2'b11:
		endcase
		// A字段控制 LDXX
		case(LDXXX)
				3'b000:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b0000000;
					end
				3'b001:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b1000000;
					end
				3'b010:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b0100000;
					end
				3'b011:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b0010000;
					end
				3'b100:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b0001000;
					end
				3'b101:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b0000100;
					end
				3'b110:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b0000010;
					end
				3'b111:
					begin
						{LDA,LDB,LDR,LDOUT,LDMAR,LDIR,LDPC} <= 7'b0000001;
					end
		endcase
		// B字段控制 XX_B
		case(XXX_B)
				3'b000:
					begin
						BUS <= BUS;
					end
				3'b001:
					begin
						BUS <= ALU;
					end
				3'b010:
					begin
						case({IR[1],IR[0]})
							2'b00:
								BUS <= R0;
							2'b01:
								BUS <= R1;
							2'b10:
								BUS <= R2;
							2'b11:
								BUS <= R3;
						endcase
					end
				3'b011:
					begin
						BUS <= PC;
					end
				3'b100:
					begin
						STI <= 1'b1;
						CLI <= 1'b0;
					end
				3'b101:
					begin
						STI <= 1'b0;
						CLI <= 1'b1;
					end
				3'b110:
				begin
					case(MAR)
						8'h00:
							BUS <= MEM0;
						8'h01:
							BUS <= MEM1;
						8'h02:
							BUS <= MEM2;
						8'h03:
							BUS <= MEM3;
						8'h04:
							BUS <= MEM4;
						8'h05:
							BUS <= MEM5;
						8'h06:
							BUS <= MEM6;
						8'h07:
							BUS <= MEM7;
						//8'h08:
						/**/
						8'h20:  //中断程序 
							BUS <= MEM20;
						/*8'h21:  //中断程序
							BUS <= MEM21;
						8'h22:  //中断程序
							BUS <= MEM22;
						8'h23:  //中断程序
							BUS <= MEM23;
							*/
					endcase
				end
				3'b111:
					BUS <= IN;
		endcase
		
	end
	//根据控制信号，操作、赋值(涉及到PC的操作)
	always @(posedge T2)
	begin
		// 乘法的相关赋值操作
		case(ASSVAL)
			3'b000:
				begin
					HIGH <= HIGH;
					LOW <= LOW;
					TEMP <= TEMP;
					CR <= CR;
				end
			3'b001:
				begin
					HIGH <= 8'b00000000;
					case({IR[1],IR[0]})
							2'b00:
								LOW <= R0;
							2'b01:
								LOW <= R1;
							2'b10:
								LOW <= R2;
							2'b11:
								LOW <= R3;
					endcase
					case({IR[3],IR[2]})
							2'b00:
								TEMP <= R0;
							2'b01:
								TEMP <= R1;
							2'b10:
								TEMP <= R2;
							2'b11:
								TEMP <= R3;
					endcase
					CR <= 4'b0000;
				end
			3'b010:
				TEMPA <= HIGH;
			3'b011:
				TEMPB <= TEMP;
			3'b100:
				TEMPB <= 8'b0000_0000;
			3'b101:
				HIGH <= TEMPA + TEMPB;
			3'b110:
				begin
				HIGH <= HIGH >> 1; //移位
				LOW <= {HIGH[0],LOW[7:1]}; //移位
				CR <= CR + 4'b0001;
				end
		endcase
		if(LDA)
			A <= BUS;
		if(LDB)
			B <= BUS;
		if(LDR)
		begin
			case({IR[3],IR[2]})
						2'b00:
							R0 <= BUS;
						2'b01:
							R1 <= BUS;
						2'b10:
							R2 <= BUS;
						2'b11:
							R3 <= BUS;
			endcase
		end
		if(LDOUT)
			OUT <= BUS;
		if(LDMAR)
			MAR <= BUS;
		if(LDIR)
			IR <= BUS;
		if(INC_PC)
			PC <= PC + 8'h01;
		if(LDPC)
			PC <= BUS;
		if(STOR_PC)
			OLDPC <= PC;
		if(SET_PC[1])
		begin
			if(SET_PC[0])
				PC <= OLDPC;
			else 
				PC <= 8'h20;
		end	
	end
endmodule