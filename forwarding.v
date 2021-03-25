`ifndef _FORWARDING_V_
`define _FORWARDING_V_

`include "mux.v"
`include "ctrl.v"

module Forwarding (
    input  wire [4: 0] rs,
    input  wire [4: 0] rt,

    input  wire [1:0] ctrlALUSrc1_ID_EX,
    input  wire [1:0] ctrlALUSrc2_ID_EX,

    input  wire        ctrlRegWrite_EX_MEM,
    input  wire        ctrlRegWrite_MEM_WB,

    input  wire [4: 0] rd_EX_MEM,
    input  wire [4: 0] rd_MEM_WB,
    
    output wire [1: 0] selAluSrc1,   // rs
    output wire [1: 0] selAluSrc2    // rt
);

    reg [1: 0] sel1;
    reg [1: 0] sel2;

    always @(*) begin
        if(rs == rd_EX_MEM && ctrlRegWrite_EX_MEM)
            sel1 <= `SEL_ALUSRC_EX;
        else if(rs == rd_MEM_WB && ctrlRegWrite_MEM_WB)
            sel1 <= `SEL_ALUSRC_WB;
        else
            sel1 <= ctrlALUSrc1_ID_EX;    
    end

    always @(*) begin
        if(rt == rd_EX_MEM && ctrlRegWrite_EX_MEM && ctrlALUSrc2_ID_EX != `SEL_ALUSRC_IMM)
            sel2 <= `SEL_ALUSRC_EX;
        else if(rt == rd_MEM_WB && ctrlRegWrite_MEM_WB && ctrlALUSrc2_ID_EX != `SEL_ALUSRC_IMM)
            sel2 <= `SEL_ALUSRC_WB;
        else
            sel2 <= ctrlALUSrc2_ID_EX;    
    end

    assign selAluSrc1 = sel1;
    assign selAluSrc2 = sel2;
    
endmodule

`endif