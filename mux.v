`ifndef _MUX_V_
`define _MUX_V_

`include "constants.v"

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

`endif