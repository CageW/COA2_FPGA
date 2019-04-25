module ALU(
 input clk,
  (*dont_touch = "true" *)   input C7,
 (*dont_touch = "true" *)    input signed [15:0] ACC_NUM,
 (*dont_touch = "true" *)    input C14,
  (*dont_touch = "true" *)   input signed [15:0] ALU_X,
  (*dont_touch = "true" *)   input signed [15:0] MR_NUM,
  (*dont_touch = "true" *)   input signed [10:0]fn,
  (*dont_touch = "true" *)   output signed [15:0] ALU_result,
  (*dont_touch = "true" *)   output signed [15:0] MR
    );
 (*dont_touch = "true" *)    wire signed[15:0] x0 = C7 ?  ACC_NUM:$signed(0);
 (*dont_touch = "true" *)    wire signed[15:0] y0 = C14 ?  ALU_X:$signed(0);
    
  (*dont_touch = "true" *)   wire signed [31:0] result[10:0];
  (*dont_touch = "true" *)   wire signed [31:0] result_2;
  (*dont_touch = "true" *)   wire signed [31:0] result_3;
   (*dont_touch = "true" *) reg[31:0] temp_a;
    (*dont_touch = "true" *)    reg[31:0] temp_b;
     (*dont_touch = "true" *)   reg[15:0] shang;
      (*dont_touch = "true" *)  reg[15:0] yushu;
      
      (*dont_touch = "true" *)  integer i;
  
  assign result_3[31:16] = MR_NUM[15:0];
    assign result_3[15:0] = ACC_NUM[15:0];

    assign result[0] = fn[0]?y0:0;
    assign result[1] = fn[1]?(x0 + y0):0;
    assign result[2] = fn[2]?(x0 - y0):0;
    assign result[3] = fn[3]?(x0*y0):0;
    assign result[4] = fn[4]?(shang):0;
    assign result[5] = fn[5]?(x0 & y0):0;
    assign result[6] = fn[6]?(x0 | y0):0;
    assign result[7] = fn[7]?(~y0):0;
    assign result[8] = fn[8]?(result_3 >> 1):0;
    assign result[9] = fn[9]?(result_3 << 1):0;
    assign result[10] = fn[10]?(~x0):0;
    assign result_2 = result[0] + result[1] + result[2] + result[3] + result[4] + result[5] + result[6] + result[7] + result[8] + result[9] + result[10];
    assign ALU_result = result_2[15:0];
    assign MR = result_2[31:16];    
    
    
     
     
    always @(negedge clk)
    begin
        if(fn[4]==1)
        begin
        temp_a = {16'b0000000000000000,x0};
        temp_b = {y0,16'b0000000000000000}; 
        for(i = 0;i < 16;i = i + 1)
            begin
                temp_a = {temp_a[30:0],1'b0};
                if(temp_a[31:16] >= y0)
                    temp_a = temp_a - temp_b + 1'b1;
                else
                    temp_a = temp_a;
            end
     
        shang <= temp_a[15:0];
        yushu <= temp_a[31:16];
        end
    end
    
endmodule
