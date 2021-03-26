`ifndef _HAZARD_V_
`define _HAZARD_V_

`include "npc.v"

module HazardDetect (
    input wire ctrlMemRead_ID_EX,
    input wire [1:0] ctrlNPCFrom_Final,

    input wire [4:0] rt_ID_EX,
    input wire [4:0] rs_IF_ID,
    input wire [4:0] rt_IF_ID,

    output reg ctrlStall,
    output reg rollback_IF_ID_EX
);
    
    always @(*) begin
        if(ctrlMemRead_ID_EX
            && (rt_ID_EX == rt_IF_ID
            || rt_ID_EX == rs_IF_ID)
        )
            ctrlStall <= 1;
        else
            ctrlStall <= 0;
    end

    always @(*) begin
        if(ctrlNPCFrom_Final != `NPC_PC4)
            rollback_IF_ID_EX <= 1;
        else
            rollback_IF_ID_EX <= 0;
    end


endmodule

`endif