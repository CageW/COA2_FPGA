module display(
    input clk,
    (*dont_touch = "true" *) input [15:0] ACC_NUM,
    (*dont_touch = "true" *) input [15:0] MR,
    (*dont_touch = "true" *) output[7:0] seg_data_pin,
    (* dont_touch = "true" *) output[7:0] seg_cs_pin 
    );
    (*dont_touch = "true" *) wire [31:0] data;
    
    (*dont_touch = "true" *) wire [31:0] t_buf = data[31] ? (~(data - 1'b1)) : data;

    (*dont_touch = "true" *) wire tempfh = data[31];
    (*dont_touch = "true" *) wire [30:0] tempzs = t_buf[30:0]; 

    assign data[15:0] = ACC_NUM;
    assign data[31:16] = MR;


    (*dont_touch = "true" *) reg[7:0] select=8'b11111110;
    (*dont_touch = "true" *) integer disnum;
    (*dont_touch = "true" *) integer k;
    
    (*dont_touch = "true" *)    reg dp, cg, cf, ce, cd, cc, cb, ca;

    assign seg_data_pin = {dp, cg, cf, ce, cd, cc, cb, ca};

    assign seg_cs_pin=select;
    
    (*dont_touch = "true" *) reg  clk_5000hz=0;
    (*dont_touch = "true" *) reg [20:0] clk_cnt = 0;
    
    (*dont_touch = "true" *) reg [3:0] one;
    (*dont_touch = "true" *) reg [3:0] two;
    (*dont_touch = "true" *) reg [3:0] three;
    (*dont_touch = "true" *) reg [3:0] four;
    (*dont_touch = "true" *) reg [3:0] five;
    (*dont_touch = "true" *) reg [3:0] six;
    (*dont_touch = "true" *) reg [3:0] seven;
    (*dont_touch = "true" *) reg [3:0] eight;
    (*dont_touch = "true" *) reg [3:0] nine;
    (*dont_touch = "true" *) reg [3:0] ten;
    (*dont_touch = "true" *) integer i;
    always @(negedge clk ) 
        begin
            one = 4'd0;
            two = 4'd0;
            three = 4'd0;
            four = 4'd0;
            five = 4'd0;
            six = 4'd0;
            seven = 4'd0;
            eight = 4'd0;
            nine = 4'd0;
            ten = 4'd0;
            for(i=30;i>=0;i=i-1)
            begin
                if(ten >= 5)
                    ten = ten + 3;
                if(nine >= 5)
                    nine = nine + 3;
                if(eight >= 5)
                    eight = eight + 3;
                if(seven >= 5)
                    seven = seven + 3;
                if(six >= 5)
                    six = six + 3;
                if(five >= 5)
                    five = five + 3;
                if(four >= 5)
                    four = four + 3;
                if(three >= 5)
                    three = three + 3;
                if(two >= 5)
                    two = two + 3;
                if(one >= 5)
                    one = one + 3;
                ten = ten << 1;
                ten[0] = nine[3];
                nine = nine << 1;
                nine[0] = eight[3];
                eight = eight << 1;
                eight[0] = seven[3];
                seven = seven << 1;
                seven[0] = six[3];
                six = six << 1;
                six[0] = five[3];
                five = five << 1;
                five[0] = four[3];
                four = four << 1;
                four[0] = three[3];
                three = three << 1;
                three[0] = two[3];
                two = two << 1;
                two[0] = one[3];
                one = one << 1;
                one[0] = tempzs[i];
            end
        end


    always @(negedge clk)
        begin
            if(clk_cnt>=20000)
                begin 
                    clk_cnt<= 0;
                    clk_5000hz <=~clk_5000hz;
                end
            else
                begin 
                    clk_cnt<= clk_cnt+1;
                end
        end 
    always@(negedge clk_5000hz)
        begin
            
            select={select[6:0],select[7]};
            for(k=0;k<8;k=k+1) 
                begin
                    if(select[k]==0)
                       begin
                        case (k)
                            0:disnum=one;
                            1:disnum=two;
                            2:disnum=three;
                            3:disnum=four;
                            4:disnum=five;
                            5:disnum=six;
                            6:disnum=seven;
                            7:disnum=tempfh?4'd15:eight;  
                            default: disnum = 4'hf;                       
                         endcase
                       end
                end
            case (disnum) 
                    4'h0: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0000_0011;
                    4'h1: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b1001_1111;
                    4'h2: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0010_0101;
                    4'h3: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0000_1101;
                    4'h4: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b1001_1001;
                    4'h5: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0100_1001;
                    4'h6: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0100_0001;
                    4'h7: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0001_1111;
                    4'h8: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0000_0001;
                    4'h9: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0001_1001;
                    //4'ha: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0001_0001;
                    //4'hb: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b1100_0001;
                    //4'hc: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b1110_0101;
                    //4'hd: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b1000_0101;
                    //4'he: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0110_0001;
                    //4'hf: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b0111_0001;
                    4'd15:{ca, cb, cc, cd, ce, cf, cg, dp} = 8'b1111_1101;
                    default: {ca, cb, cc, cd, ce, cf, cg, dp} = 8'b1111_1111;       
            endcase      
            
        end
        
endmodule
