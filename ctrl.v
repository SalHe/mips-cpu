`ifndef _CTRL_V_
`define _CTRL_V_

`include "risc.v"
`include "alu.v"
`include "mux.v"
`include "extend.v"


// `define ALUOp_CALC_MEM_ADDRESS       2'b00
// `define ALUOp_FUNCT_FROM_INSTRUCTION 2'b10
// `define ALUOp_CALC_BRANCH_ADDRESS    2'b11
`define CtrlALUOp_FUNCT                 3'b000
`define CtrlALUOp_EXFUNCT               3'b001
// `define CtrlALUOp_ADD                   3'b001
// `define CtrlALUOp_ADDU                  3'b010
// `define CtrlALUOp_AND                   3'b011
// `define CtrlALUOp_OR                    3'b100
// `define CtrlALUOp_XOR                   3'b101
// `define CtrlALUOp_LU                   3'b110

module Ctrl (
    input wire [5: 0] opcode,

    output reg [1:0] ctrlRegDst,
    output reg ctrlBranch,
    output reg ctrlMemRead,
    output reg [1:0] ctrlMemToReg,
    output reg [2:0] ctrlALUOp,
    output reg [4:0] ctrlALUExtOp,
    output reg ctrlMemWrite,
    output reg ctrlALUSrc,
    output reg ctrlRegWrite,
    output reg ctrlImmExtend
);
    always @(*) begin
        
        // 默认值. 关闭所有写使能、不发生分支。
        ctrlRegDst      <= 2'b00;
        ctrlBranch      <= 1'b0;
        ctrlMemRead     <= 1'b0;
        ctrlMemToReg    <= 2'b00;
        ctrlALUOp       <= 3'b000;
        ctrlALUExtOp    <= 4'b0000;
        ctrlMemWrite    <= 1'b0;
        ctrlMemRead     <= 1'b0;
        ctrlALUSrc      <= 1'b0;
        ctrlRegWrite    <= 1'b0;
        ctrlImmExtend   <= 1'b0;

        case (opcode)
            `INSTR_OP_RTYPE: begin

            end

            `INSTR_OP_ADDI: begin
                ctrlRegDst      <= `SEL_REGDST_RT;
                ctrlMemToReg    <= `SEL_WB_ALUOUT;
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_ADD;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlRegWrite    <= 1;
                ctrlImmExtend   <= `EXT_MODE_SIGNED;
            end

            `INSTR_OP_ADDIU: begin
                ctrlRegDst      <= `SEL_REGDST_RT;
                ctrlMemToReg    <= `SEL_WB_ALUOUT;
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_ADDU;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlRegWrite    <= 1;
                ctrlImmExtend   <= `EXT_MODE_UNSIGNED;
            end

            `INSTR_OP_ANDI: begin
                ctrlRegDst      <= `SEL_REGDST_RT;
                ctrlMemToReg    <= `SEL_WB_ALUOUT;
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_AND;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlRegWrite    <= 1;
                ctrlImmExtend   <= `EXT_MODE_UNSIGNED;
            end

            `INSTR_OP_ORI: begin
                ctrlRegDst      <= `SEL_REGDST_RT;
                ctrlMemToReg    <= `SEL_WB_ALUOUT;
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_OR;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlRegWrite    <= 1;
                ctrlImmExtend   <= `EXT_MODE_UNSIGNED;
            end

            `INSTR_OP_LUI: begin
                ctrlRegDst      <= `SEL_REGDST_RT;
                ctrlMemToReg    <= `SEL_WB_ALUOUT;
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_LUI;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlRegWrite    <= 1;
                ctrlImmExtend   <= `EXT_MODE_UNSIGNED;
            end

            `INSTR_OP_XORI: begin
                ctrlRegDst      <= `SEL_REGDST_RT;
                ctrlMemToReg    <= `SEL_WB_ALUOUT;
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_XOR;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlRegWrite    <= 1;
                ctrlImmExtend   <= `EXT_MODE_UNSIGNED;
            end

            `INSTR_OP_SW: begin
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_ADD;
                ctrlMemWrite    <= 1;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlImmExtend   <= `EXT_MODE_SIGNED;
            end

            `INSTR_OP_LW: begin
                ctrlRegDst      <= `SEL_REGDST_RT;
                ctrlMemRead     <= 1'b0;
                ctrlMemToReg    <= `SEL_WB_DM;
                ctrlALUOp       <= `CtrlALUOp_EXFUNCT;
                ctrlALUExtOp    <= `ALUOp_ADD;
                ctrlMemRead     <= 1;
                ctrlALUSrc      <= `SEL_ALUSRC_IMM;
                ctrlRegWrite    <= 1;
                ctrlImmExtend   <= `EXT_MODE_SIGNED;
            end

            // Unkown OpCode
            default: begin
                // $display("Got an unknown opcode: %x", opcode);
            end
        endcase
    end
endmodule

module ALUCtrl (
    input wire [2:0] ctrlALUOp,
    input wire [5:0] funct,
    input wire [4:0] aluExtOp,
    output wire [4:0] outALUOp
);

    reg [4:0] tempFunct;

    always @(*) begin
       case (ctrlALUOp)
           `CtrlALUOp_FUNCT: begin
               case (funct)
                   `INSTR_FUNCT_ADD: tempFunct <= `ALUOp_ADD;
               endcase
           end
           `CtrlALUOp_EXFUNCT: tempFunct <= aluExtOp;
       endcase 
    end

    assign outALUOp = tempFunct;

endmodule

`endif