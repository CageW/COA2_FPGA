module IR(
	input clk,
	input rst,
	 (*dont_touch = "true" *)input C4,
	 (*dont_touch = "true" *)input [7:0] OPCODE,
	 (*dont_touch = "true" *)output reg[7:0] OPCODE_out
	);

	always @(negedge clk or negedge rst) begin
        if (~rst) 
        begin
        OPCODE_out = 8'b00000000;
        end
        else
			begin
				if(C4 == 1'b1)
					begin
						OPCODE_out[7:0] <= OPCODE[7:0];
					end
					else
                                    begin
                                    end
			end
		
	end
endmodule
