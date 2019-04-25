module fenpin(
    input CLK,
    input RSTn,
   (*dont_touch = "true" *) output reg CLK_50M
    );
	always @ (posedge CLK or negedge RSTn )
	    if( !RSTn )
	        begin
	            CLK_50M <= 0;
	        end
	    else
	        CLK_50M<=~CLK_50M;
endmodule