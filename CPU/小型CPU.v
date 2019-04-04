module alu(x, y, out, fn, zero);
	//X  ACC
	//Y  操作数
	//fn 控制信号
	//out ACC输出
    input[15:0] x, y;
    input[5:0] fn;
    output[15:0] out;
    output zero;
    wire zx = fn[5];//x输入置0
    wire nx = fn[4];//x输入置反
    wire zy = fn[3];//y输入置0
    wire ny = fn[2];//y输入置反
    wire add = fn[1];//功能码：为1则代表Add，为0则代表And
    wire no = fn[0];//out输出取反
    wire[15:0] x0 = zx ? 16'b0 : x;
    wire[15:0] y0 = zy ? 16'b0 : y;
    wire[15:0] x1 = nx ? ~x0 : x0;
    wire[15:0] y1 = ny ? ~y0 : y0;
    wire[15:0] out0 = add ? x1 + y1 : x1 & y1;
    assign out = no ? ~out0 : out0;
    assign zero = ~|out;

endmodule

module cpu(clk, nrst, inst_addr, inst, rdata, wdata, data_addr, we);
    input clk, nrst;
    input[15:0] inst;            // instruction
    input[15:0] rdata;       // inM
    output[14:0] inst_addr;  // pc
    output[14:0] data_addr;  // addressM
    output[15:0] wdata;      // outM
    output we;               // writeM
    reg[14:0] pc;
    reg[15:0] a;
    reg[15:0] d
    alu alu0(.x(d), .y(am), .out(alu_out), .fn(alu_fn), .zero(zero));
    wire load_a = !inst[15] || inst[5];
    wire load_d = inst[15] && inst[4];
    wire sel_a = inst[15];
    wire sel_am = inst[12];
    wire jump = (less_than_zero && inst[2])
                 || (zero && inst[1])
                 || (greater_than_zero && inst[0]);

    wire sel_pc = inst[15] && jump;
    wire zero;
    wire less_than_zero = alu_out[15];
    wire greater_than_zero = !(less_than_zero || zero);
    wire[14:0] next_pc = sel_pc ? a[14:0] : pc + 15'b1;
    wire[15:0] next_a = sel_a ? alu_out : {1'b0, inst[14:0]};
    wire[15:0] next_d = alu_out;
    wire[15:0] am = sel_am ? m : a;
    wire[15:0] alu_out;
    wire[5:0] alu_fn = inst[11:6];
    wire[15:0] m = rdata;
    assign inst_addr = pc;
    assign data_addr = a[14:0];
    assign wdata = alu_out;
    assign we = inst[15] && inst[3];
    always @(posedge clk)
        if (!nrst)
			 pc <= 15'b0;
        else
            pc <= next_pc;
    always @(posedge clk)
        if (load_a)
            a <= next_a;
    always @(posedge clk)
        if (load_d)
            d <= next_d;
endmodule