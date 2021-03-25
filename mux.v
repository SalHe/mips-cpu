`ifndef _MUX_V_
`define _MUX_V_

`include "constants.v"

`define SEL_REGDST_RT   2'b00   // 写回到指令中指定的rt号寄存器
`define SEL_REGDST_RD   2'b01   // 写回到指令中指定的rd号寄存器
`define SEL_REGDST_RA   2'b10   // 写回到$ra（31号寄存器）

`define SEL_ALUSRC_REG  2'b00   // 以指令中给定的源寄存器号中的内容作为操作数2
`define SEL_ALUSRC_IMM  2'b01   // 以指令中给定的立即数作为操作数2
`define SEL_ALUSRC_EX   2'b10
`define SEL_ALUSRC_WB   2'b11

`define SEL_WB_ALUOUT   2'b00   // 将ALU运算结果写回
`define SEL_WB_DM       2'b01   // 将DM读出的结果写回
`define SEL_WB_PC4      2'b10   // 将PC4写回

module MUX2 #(
    parameter WORD_WIDTH = `WORD_WIDTH,
    parameter SEL_WIDTH = 1
)(
    input wire [WORD_WIDTH-1: 0] inA,
    input wire [WORD_WIDTH-1: 0] inB,

    input wire [SEL_WIDTH-1: 0] sel,

    output wire [WORD_WIDTH-1: 0] out
);

    reg [WORD_WIDTH-1: 0] data;

    always @(*) begin
        case (sel)
            1'b0: data = inA;
            1'b1: data = inB;
        endcase
    end

    assign out = data;
endmodule

module MUX2C #(
    parameter WORD_WIDTH = `WORD_WIDTH,
    parameter SEL_WIDTH = 2,
    parameter CONSTANT = 29     // A number I like but not fixed
)(
    input wire [WORD_WIDTH-1: 0] inA,
    input wire [WORD_WIDTH-1: 0] inB,

    input wire [SEL_WIDTH-1: 0] sel,

    output wire [WORD_WIDTH-1: 0] out
);

    reg [WORD_WIDTH-1: 0] data;

    always @(*) begin
        case (sel)
            2'b00: data = inA;
            2'b01: data = inB;
            default: data = CONSTANT;
        endcase
    end

    assign out = data;
endmodule

module MUX3 #(
    parameter WORD_WIDTH = `WORD_WIDTH,
    parameter SEL_WIDTH = 2
)(
    input wire [WORD_WIDTH-1: 0] inA,
    input wire [WORD_WIDTH-1: 0] inB,
    input wire [WORD_WIDTH-1: 0] inC,

    input wire [SEL_WIDTH-1: 0] sel,

    output wire [WORD_WIDTH-1: 0] out
);

    reg [WORD_WIDTH-1: 0] data;

    always @(*) begin
        case (sel)
            2'b00: data = inA;
            2'b01: data = inB;
            2'b10: data = inC;
        endcase
    end

    assign out = data;
endmodule

module MUX4 #(
    parameter WORD_WIDTH = `WORD_WIDTH,
    parameter SEL_WIDTH = 2
)(
    input wire [WORD_WIDTH-1: 0] inA,
    input wire [WORD_WIDTH-1: 0] inB,
    input wire [WORD_WIDTH-1: 0] inC,
    input wire [WORD_WIDTH-1: 0] inD,

    input wire [SEL_WIDTH-1: 0] sel,

    output wire [WORD_WIDTH-1: 0] out
);

    reg [WORD_WIDTH-1: 0] data;

    always @(*) begin
        case (sel)
            2'b00: data <= inA;
            2'b01: data <= inB;
            2'b10: data <= inC;
            2'b11: data <= inD;
        endcase
    end

    assign out = data;
endmodule

`endif