module test;
reg clk;
reg rst;
wire [15:0]Flag;
wire[7:0] seg_data_pin;
    wire[7:0] seg_cs_pin;
top dut(
  .CLK100MHZ (clk), 
  .rst (rst),
  .Flag (Flag),
  .seg_data_pin(seg_data_pin),
  .seg_cs_pin(seg_cs_pin)
  );
initial begin
    clk = 0;
    forever #1 clk = ~clk;
    end
    initial 
         begin
         rst = 1;
         #2
         rst = 0;
         #2
        rst = 1;

        end
  
endmodule