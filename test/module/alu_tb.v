`include "../../alu.v"
`include "../../constants.v"

// `timescale 50ns/10ns

module alu_tb ();

    reg clk;

    always begin
        clk <= ~clk;
        #1;
    end

    initial begin
        $display("alu_tb Start....");
        $monitor("Result = %x", alu.out);

        clk <= 1'b0;
        
        // 初始化操作数
        aluSrc1 <= 32'h00000002;
        aluSrc2 <= 32'h00000001;

        @(posedge clk);
        aluOp <= `ALUOp_ADD;

        @(posedge clk)
        aluOp <= `ALUOp_SUB;

        @(posedge clk)
        $finish;
    end

    reg [`WORD_WIDTH-1: 0] aluSrc1;
    reg [`WORD_WIDTH-1: 0] aluSrc2;
    reg [5: 0] aluOp;

    wire [`WORD_WIDTH-1: 0] aluOut;
    wire aluZero;


    ALU alu(
        aluSrc1,
        aluSrc2,
        aluOp,
        aluOut,
        aluZero
    );


endmodule