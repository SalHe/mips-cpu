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

    // TODO:
    // 跟着书上的分析走了一遍
    // 存在一种连续旁路的情况(我暂且这么称呼这种情况)
    // 例如下列的指令序列：
    // add     $v0, $v0, $t1
    // add     $v0, $v0, $t2
    // add     $v0, $v0, $t3
    // add     $v0, $v0, $t4
    // $v0的最新结果是在MEM级中
    // 所以此时旁路数据应来自MEM级
    // 而按照现有的逻辑会来自EX级
    // 那么应该加入额外的处理代码（《计组》P210）
    //
    // 但是我加
    // 依旧正常工作
    //
    // 我仔细想了一下
    // 既然是上述指令序列的连续旁路
    // 那么$v0的最新结果还是在EX级中ALU的运算结果中
    // 所以书上给的额外的代码暂时没做处理 后面再看

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