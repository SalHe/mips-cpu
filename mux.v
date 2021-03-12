`ifndef _MUX_V_
`define _MUX_V_

`include "constants.v"

module MUX2 #(
    parameter WORD_WIDTH = `WORD_WIDTH,
    parameter SEL_WIDTH =5
)(
    input wire [WORD_WIDTH-1: 0] inA,
    input wire [WORD_WIDTH-1: 0] inB,

    input wire [SEL_WIDTH-1: 0] sel,

    output wire [WORD_WIDTH-1: 0] out
);

    reg [WORD_WIDTH-1: 0] data;

    always @(*) begin
        if (sel == 0) 
            data = inA;
        else if(sel == 1) 
            data = inB;
        else 
            data = inA;
    end

    assign out = data;
endmodule

`endif