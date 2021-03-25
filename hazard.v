`ifndef _HAZARD_V_
`define _HAZARD_V_

module HazardDetect (
    input wire ctrlMemRead_ID_EX,

    input wire [4:0] rt_ID_EX,
    input wire [4:0] rs_IF_ID,
    input wire [4:0] rt_IF_ID,

    output reg ctrlStall
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


endmodule

`endif