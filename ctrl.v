`ifndef _CTRL_V_
`define _CTRL_V_

module Ctrl (
    input wire [5: 0] opcode,

    output wire ctrlRegDst,
    output wire ctrlBranch,
    output wire ctrlMemRead,
    output wire ctrlMemToReg,
    output wire [1:0] ctrlALUOp,
    output wire ctrlMemWrite,
    output wire ctrlALUSrc,
    output wire ctrlRegWrite
);
    // always @(*) begin
        
    // end
endmodule

`define ALUOp_CALC_MEM_ADDRESS       2'b00
`define ALUOp_CALC_BRANCH_ADDRESS    2'b10
`define ALUOp_FUNCT_FROM_INSTRUCTION 2'b10

module ALUCtrl (
    input wire [1:0] ALUOp,
    input wire [5:0] funct,
    output wire [5:0] outFunct
);

    reg [5:0] tempFunct;

    always @(*) begin
       case (ALUOp)
           // `ALUOp_CALC_MEM_ADDRESS:
           // `ALUOp_CALC_BRANCH_ADDRESS: 
           `ALUOp_FUNCT_FROM_INSTRUCTION: tempFunct = funct;
           default: tempFunct = funct;
       endcase 
    end

    assign outFunct = tempFunct;

endmodule

`endif