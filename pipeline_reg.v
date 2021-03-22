`ifndef _PIPELINE_REG_V
`define _PIPELINE_REG_V

module PipelineReg #(
    parameter WIDTH = 1
) (
    input wire clk,
    input wire reset,
    input wire toSave,
    output reg holder
);

    always @(posedge clk ) begin
        if(reset)
            holder <= 0;
        else
            holder <= toSave;
    end
    
endmodule

`endif