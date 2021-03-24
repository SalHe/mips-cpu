`ifndef _PIPELINE_REG_V
`define _PIPELINE_REG_V

module PipelineReg #(
    parameter WIDTH = 1
) (
    input wire clk,
    input wire reset,
    input wire [WIDTH-1: 0] toSave,
    output reg [WIDTH-1: 0] holder
);

    always @(posedge clk ) begin
        if(reset)
            holder <= 0;
        else
            holder <= toSave;
    end
    
endmodule

`endif