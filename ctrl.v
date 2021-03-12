`ifndef _CTRL_V_
`define _CTRL_V_

`include "risc.v"
`include "alu.v"

module Ctrl (
    input wire [5: 0] opcode,

    output reg [1:0] ctrlRegDst,
    output reg ctrlBranch,
    output reg ctrlMemRead,
    output reg [1:0] ctrlMemToReg,
    output reg [1:0] ctrlALUOp,
    output reg ctrlMemWrite,
    output reg ctrlALUSrc,
    output reg ctrlRegWrite,
    output reg ctrlImmExtend
);
    always @(*) begin
        
        ctrlRegDst      <= 2'b00;
        ctrlBranch      <= 1'b0;
        ctrlMemRead     <= 1'b0;

        case (opcode)
            `INSTR_OP_RTYPE: begin

            end

            `INSTR_OP_ADDI: begin
                
                
            end

            // Unkown OpCode
            default: begin
                $display("Got an unknown opcode: %x", opcode);
            end
        endcase
    end
endmodule

`define ALUOp_CALC_MEM_ADDRESS       2'b00
`define ALUOp_FUNCT_FROM_INSTRUCTION 2'b10
`define ALUOp_CALC_BRANCH_ADDRESS    2'b11

module ALUCtrl (
    input wire [1:0] ctrlALUOp,
    input wire [5:0] funct,
    output wire [4:0] outALUOp
);

    reg [5:0] tempFunct;

    always @(*) begin
       case (ctrlALUOp)
           // `ALUOp_CALC_MEM_ADDRESS:
           // `ALUOp_CALC_BRANCH_ADDRESS: 
           `ALUOp_FUNCT_FROM_INSTRUCTION: tempFunct = funct;
           default: tempFunct = funct;
       endcase 
    end

    assign outALUOp = tempFunct;

endmodule

`endif