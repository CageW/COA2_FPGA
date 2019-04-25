module ACC(
	input clk,
	input rst,
	 (*dont_touch = "true" *)input C9,
	 (*dont_touch = "true" *)input C10,
	 (*dont_touch = "true" *)input [15:0] ALU_result,
	 (*dont_touch = "true" *)input [15:0] MBR_NUM,
	 (*dont_touch = "true" *)output reg[15:0] ACC_NUM = 16'b0
	);
	always @(negedge clk or negedge rst) begin
        if (~rst) 
            begin
                ACC_NUM = 16'b0000000000000000;
            end
        else
			begin
				if(C10 == 1'b1)
					begin 
						ACC_NUM <= MBR_NUM;
					end
				else
                                    begin
                                    end
				if(C9 == 1'b1)
					begin
						ACC_NUM <= ALU_result;
					end
					else
                                    begin
                                    end
				
			end
		
	end
endmodule
