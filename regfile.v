`ifndef _REGFILE_V_
`define _REGFILE_V_


`include "constants.v"

module RegFile #(
    parameter WORD_WIDTH = `WORD_WIDTH
)(
    input clk,

    input [4:0] regReadAddr1,
    input [4:0] regReadAddr2,

    input wire [4:0] regWriteAddr,
    input wire [`WORD_WIDTH-1:0] dataToWrite,
    input toWrite,

    output [`WORD_WIDTH-1:0] outA,
    output [`WORD_WIDTH-1:0] outB
);

    reg [`WORD_WIDTH-1:0] registers[5: 0];
    reg [`WORD_WIDTH-1:0] data1, data2;

    initial begin
        `ifdef DEBUG_CPU
			$display("     $v0,      $v1,      $t0,      $t1,      $t2,      $t3,      $t4,      $t5,      $t6,      $t7");
			$monitor("%x, %x, %x, %x, %x, %x, %x, %x, %x, %x",
					registers[2][31:0],	/* $v0 */
					registers[3][31:0],	/* $v1 */
					registers[8][31:0],	/* $t0 */
					registers[9][31:0],	/* $t1 */
					registers[10][31:0],	/* $t2 */
					registers[11][31:0],	/* $t3 */
					registers[12][31:0],	/* $t4 */
					registers[13][31:0],	/* $t5 */
					registers[14][31:0],	/* $t6 */
					registers[15][31:0],	/* $t7 */
				);   
        `endif 
    end


    always @(*) begin
        if (regReadAddr1 == 0)
            data1 = 0;
        else
            data1 = registers[regReadAddr1];
    end
    
    always @(*) begin
        if (regReadAddr2 == 0)
            data2 = 0;
        else
            data2 = registers[regReadAddr2];
    end

    assign outA = data1;
    assign outB = data2;
    
    always @(posedge clk) begin
        if (toWrite) 
            registers[regWriteAddr] <= dataToWrite;            
    end

endmodule

`endif