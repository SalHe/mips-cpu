`ifndef _CPU_TB_V_
`define _CPU_TB_V_

`include "../../cpu.v"

`define CYCLE_NUMS 10

module cpu_tb ();

    integer i = 0;
    reg clk;

    CPU mipsCpu(clk);
    
    initial begin

        clk <= 0;

        $monitor("PC = %x", mipsCpu.PC);

        // 让其执行指定周期数（用做测试）
        for (i = 0; i < `CYCLE_NUMS; i++) begin
            @(posedge clk);
        end

        $finish;
    end

    always begin
        #5 clk <= ~clk;
    end

endmodule

`endif