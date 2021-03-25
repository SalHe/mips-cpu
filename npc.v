`ifndef _NPC_V_
`define _NPC_V_

`define NPC_PC4     2'b00
`define NPC_BRANCH  2'b01
`define NPC_JMP     2'b10
`define NPC_REG     2'b11

module NPC(
    input wire clk,
    input wire [1:0] nPCFrom,
    input wire branchTest,
    input wire stall,
    input wire [31:0] PC,
    input wire [31:0] regOutData,
    input wire [15:0] imm,
    input wire [25:0] jAddr,
    output wire [31:0] PC4,
    output wire [31:0] nPC
);
    reg [31:0] newPC;

    initial begin
        newPC <= 0;
    end

    assign PC4 = PC + 4;

    always @(posedge clk) begin
        if (stall)
            newPC <= PC;
        else
            case (nPCFrom)
                `NPC_BRANCH: begin
                    if (branchTest)
                        newPC <= PC4 + $signed({{16{imm[15]}}, imm[15:0]} << 2);
                    else
                        newPC <= PC4;
                end 
                `NPC_JMP: newPC <= {newPC[31:28], jAddr[25:0], 2'b00};
                `NPC_REG: newPC <= regOutData;
                `NPC_PC4: newPC <= PC4;
                default: newPC <= PC4;
            endcase
    end

    assign nPC = newPC;

endmodule

`endif