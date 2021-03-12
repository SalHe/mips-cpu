`ifndef _EXTEND_V_
`define _EXTEND_V_

`define EXT_MODE_UNSIGNED    1'b0
`define EXT_MODE_SIGNED      1'b1

module Extend (
    input wire [15:0]   imm,
    input wire          extMode,
    output reg [31:0]   out
);
    always @(*) begin
        case (extMode)
            `EXT_MODE_UNSIGNED: out <= {{16{1'b0}},     imm[15:0]};
            `EXT_MODE_SIGNED:   out <= {{16{imm[15]}},  imm[15:0]};
        endcase
    end
endmodule

`endif