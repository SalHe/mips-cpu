`ifndef _DM_V_
`define _DM_V_

`include "constants.v"

module DM #(
    parameter MEM_SIZE = 128,
    parameter WORD_WIDTH = `WORD_WIDTH
) (
    input wire clk,

    input wire [WORD_WIDTH-1: 0] memAddr,
    input wire [WORD_WIDTH-1: 0] dataToWrite,

    input wire toWrite,
    input wire toRead,

    output wire [WORD_WIDTH-1: 0] outData
);
    
    reg [WORD_WIDTH-1: 0] mem[MEM_SIZE-1: 0]; 

    always @(posedge clk) begin
        if (toWrite) begin
            `ifdef DEBUG_CPU
                $display("ARM Before Write: [%X] = %X", memAddr, mem[memAddr]);
            `endif
            mem[memAddr] = dataToWrite;
            `ifdef DEBUG_CPU
                $display("ARM After Write: [%X] = %X", memAddr, mem[memAddr]);
            `endif
        end
    end
    
    assign outData = mem[memAddr];

endmodule

`endif