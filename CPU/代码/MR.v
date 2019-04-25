module MR(
    input clk,
	 (*dont_touch = "true" *)input [15:0]MR_in,
	input rst,
	 (*dont_touch = "true" *)output reg [15:0]MR_num = 0,
	 (*dont_touch = "true" *)  input C9,
	 (*dont_touch = "true" *)  output flag
    );
always @(negedge clk or  negedge rst)
    begin
        if (~rst) 
        begin
        MR_num <= 0;
        end
        else
            begin
                if(C9==1) MR_num <= MR_in;
                 
            end
        
	end
	    assign flag = ~MR_num[15];

endmodule
