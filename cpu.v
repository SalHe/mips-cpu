`ifndef _CPU_V_
`define _CPU_V_

`timescale 100ns/1ps

`include "im.v"
`include "regfile.v"
`include "mux.v"
`include "ctrl.v"
`include "alu.v"
`include "dm.v"
`include "extend.v"
`include "npc.v"
`include "pipeline_reg.v"

module CPU #(
    parameter IM_DATA_FILE = "im_data.txt"
)(
    input wire clk,
    input wire reset
);
    
    // 控制信号
    wire [1:0] ctrlRegDst;
    wire [1:0] ctrlNPCFrom;
    wire ctrlMemRead;
    wire [1:0] ctrlMemToReg;
    wire [2:0] ctrlALUOp;
    wire [4:0] aluExtOp;
    wire ctrlMemWrite;
    wire ctrlALUSrc1;
    wire ctrlALUSrc2;
    wire ctrlRegWrite;
    wire ctrlImmExtendMode;
    wire branchTestResult;

    // -----------------------------------------------------------------
    // Stage IF

    // PC
    wire reg [31:0] PC;
    wire [31:0] PC4;
    wire [31:0] code;

    // 分析指令
    // | Bit#  | 31..26 | 25..21 | 20..16 | 15..11 | 10..6 | 5..0 |
    // | Rtype | opcode | rs     | rt     | rd     | shamt | func |
    // | Itype | opcode | rs     | rt     | imm                   |
    // | Jtype | opcode | address                                 |
    wire [5: 0]  opcode;
    wire [4: 0]  rs, rt, rd;
    wire [15: 0] imm;
    wire [4: 0]  shamt;
    wire [25: 0] jaddrOri;
    wire [5:0]   func;

    wire [`WORD_WIDTH-1: 0] regOutData1;
    NPC npc(clk, ctrlNPCFrom, branchTestResult, PC, regOutData1, imm, jaddrOri, PC4, PC);

    // 取指令
    IM #(.IM_DATA_FILE(IM_DATA_FILE)) 
        im(clk, PC, code);


    // IF/ID
    wire [31: 0] PC4_IF_ID;
    wire [31: 0] code_IF_ID;
    PipelineReg #(.WIDTH(64))
        PipelineReg_IF_ID(clk, reset,
            {PC4,       code},
            {PC4_IF_ID, code_IF_ID}
        );

    // -----------------------------------------------------------------
    // Stage ID

    assign opcode   = code_IF_ID[31:26];
    assign rs       = code_IF_ID[25:21];
    assign rt       = code_IF_ID[20:16];
    assign rd       = code_IF_ID[15:11];
    assign shamt    = code_IF_ID[10:6];
    assign func     = code_IF_ID[5:0];
    assign imm      = code_IF_ID[15:0];
    assign jaddrOri = code_IF_ID[25:0];

    // 控制信号
    Ctrl ctrl(
           opcode,
           func,
           ctrlRegDst,
           ctrlNPCFrom,
           ctrlMemRead,
           ctrlMemToReg,
           ctrlALUOp,
           aluExtOp,
           ctrlMemWrite,
           ctrlALUSrc1,
           ctrlALUSrc2,
           ctrlRegWrite,
           ctrlImmExtendMode
    );

    // 选择写寄存器
    wire [4: 0] regWriteAddr_Final; // assign ... = ..._MEM_WB
    wire [`WORD_WIDTH-1: 0] dataWriteToReg_Final; // assign ... = ..._MEM_WB
    wire ctrlRegWrite_Final; // assign ... = ..._MEM_WB

    // 与寄存器相连
    // wire [`WORD_WIDTH-1: 0] regOutData1; //向前定义了
    wire [`WORD_WIDTH-1: 0] regOutData2;
    RegFile regFile(
        clk,             // Clock

        rs, rt,          // Read Addr

        regWriteAddr_Final,    // Write Addr
        dataWriteToReg_Final,  // Data to write
        ctrlRegWrite_Final,     // Whether to write

        regOutData1,     // Out data
        regOutData2
    );

    // 符号扩展
    wire [`WORD_WIDTH-1: 0] immSignedExtended;
    // assign immSignedExtended = {{16{imm[15]}}, imm};
    // assign aluSrc1 = regOutData1;
    Extend immExter(imm, ctrlImmExtendMode, immSignedExtended);
    
    // Pipeline
    wire [1:0] ctrlRegDst_ID_EX;
    wire ctrlRegWrite_ID_EX;
    wire [1:0] ctrlMemToReg_ID_EX;

    wire [1:0] ctrlNPCFrom_ID_EX;
    wire ctrlMemRead_ID_EX;
    wire ctrlMemWrite_ID_EX;

    wire [2:0] ctrlALUOp_ID_EX;
    wire [4:0] aluExtOp_ID_EX;
    wire ctrlALUSrc1_ID_EX;
    wire ctrlALUSrc2_ID_EX;

    wire [`WORD_WIDTH-1: 0] regOutData1_ID_EX;
    wire [`WORD_WIDTH-1: 0] regOutData2_ID_EX;
    wire [`WORD_WIDTH-1: 0] immSignedExtended_ID_EX;

    wire [4: 0] rt_ID_EX;
    wire [4: 0] rd_ID_EX;

    wire [5: 0] func_ID_EX;

    wire [`WORD_WIDTH-1: 0] PC4_ID_EX;

    PipelineReg #(.WIDTH(163))
        PipelineReg_ID_EX(clk, reset,

            // From previous stage

            {
                // WB from Control
                ctrlRegDst,
                ctrlRegWrite,
                ctrlMemToReg,

                // WB RegDst
                rt,
                rd,

                // MEM from Control
                ctrlNPCFrom,
                ctrlMemRead,
                ctrlMemWrite,

                // EX from Control
                ctrlALUOp,
                aluExtOp,
                ctrlALUSrc1,
                ctrlALUSrc2,

                // Others
                PC4_IF_ID,
                regOutData1,
                regOutData2,
                immSignedExtended,
                func
            },
            
            // Next stage(EX)
            {
                
                // WB from Control
                ctrlRegDst_ID_EX,
                ctrlRegWrite_ID_EX,
                ctrlMemToReg_ID_EX,

                // WB RegDst
                rt_ID_EX,
                rd_ID_EX,

                // MEM from Control
                ctrlNPCFrom_ID_EX,
                ctrlMemRead_ID_EX,
                ctrlMemWrite_ID_EX,

                // EX from Control
                ctrlALUOp_ID_EX,
                aluExtOp_ID_EX,
                ctrlALUSrc1_ID_EX,
                ctrlALUSrc2_ID_EX,

                // Others
                PC4_ID_EX,
                regOutData1_ID_EX,
                regOutData2_ID_EX,
                immSignedExtended_ID_EX,
                func_ID_EX
            }
        
        );

    // -----------------------------------------------------------------
    // Stage EX

    // 给ALU提供源操作数
    wire [`WORD_WIDTH-1: 0] aluSrc1;
    wire [`WORD_WIDTH-1: 0] aluSrc2;
    MUX2 #(.SEL_WIDTH(1)) 
        muxALUSrc1(
            regOutData1_ID_EX, 
            immSignedExtended_ID_EX,
            ctrlALUSrc1_ID_EX,
            aluSrc1
        );
    MUX2 #(.SEL_WIDTH(1)) 
        muxALUSrc2(
            regOutData2_ID_EX,
            immSignedExtended_ID_EX,
            ctrlALUSrc2_ID_EX,
            aluSrc2
        );

    // 选择写寄存器
    wire [4: 0] regWriteAddr;
    wire [4: 0] regWriteAddr_EX_MEM;
    MUX2C #(.WORD_WIDTH(5), .CONSTANT(31)) 
        muxRegDst(
            rt_ID_EX, rd_ID_EX,
            ctrlRegDst_ID_EX,
            regWriteAddr
        );

    // ALU运算
    wire [`WORD_WIDTH-1: 0] aluOut;
    wire [4: 0] aluOp;
    wire aluTestResult;
    assign branchTestResult = aluTestResult;
    ALUCtrl aluCtrl(ctrlALUOp_ID_EX, func_ID_EX, aluExtOp_ID_EX, aluOp);                 // ALU功能选择
    ALU alu(aluSrc1, aluSrc2, aluOp, aluOut, aluTestResult);   // ALU运算

    // Pipeline
    wire [1:0] ctrlRegDst_EX_MEM;
    wire ctrlRegWrite_EX_MEM;
    wire [1:0] ctrlMemToReg_EX_MEM;

    wire [1:0] ctrlNPCFrom_EX_MEM;
    wire ctrlMemRead_EX_MEM;
    wire ctrlMemWrite_EX_MEM;

    wire [`WORD_WIDTH-1: 0] PC4_EX_MEM;
    wire branchTestResult_EX_MEM;
    wire [`WORD_WIDTH-1: 0] aluOut_EX_MEM;
    wire [`WORD_WIDTH-1: 0] regOutData2_EX_MEM;
    
    PipelineReg #(.WIDTH(111))
        PipelineReg_EX_MEM(clk, reset,

            // From previous stage

            {
                // WB from Control
                ctrlRegDst_ID_EX,
                ctrlRegWrite_ID_EX,
                ctrlMemToReg_ID_EX,

                // MEM from Control
                ctrlNPCFrom_ID_EX,
                ctrlMemRead_ID_EX,
                ctrlMemWrite_ID_EX,

                // Others
                PC4_ID_EX,
                branchTestResult,
                aluOut,
                regOutData2,
                regWriteAddr
            },
            
            // Next stage(EX)
            {
                // WB from Control
                ctrlRegDst_EX_MEM,
                ctrlRegWrite_EX_MEM,
                ctrlMemToReg_EX_MEM,

                // MEM from Control
                ctrlNPCFrom_EX_MEM,
                ctrlMemRead_EX_MEM,
                ctrlMemWrite_EX_MEM,

                // Others
                PC4_EX_MEM,
                branchTestResult_EX_MEM,
                aluOut_EX_MEM,
                regOutData2_EX_MEM,
                regWriteAddr_EX_MEM
            }
        
        );

    // -----------------------------------------------------------------
    // Stage MEM

    // RAM
    wire [`WORD_WIDTH-1: 0] memOutData;
    DM dm(
        clk,

        aluOut_EX_MEM,             // Mem Addr
        regOutData2_EX_MEM,        // Data to write

        ctrlMemWrite_EX_MEM,       // 写使能
        ctrlMemRead_EX_MEM,        // 读使能

        memOutData          // 读出的数据

    );

    // Pipeline
    wire [1:0] ctrlRegDst_MEM_WB;
    wire ctrlRegWrite_MEM_WB;
    wire [1:0] ctrlMemToReg_MEM_WB;

    wire [1:0] ctrlNPCFrom_MEM_WB;

    wire [2:0] ctrlALUOp_MEM_WB;
    wire [4:0] aluExtOp_MEM_WB;
    wire ctrlALUSrc1_MEM_WB;
    wire ctrlALUSrc2_MEM_WB;

    wire [`WORD_WIDTH-1: 0] PC4_MEM_WB;
    wire [`WORD_WIDTH-1: 0] aluOut_MEM_WB;
    wire [`WORD_WIDTH-1: 0] regOutData2_MEM_WB;
    wire [4: 0] regWriteAddr_MEM_WB;
    wire [`WORD_WIDTH-1: 0] memOutData_MEM_WB;
    
    PipelineReg #(.WIDTH(140))
        PipelineReg_MEM_WB(clk, reset,

            // From previous stage

            {
                // WB from Control
                ctrlRegDst_EX_MEM,
                ctrlRegWrite_EX_MEM,
                ctrlMemToReg_EX_MEM,

                // MEM from Control
                ctrlNPCFrom_EX_MEM,

                // Others
                PC4_EX_MEM,
                aluOut_EX_MEM,
                regOutData2_EX_MEM,
                regWriteAddr_EX_MEM,
                memOutData
            },
            
            // Next stage(EX)
            {
                // WB from Control
                ctrlRegDst_MEM_WB,
                ctrlRegWrite_MEM_WB,
                ctrlMemToReg_MEM_WB,

                // MEM from Control
                ctrlNPCFrom_MEM_WB,

                // Others
                PC4_MEM_WB,
                aluOut_MEM_WB,
                regOutData2_MEM_WB,
                regWriteAddr_MEM_WB,
                memOutData_MEM_WB
            }
        
        );



    // -----------------------------------------------------------------
    // Stage WB

    // 需要回写的数据
    MUX3 muxDataToReg(
            aluOut_MEM_WB,
            memOutData_MEM_WB,
            PC4_MEM_WB,
            ctrlMemToReg_MEM_WB,
            dataWriteToReg_Final
        );

    assign regWriteAddr_Final = regWriteAddr_MEM_WB;
    assign ctrlRegWrite_Final = ctrlRegWrite_MEM_WB;


endmodule

`endif