module RAM (
    input clk,
    input C12, 
    input [7:0]address,
    input [15:0]data_input, 
    output [15:0]data_out
	);

	reg [15:0] ram [7:0];
	//  negedge
	always @(posedge clk)
	    if (C12) ram[address] <= data_input;//read
	assign data_out = ram[address];
endmodule

module MAR(//MAR存放着要从存储器中读取或要写入存储器的存储器地址。
	input rst,
	input C2,
	input C8,
	input [7:0] address_PC,
	input [15:0] address_IR,
	output [7:0] address_out
	);
	reg[7:0] address
	always @(C2 or C8 or posedge rst) begin
		if (!rst) 
			begin
				if(C2 == 1'b1)
					begin
						address[7:0] = address_PC[7:0];//PC -> MAR
					end
				if(C8 == 1'b1)
					begin
						address[7:0] = address_IR[7:0];
					end
			end
		else 
			begin
				address = 8'bx;
			end
	end
	assign address_out = C0?address:8'bz;//将地址放到地址线上
endmodule

module MBR(//MBR存储着将要被存入内存或者最后一次从内存中读出来的数值
	input clk,
	input rst,
	input C5,
	input C1,
	input C11,
	input  [15:0] address_in_memory,
	input  [7:0] address_in_acc,
	input  [7:0] address_PC,
	output reg[15:0] buffer_out
	);
	
	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				if(C5 == 1'b1)
					begin
						buffer_out = address_in_memory;
					end
				if(C1 == 1'b1)
					begin
						buffer_out[7:0] = address_PC[7:0];
					end
				if(C11 == 1'b1)
					begin
						buffer_out[7:0] = address_in_acc[7:0];
					end
				
			end
		else 
			begin
				buffer_out = 16'bx;
			end
	end
endmodule

module PC(//PC寄存器用来跟踪程序中将要使用的指令
	input clk,
	input rst,
	input [15:0] jump_instr,
	input C3,
	input C15,
	output reg[7:0] pc
	);
	wire next_pc = pc + 8'b01;
	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				if(C15 == 1'b1)
					begin
						pc <= next_pc;
					end
				if(C3 == 1'b1)
					begin
						pc <= jump_instr[7:0];
					end
			end
		else 
			begin
				pc <= 8'b0;
			end
	end
endmodule

module IR(//IR存放指令的OPCODE（操作码）部分
	input clk,
	input rst,
	input C4,
	input [15:0] OPCODE,
	output reg[7:0] OPCODE_out
	);

	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				if(C4 == 1'b1)
					begin
						OPCODE_out[7:0] = OPCODE[15:8];
					end
			end
		else 
			begin
				OPCODE_out = 8'bx;
			end
	end
endmodule

module BR(//BR作为ALU的一个输入，存放着ALU的一个操作数
	input clk,
	input rst,
	input C6,
	input[15:0] buffer,
	output reg[15:0] ALU_X
	);

	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				if(C6 == 1'b1)
					begin
						ALU_X = buffer;
					end
			end
		else 
			begin
				ALU_X = 16'bx;
			end
	end
endmodule

module ACC(//ACC保存着ALU的另一个操作数，而且通常ACC存放着ALU的计算结果
	input clk,
	input rst,
	input C9,
	input C10,
	input [15:0] ALU_result,
	input [15:0] MBR_NUM,
	output reg[15:0] ACC_NUM = 16'b0
	);
	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				if(C10 == 1'b1)
					begin 
						ACC_NUM <= MBR_NUM;
					end
				if(C9 == 1'b1)
					begin
						ACC_NUM <= ALU_result;
					end
				
			end
		else 
			begin
				ACC_NUM = 16'bx;
			end
	end
	always @(C9) 
		begin
			if(C9 == 1'b1)
				begin
					ACC_NUM <= ALU_result;
				end
		end
endmodule

module ALU(

	input C7,
	input [15:0] ACC_NUM,
	input C14,
	input [15:0] ALU_X,
	input [10:0]fn,
	output [15:0] ALU_result,

	);
	wire[15:0] x0 = C7 ? 16'b0 : ACC_NUM;//ACC
	wire[15:0] y0 = C14 ? 16'b0 : ALU_X;//[X]
	assign ALU_result = fn[0]*y0 + fn[1]*(x0 + y0) + fn[2]*(x0 - y0) + fn[3]*(x0*y0) + fn[4]*(x0/y0) + fn[5]*(x0 & y0) + fn[6]*(x0 | y0) + fn[7]*(~y0) + fn[8]*(x0 << 1) + fn[9]*(x0 >> 1) + fn[10]*(~x0);
endmodule



