module A(
    input clk,
    input [15:0] result,
    input C1,
    output reg[15:0] acc = 15'b0
    );
    always @( C1) begin
        if(C1==1'b1) acc = result;
    end
endmodule
module B(
    input [15:0]acc,
    input C2,
    output[15:0] result
    );
    assign result = C2?acc + 15'b1:0;
endmodule

module top(
input clk,
input C1,
input C2,
output [15:0] acc
);
wire [15:0]result;
A U0
(
clk, result,C1,acc);
B U1(
acc,C2,result);

endmodule

module rom(
input clk
);
endmodule