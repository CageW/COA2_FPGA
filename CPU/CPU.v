module MAR(//MAR存放着要从存储器中读取或要写入存储器的存储器地址。
	input clk,
	input rst,
	input rw,
	input  reg[7:0] address_in,
	output reg[7:0] address_out
	);
	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				
				
			end
		else 
			begin
				// reset
			end
	end
endmodule

module MBR(//MBR存储着将要被存入内存或者最后一次从内存中读出来的数值
	input clk,
	input rst,
	input  [7:0] address_in_memory,
	input  [7:0] address_in_acc,
	output reg[15:0] buffer_out
	);

	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				
				
			end
		else 
			begin
				// reset
			end
	end
endmodule

module PC(//PC寄存器用来跟踪程序中将要使用的指令
	input clk,
	input rst,
	input [7:0] Program_in,
	output reg[7:0] Program_out,
	);

	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				
				
			end
		else 
			begin
				// reset
			end
	end
endmodule

module IR(//IR存放指令的OPCODE（操作码）部分
	input clk,
	input rst,
	input [7:0] OPCODE_in,
	output reg[7:0] OPCODE_out
	);

	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				
				
			end
		else 
			begin
				// reset
			end
	end
endmodule

module BR(//BR作为ALU的一个输入，存放着ALU的一个操作数
	input clk,
	input rst,
	input[15:0] buffer_out,
	output reg[15:0] ALU_in
	);

	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				
				
			end
		else 
			begin
				// reset
			end
	end
endmodule

module ACC(//ACC保存着ALU的另一个操作数，而且通常ACC存放着ALU的计算结果
	input clk,
	input rst,
	input[15:0] ALU_in,
	output reg[15:0] _out
	);

	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				
				
			end
		else 
			begin
				// reset
			end
	end
endmodule

module top(
	input clk,
	input rst
	);

endmodule