module PC(
    input clk,
    input rst,
    (*dont_touch = "true" *)input [7:0] jump_instr,
    (*dont_touch = "true" *)input C3,
    (*dont_touch = "true" *)input C15,
    (*dont_touch = "true" *)output reg[7:0] pc = 8'b00000000
    );
    (*dont_touch = "true" *)wire [7:0]next_pc = pc + 8'b01;
    always @(negedge clk or negedge rst) begin
        if (~rst) 
            begin
                pc <= 8'b00000000;
            end
        else
            begin
                if(C3 == 1'b1)
                    begin
                        pc <= jump_instr[7:0];
                    end
                else    if(C15 == 1'b1)
                    begin
                        pc <= next_pc;
                    end
                else
                begin
                end
            end
        
    end
endmodule
