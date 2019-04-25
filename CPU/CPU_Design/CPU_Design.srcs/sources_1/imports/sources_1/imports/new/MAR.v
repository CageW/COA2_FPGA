module MAR(
    input clk,
    input rst,
    (*dont_touch = "true" *)input C2,
    (*dont_touch = "true" *)input C8,
    (*dont_touch = "true" *)input [7:0] address_PC,
    (*dont_touch = "true" *)input [7:0] address_IR,
    (*dont_touch = "true" *)output reg[7:0] address_out
    );
    always @(negedge clk or negedge rst) begin
        if (~rst) 
        begin
        address_out = 8'b00000000;
        end
        else
            begin
                if(C2 == 1'b1)
                    begin
                        address_out[7:0] = address_PC[7:0];//PC -> MAR
                    end
                    else
                    begin
                    end
                if(C8 == 1'b1)
                    begin
                        address_out[7:0] = address_IR[7:0];
                    end
                    else
                    begin
                    end
            end
        
    end
endmodule
