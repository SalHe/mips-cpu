`ifndef _IM_V_
`define _IM_V_

module IM #(
    parameter MEM_SIZE = 1024,
    parameter IM_DATA_FILE = "im_data.txt"
) (
    input wire clk,
    input wire [31: 0] PC,
    output reg [31: 0] code
);

    reg [31: 0] imMem[MEM_SIZE-1: 0];

    initial begin
        $readmemh(IM_DATA_FILE, imMem, 0, MEM_SIZE-1);
    end

    always @(posedge clk) begin
        code <= imMem[PC[31:2]];
    end

endmodule

`endif