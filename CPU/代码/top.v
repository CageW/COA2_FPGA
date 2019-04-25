module top(
    input CLK100MHZ,
    input rst,
    output [15:0]Flag,
    output[7:0] seg_data_pin,
    output[7:0] seg_cs_pin
    );
  (*dont_touch = "true" *) wire [7:0]OPCODE;
  (*dont_touch = "true" *)  wire [15:0]C;
 (*dont_touch = "true" *) wire [10:0]fn;
(*dont_touch = "true" *)   wire [15:0] ACC_NUM;
(*dont_touch = "true" *)   wire [15:0] ALU_result;
 (*dont_touch = "true" *)   wire [15:0] ALU_X;
 (*dont_touch = "true" *) wire [15:0] buffer_out;
(*dont_touch = "true" *)   wire [7:0] pc;
(*dont_touch = "true" *)  wire [7:0] address_out;
(*dont_touch = "true" *)  wire [15:0] memory_data;
 (*dont_touch = "true" *)   wire [15:0] MR_ACC;
 (*dont_touch = "true" *)   wire [15:0] MR_NUM;
  (*dont_touch = "true" *)    wire CLK_50M;
    
 (*dont_touch = "true" *)  wire[5:0] uMA_U0; 
  (*dont_touch = "true" *)  wire[7:0] OPCODE_U0;
(*dont_touch = "true" *)  wire[3:0] cycle_U0;
    CU U0(
        .clk(CLK_50M),
        .rst(rst),
        .Flag(Flag[0]),
        .OPCODE_IN(OPCODE),
        .C(C),
        .fn(fn),
        .uMA(uMA_U0),
         .OPCODE(OPCODE_U0),
         .cycle(cycle_U0)
        
        
        );
    display U1(
        .clk(CLK100MHZ),
        .ACC_NUM(ACC_NUM),
        .MR(MR_NUM),
        .seg_data_pin(seg_data_pin),
        .seg_cs_pin(seg_cs_pin)

    );
    ACC U2(
        .clk(CLK_50M),
        .rst(rst),
        .C9(C[9]),
        .C10(C[10]),
        .ALU_result(ALU_result),
        .MBR_NUM(buffer_out),
        .ACC_NUM(ACC_NUM)
    );
    ALU U3(
        .clk(CLK_50M),
        .C7(C[7]),
        .ACC_NUM(ACC_NUM),
        .C14(C[14]),
        .ALU_X(ALU_X),
        .MR_NUM(MR_NUM),
        .fn(fn),
        .ALU_result(ALU_result),
        .MR(MR_ACC)
    );
    BR U4(
        .clk(CLK_50M),
        .rst(rst),
        .C6(C[6]),
        .buffer(buffer_out),
        .ALU_X(ALU_X)
    );
    IR U5(
        .clk(CLK_50M),
        .rst(rst),
        .C4(C[4]),
        .OPCODE(buffer_out[15:8]),
        .OPCODE_out(OPCODE)
    );
    MAR U6(
        .clk(CLK_50M),
        .rst(rst),
        .C2(C[2]),
        .C8(C[8]),
        .address_PC(pc),
        .address_IR(buffer_out[7:0]),
        .address_out(address_out)
    );
    MBR U7(
        .clk(CLK_50M),
        .rst(rst),
        .C5(C[5]),
        .C1(C[1]),
        .C11(C[11]),
        .memory_data(memory_data),
        .ACC_NUM(ACC_NUM),
        .PC_NUM(pc),
        .buffer_out(buffer_out)
    );
    PC U8(
        .clk(CLK_50M),
        .rst(rst),
        .jump_instr(buffer_out[7:0]),
        .C3(C[3]),
        .C15(C[15]),
        .pc(pc)
    );
    RAM U9(
        .clk(CLK_50M),
        .rst(rst),
        .C12(C[12]), 
        .address(address_out),
        .data_input(buffer_out), 
        .data_out(memory_data)
    );
    MR U10(
        .clk(CLK_50M),
        .MR_in(MR_ACC),
        .rst(rst),
        .MR_num(MR_NUM),
        .C9(C[9]),
        .flag(Flag[0])

    );
     fenpin U11(
     .CLK(CLK100MHZ),
      .RSTn(rst),
      . CLK_50M(CLK_50M)
       );

endmodule