
module temp(
    input clk,
    input rst,
 (* DONT_TOUCH= "{1|0}" *)   input    [5:0] uMA, // 6Î»Î¢µØÖ·×Ö¶Î
  (* DONT_TOUCH= "{1|0}" *)  input    [7:0] OPCODE_U0,//²Ù×÷Âë
  (* DONT_TOUCH= "{1|0}" *)  input    [7:0] cycle,//²Ù×÷Âë²Ù×÷
    (* DONT_TOUCH= "{1|0}" *)    input [7:0]OPCODE,
   (* DONT_TOUCH= "{1|0}" *) input [15:0]C,
   (* DONT_TOUCH= "{1|0}" *) input [10:0]fn,
    (* DONT_TOUCH= "{1|0}" *)input [15:0] ACC_NUM,
    (* DONT_TOUCH= "{1|0}" *)input [15:0] ALU_result,
    (* DONT_TOUCH= "{1|0}" *)input [15:0] ALU_X,
    (* DONT_TOUCH= "{1|0}" *)input [15:0] buffer_out,
    (* DONT_TOUCH= "{1|0}" *)input [7:0] pc,
    (* DONT_TOUCH= "{1|0}" *)input [7:0] address_out,
    (* DONT_TOUCH= "{1|0}" *)input [15:0] memory_data,
    (* DONT_TOUCH= "{1|0}" *)input [15:0] MR_ACC,
    (* DONT_TOUCH= "{1|0}" *)input [15:0] MR_NUM,
    (* DONT_TOUCH= "{1|0}" *)output reg rgb
    
    );
    
    always @(negedge clk or negedge rst) begin
            if (~rst) 
              begin
              rgb = 0;
              end
              else
                begin
                    rgb = uMA&&OPCODE_U0&&cycle&&OPCODE&&C&&fn&&ACC_NUM&&ALU_result&&ALU_X&&buffer_out&&pc&&address_out&&memory_data&&MR_ACC&&MR_NUM;

                end
            
        end
    
endmodule
