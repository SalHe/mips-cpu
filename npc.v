`ifndef _NPC_V_
`define _NPC_V_

module NPC(
    input wire clk,
    input wire isBranch,
    input wire branchTest,
    input wire [31:0] PC,
    input wire [15:0] imm,
    output wire [31:0] PC4,
    output wire [31:0] nPC
);
    reg [31:0] newPC;

    initial begin
        newPC <= 0;
    end

    assign PC4 = PC + 4;

    always @(posedge clk) begin
        if (isBranch && branchTest)begin
            newPC <= PC4 + $signed({{16{imm[15]}}, imm[15:0]} << 2);
        end
        else
            newPC <= PC4;
    end

    assign nPC = newPC;

endmodule

`endif