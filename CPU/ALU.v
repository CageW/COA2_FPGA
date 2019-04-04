module ALU(

	input C7,
	input [15:0] ACC_NUM,
	input C14,
	input [15:0] ALU_X,
	input [8:0]fn,
	output [15:0] ALU_result,

	);
	wire[15:0] x0 = C7 ? 16'b0 : ACC_NUM;//ACC
	wire[15:0] y0 = C14 ? 16'b0 : ALU_X;//[X]
	always @(fn) 
		begin
			case(fn)
				8'b00000001://ACC->[X]
					begin
						
					end
				8'b00000010://[X]->ACC 
					begin
						ALU_result = y0;
					end
				8'b00000011://ACC+[X]->ACC 
					begin
						ALU_result = x0 + y0;
					end
				8'b00000100://ACC-[X]->ACC 
					begin
						ALU_result = x0 - y0;
					end
				8'b00000101://If ACC>=0 then X->PC  else PC+1->PC 
					begin
						
					end
				8'b00000110://X->PC 
					begin
						
					end
				8'b00000111://Halt a program 
					begin
						
					end
				8'b00001000://ACC*[X]->ACC, MR 
					begin
						ALU_result = x0*y0;
					end
				8'b00001001://ACC÷[X]->ACC, DR 
					begin
						ALU_result = x0/y0;
					end
				8'b00001010://ACC and [X]->ACC 
					begin
						ALU_result = x0 & y0;
					end
				8'b00001011://ACC or [X]->ACC 
					begin
						ALU_result = x0 | y0;
					end
				8'b00001100://NOT [X]->ACC 
					begin
						ALU_result = ~y0;
					end
				8'b00001101://SHIFT ACC to Right 1bit, Logic Shift 
					begin
						ALU_result = x0 << 1;
					end
				8'b00001110://SHIFT ACC to Left 1bit, Logic Shift 
					begin
						ALU_result = x0 >> 1;
					end
				8'b00001111://Not (ACC) -> ACC
					begin
						ALU_result = ~x0;
					end
				
				default:
					begin
						
					end
			endcase
		end
	
endmodule


