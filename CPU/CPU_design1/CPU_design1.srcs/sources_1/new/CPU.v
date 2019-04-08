module A(
    input clk,
    input [15:0] result,
    input C1,
    output reg[15:0] acc = 15'b0
    );
    always @( C1)
    begin
    if(C1 == 1'b1) acc <= result;
    end
endmodule
module B(
    input [15:0]acc,
    output reg[15:0] BR = 1'b1
    );
   
    
endmodule
module C(
input C2,
input [15:0] ACC,
input [15:0] BR,
input [15:0] result
);
assign result = C2?ACC+BR:0;
endmodule
module top(
input clk,
input C1,
input C2,
output [15:0] acc
);
wire [15:0]result;
wire [15:0] BR;
A U0
(
clk, result,C1,acc);
B U1(
acc,BR);
C U2(
C2,acc,BR,result);
endmodule

