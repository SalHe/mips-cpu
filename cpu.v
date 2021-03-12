`ifndef _CPU_V_
`define _CPU_V_

`timescale 100ns/1ps

`include "im.v"
`include "regfile.v"
`include "mux.v"
`include "ctrl.v"
`include "alu.v"
`include "dm.v"

module CPU #(
    parameter IM_DATA_FILE = "im_data.txt"
)(
    input wire clk
);

    reg [31:0] PC;
    wire [31:0] PC4;
    wire [31:0] code;

    // 初始化
    initial begin
        PC <= 0;
    end

    assign PC4 = PC + 4;

    always @(posedge clk) begin
        PC <= PC4;
    end

    // 取指令
    IM #(.IM_DATA_FILE(IM_DATA_FILE)) 
        im(clk, PC, code);

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

    assign opcode   = code[31:26];
    assign rs       = code[25:21];
    assign rt       = code[20:16];
    assign rd       = code[15:11];
    assign shamt    = code[10:6];
    assign func     = code[5:0];
    assign imm      = code[15:0];
    assign jaddrOri = code[25:0];

    // 控制信号
    wire ctrlRegDst;
    wire ctrlBranch;
    wire ctrlMemRead;
    wire ctrlMemToReg;
    wire [1:0] ctrlALUOp;
    wire ctrlMemWrite;
    wire ctrlALUSrc;
    wire ctrlRegWrite;
    Ctrl ctrl(
           opcode,
           ctrlRegDst,
           ctrlBranch,
           ctrlMemRead,
           ctrlMemToReg,
           ctrlALUOp,
           ctrlMemWrite,
           ctrlALUSrc,
           ctrlRegWrite
    );

    // 选择写寄存器
    wire [4: 0] regWriteAddr;
    MUX2 #(.WORD_WIDTH(5), .SEL_WIDTH(1)) 
        muxRegDst(
            rt, rd,         // in
            RegDst,         // sel
            regWriteAddr    // out
        );

    // 与寄存器相连
    wire [`WORD_WIDTH-1: 0] dataToWriteReg;
    wire [`WORD_WIDTH-1: 0] regOutData1;
    wire [`WORD_WIDTH-1: 0] regOutData2;
    RegFile regFile(
        clk,             // Clock

        rs, rt,          // Read Addr

        regWriteAddr,    // Write Addr
        dataToWriteReg,  // Data to write
        ctrlRegWrite,     // Whether to write

        regOutData1,     // Out data
        regOutData2
    );

    // 给ALU提供源操作数
    wire [`WORD_WIDTH-1: 0] aluSrc1;
    wire [`WORD_WIDTH-1: 0] aluSrc2;
    wire [`WORD_WIDTH-1: 0] immSignedExtended;
    assign immSignedExtended = {{16{imm[15]}}, imm};
    
    assign aluSrc2 = regOutData1;
    MUX2 #(.SEL_WIDTH(1)) 
        muxALUSrc(
            regOutData2, 
            immSignedExtended,
            ctrlALUSrc,
            aluSrc2
        );

    // ALU运算
    wire [`WORD_WIDTH-1: 0] aluOut;
    wire [5: 0] aluFunct;
    wire aluZeroSign;
    ALUCtrl aluCtrl(ctrlALUOp, func, aluFunct);                 // ALU功能选择
    ALU alu(aluSrc1, aluSrc2, aluFunct, aluOut, aluZeroSign);   // ALU运算

    // RAM
    wire [`WORD_WIDTH-1: 0] memOutData;
    DM dm(
        clk,

        aluOut,             // Mem Addr
        regOutData2,        // Data to write

        ctrlMemWrite,       // 写使能
        ctrlMemRead,        // 读使能

        memOutData          // 读出的数据

    );

    // 需要回写的数据
    MUX2 #(.WORD_WIDTH(`WORD_WIDTH), .SEL_WIDTH(1))
        muxDataToReg(
            aluOut,
            memOutData,
            ctrlMemToReg,
            dataToWriteReg
        );

endmodule

`endif