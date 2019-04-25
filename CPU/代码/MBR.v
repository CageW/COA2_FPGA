module MBR(
	input clk,
	input rst,
	 (*dont_touch = "true" *)input C5,
	 (*dont_touch = "true" *)input C1,
	 (*dont_touch = "true" *)input C11,
	 (*dont_touch = "true" *)input  [15:0] memory_data,
	 (*dont_touch = "true" *)input  [15:0] ACC_NUM,
	 (*dont_touch = "true" *)input  [7:0] PC_NUM,
	 (*dont_touch = "true" *)output reg[15:0] buffer_out
	);
	
	always @(negedge clk or negedge rst) begin
        if (~rst) 
        begin
        buffer_out = 16'b0000000000000000;
        end
        else
			begin
				if(C5 == 1'b1)
					begin
						buffer_out = memory_data;
					end
					else
                                    begin
                                    end
				if(C1 == 1'b1)
					begin
						buffer_out[7:0] = PC_NUM[7:0];
					end
					else
                                    begin
                                    end
				if(C11 == 1'b1)
					begin
						buffer_out <= ACC_NUM;
					end
				else
                                    begin
                                    end
			end
		
	end
endmodule
