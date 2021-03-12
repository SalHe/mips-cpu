`ifndef _ALU_V_
`define _ALU_V_

`include "constants.v"

// ALU control signal
`define ALUOp_NOP   5'b00000
`define ALUOp_ADDU  5'b00001
`define ALUOp_ADD   5'b00010
`define ALUOp_SUBU  5'b00011
`define ALUOp_SUB   5'b00100
`define ALUOp_AND   5'b00101
`define ALUOp_OR    5'b00110
`define ALUOp_NOR   5'b00111
`define ALUOp_XOR   5'b01000
`define ALUOp_SLT   5'b01001
`define ALUOp_SLTU  5'b01010
`define ALUOp_EQL   5'b01011
`define ALUOp_BNE   5'b01100
`define ALUOp_GT0   5'b01101
`define ALUOp_GE0   5'b01110
`define ALUOp_LT0   5'b01111
`define ALUOp_LE0   5'b10000
`define ALUOp_SLL   5'b10001
`define ALUOp_SRL   5'b10010
`define ALUOp_SRA   5'b10011
`define ALUOp_LUI   5'b10100


module ALU
#(parameter WORD_WIDTH = `WORD_WIDTH)
 (
    input [WORD_WIDTH-1: 0] inA,
    input [WORD_WIDTH-1: 0] inB,
    input [4: 0] ALUOp,

    output reg [WORD_WIDTH-1: 0] out,
    output reg zero
);

    always @(*) begin
        case (ALUOp)
            `ALUOp_ADD:   out <= $signed(inA) & $signed(inB); 
            `ALUOp_ADDU:  out <= $unsigned(inA) + $unsigned(inB); 
            `ALUOp_SUB:   out <= $signed(inA) - $signed(inB); 
            `ALUOp_SUBU:  out <= $unsigned(inA) - $unsigned(inB); 
            default: out <= 0;
        endcase
    end
    
endmodule


`endif