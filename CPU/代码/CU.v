module CU(
    input clk,
    input rst,
    (*dont_touch = "true" *)input Flag  ,
   (*dont_touch = "true" *)input [7:0]OPCODE_IN,
 (*dont_touch = "true" *)output reg [15:0]C = 16'b0,
    (*dont_touch = "true" *)output reg [10:0]fn = 11'b0,
    
   (*dont_touch = "true" *)output    reg[5:0] uMA =  6'b000_001, 
    (*dont_touch = "true" *)output    reg[7:0] OPCODE = 0,
    (*dont_touch = "true" *)output    reg[3:0] cycle = 4'b0000
    
    );
    parameter START = 6'b000_001;
    parameter Instr_fetch = 6'b000_010;
    parameter OPCODE_fetch = 6'b000_100;
    parameter OPCODE_READ = 6'b001_000;
    parameter OPCODE_RUN = 6'b010_000;
    parameter STOP = 6'b100_000;

    parameter NONE = 8'b00000000;
    parameter ACC_TO_X = 8'b00000001;
    parameter X_TO_ACC = 8'b00000010;
    parameter ADD = 8'b00000011;
    parameter SUB = 8'b00000100;
    parameter ACC_0 = 8'b00000101;
    parameter X_TO_PC = 8'b00000110;
    parameter HALT = 8'b00000111;
    parameter MUL = 8'b00001000;
    parameter DIV = 8'b00001001;
    parameter ACC_AND_X = 8'b00001010;
    parameter ACC_OR_X = 8'b00001011;
    parameter ACC_NOT_X = 8'b00001100;
    parameter SHIFT_RIGHT = 8'b00001101;
    parameter SHIFT_LEFT = 8'b00001110;
    parameter NOT_ACC = 8'b00001111;


    always @(posedge clk or negedge rst) begin
        if (~rst) 
         begin
         C = 0;
         fn = 0;
         uMA =  START; 
         OPCODE = 0;
         cycle = 4'b0000;
         end
        else
            begin
                case(uMA)
                    START:
                        begin
                            fn <= 11'b00000000000;
                            C <= 13'b0000000000000;
                            C[2] <= 1;
                            uMA <= Instr_fetch; 
                            OPCODE <=NONE;
                        end
                    Instr_fetch:
                        begin
                            C <= 13'b0000000000000;
                            C[0] <= 1;
                            C[5] <= 1;
                            C[15] <= 1;
                            uMA <= OPCODE_fetch;
                        end
                    OPCODE_fetch:
                        begin
                            C <= 13'b0000000000000;
                            C[4] <= 1;
                            uMA <=OPCODE_READ;
                        end
                    OPCODE_READ:
                        begin
                            C <= 13'b0000000000000;
                            C[13] <= 1;
                            OPCODE <= OPCODE_IN;
                            uMA <= OPCODE_RUN;
                        end
                    OPCODE_RUN:
                        begin
                            C <= 13'b0000000000000;
                            case(OPCODE)
                                ACC_TO_X:
                                    begin
                                        cycle <= 4'b0100;
                                        case(cycle)
                                            4'b0100:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                            4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[11] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[12] <= 1;
                                                    cycle <= 4'b0000;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase                                       
                                    end
                                X_TO_ACC:
                                    begin 
                                        cycle <= 4'b0100;
                                        case(cycle)
                                            4'b0100:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                            4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[0] <= 1;
                                                    C[5] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[10] <= 1;
                                                    cycle <= 4'b0000;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase                                                
                                    end
                                ADD:
                                    begin 
                                        cycle <= 4'b1000;
                                        case(cycle)
                                            4'b1000:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0100;
                                                end
                                            4'b0100:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[0] <= 1;
                                                    C[5] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                             4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[6] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[14] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[1] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase                                                
                                    end
                                SUB:
                                    begin 
                                        cycle <= 4'b1000;
                                        case(cycle)
                                            8'b1000:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0100;
                                                end
                                            4'b0100:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[0] <= 1;
                                                    C[5] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                             4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[6] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[14] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[2] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase
                                    end
                                ACC_0:
                                    begin
                                        cycle <= 4'b0010;
                                        case(cycle)
                                            4'b0010:
                                                begin
                                                    if(Flag == 1)
                                                    begin
                                                     C <= 13'b0000000000000;
                                                     C[3] <= 1;
                                                    cycle <= 4'b0001;
                                                     end
                                                     else
                                                     begin
                                                    C <= 13'b0000000000000;
                                                    cycle <= 4'b0000;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                    end
                                                end
                                            4'b0001:
                                            begin
                                             C <= 13'b0000000000000;
                                             cycle <= 4'b0000;
                                             OPCODE <=NONE;
                                             uMA <= START;
                                            end
                                            default:
                                                begin 
                                                     
                                                end
                                        endcase                                                
                                    end
                                X_TO_PC:
                                    begin
                                        C <= 13'b0000000000000;
                                        C[3] <= 1;
                                        uMA <= START;
                                        OPCODE <=NONE;
                                    end
                                HALT:
                                    begin
                                        uMA <= STOP;
                                    end
                                MUL:
                                    begin
                                        cycle <= 4'b1000;
                                        case(cycle)
                                            8'b1000:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0100;
                                                end
                                            4'b0100:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[0] <= 1;
                                                    C[5] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                             4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[6] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[14] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[3] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase
                                    end
                                DIV:
                                    begin
                                        cycle <= 4'b1000;
                                        case(cycle)
                                            8'b1000:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0100;
                                                end
                                            4'b0100:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[0] <= 1;
                                                    C[5] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                             4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[6] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[14] <= 1;
                                                   
                                                    cycle <= 4'b0011;
                                                    fn[4] <= 1;
                                                end
                                            4'b0011:
                                            begin
                                             C[9] <= 1;
                                            cycle <= 4'b0000;
                                            OPCODE <=NONE;
                                            uMA <= START;
                                            end
                                            default:
                                                begin 

                                                end
                                        endcase                                                
                                    end
                                ACC_AND_X:
                                    begin
                                        cycle <= 4'b1000;
                                        case(cycle)
                                            8'b1000:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0100;
                                                end
                                            4'b0100:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[0] <= 1;
                                                    C[5] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                             4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[6] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[14] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[5] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase
                                    end
                               ACC_OR_X:
                                    begin
                                        cycle <= 4'b1000;
                                        case(cycle)
                                            8'b1000:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0100;
                                                end
                                            4'b0100:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C <= 13'b0000000100000;
                                                    cycle <= 4'b0010;
                                                end
                                             4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[6] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[14] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[6] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase                                                
                                    end
                                ACC_NOT_X:
                                    begin
                                        cycle <= 4'b1000;
                                        case(cycle)
                                            8'b1000:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[8] <= 1;
                                                    cycle <= 4'b0100;
                                                end
                                            4'b0100:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[0] <= 1;
                                                    C[5] <= 1;
                                                    cycle <= 4'b0010;
                                                end
                                             4'b0010:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[6] <= 1;
                                                    cycle <= 4'b0001;
                                                end
                                            4'b0001:
                                                begin
                                                    C <= 13'b0000000000000;
                                                    C[14] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[7] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase                                                
                                    end
                                SHIFT_RIGHT:
                                    begin
                                        cycle <= 4'b0001;
                                        case(cycle)
                                            4'b0001:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[8] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase
                                    end
                                SHIFT_LEFT:
                                    begin
                                        cycle <= 4'b0001;
                                        case(cycle)
                                            4'b0001:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[9] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end
                                            default:
                                                begin 

                                                end
                                        endcase                                                
                                    end
                               NOT_ACC:
                                    begin
                                        cycle <= 4'b0001;
                                        case(cycle)
                                            4'b0001:
                                                begin 
                                                    C <= 13'b0000000000000;
                                                    C[7] <= 1;
                                                    C[9] <= 1;
                                                    cycle <= 4'b0000;
                                                    fn[10] <= 1;
                                                    OPCODE <=NONE;
                                                    uMA <= START;
                                                end                                                    
                                            default:
                                                begin 

                                                end
                                        endcase                                                
                                    end
                                
                                default:
                                    begin
                                        
                                    end
                            endcase
                        end
                    STOP:
                        begin
                        end
                    default:
                    begin
                    end
                endcase


            end
         
           
    end



endmodule







