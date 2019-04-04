module CU(
	input clk,
	input rst,
	input [7:0]Flag,//标志寄存器
	input [7:0]OPCODE,//操作码
	output reg [15:0]C = 15'b0,//寄存器控制信号
	output reg [7:0]fn = 8'b0//ALU控制信号
	);
	reg [9:0] state;
	always @(posedge clk or posedge rst) begin
		if (!rst) 
			begin
				case(state)
					10'b0:
						begin
							
						end
				endcase


			end
		else 
			begin
				C = 15'b0;
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