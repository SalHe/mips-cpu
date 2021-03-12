`ifndef _CPU_TB_V_
`define _CPU_TB_V_

`include "../../cpu.v"

module cpu_tb ();

    integer i = 0;
    reg clk;

    CPU #(`IM_DATA_FILE)
        mipsCpu(clk);
    
    always begin
        clk <= ~clk;
        #5;
    end

    initial begin
        $dumpfile(`DUMP_FILE);
        $dumpvars(0, cpu_tb);

        clk <= 0;

        // $monitor("PC = %x, CODE = %x, OpCode = %x, ALUSrc1 = %x, ALUSrc2 = %x, ALUOut = %x, WB = %x, WBData = %x, RegWrite = %x", 
        //     mipsCpu.PC, mipsCpu.code, mipsCpu.opcode, 
        //     mipsCpu.aluSrc1, mipsCpu.aluSrc2, mipsCpu.aluOut,
        //     mipsCpu.ctrlRegWrite, mipsCpu.dataWriteToReg, mipsCpu.regWriteAddr
        // );

        // 让其执行指定周期数（用做测试）
        for (i = 0; i < `INS_NUMS; i++) begin
            @(posedge clk);
        end

        $finish;
    end

endmodule

`endif