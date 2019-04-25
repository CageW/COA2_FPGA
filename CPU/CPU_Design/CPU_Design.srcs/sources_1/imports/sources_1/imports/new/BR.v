module BR(
    input clk,
    input rst,
    (*dont_touch = "true" *)input C6,
    (*dont_touch = "true" *)input[15:0] buffer,
    (*dont_touch = "true" *)output reg[15:0] ALU_X
    );

    always @(negedge clk or negedge rst) begin
        if (~rst) 
            begin
                ALU_X = 16'b0000000000000000;
            end
        else
            begin
                if(C6 == 1'b1)
                    begin
                        ALU_X = buffer;
                    end
                else
                begin
                end
            end
        
    end
endmodule
