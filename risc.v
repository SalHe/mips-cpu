// OP Code
`define INSTR_OP_RTYPE      6'b000000

`define INSTR_OP_LB         6'b100000
`define INSTR_OP_LH         6'b100001
`define INSTR_OP_LBU        6'b100100
`define INSTR_OP_LHU        6'b100101
`define INSTR_OP_LW         6'b100011

`define INSTR_OP_SB         6'b101000
`define INSTR_OP_SH         6'b101001
`define INSTR_OP_SW         6'b101011

`define INSTR_OP_ADDI       6'b001000
`define INSTR_OP_ADDIU      6'b001001
`define INSTR_OP_ANDI       6'b001100
`define INSTR_OP_ORI        6'b001101
`define INSTR_OP_XORI       6'b001110
`define INSTR_OP_LUI        6'b001111
`define INSTR_OP_SLTI       6'b001010
`define INSTR_OP_SLTIU      6'b001011

`define INSTR_OP_BEQ        6'b000100
`define INSTR_OP_BNE        6'b000101
`define INSTR_OP_BGEZ       6'b000001
`define INSTR_OP_BGTZ       6'b000111
`define INSTR_OP_BLEZ       6'b000110
`define INSTR_OP_BLTZ       6'b000001

`define INSTR_OP_J          6'b000010
`define INSTR_OP_JAL        6'b000011

// Funct
`define INSTR_FUNCT_ADD     6'b100000
`define INSTR_FUNCT_ADDU    6'b100001
`define INSTR_FUNCT_SUB     6'b100010
`define INSTR_FUNCT_SUBU    6'b100011
`define INSTR_FUNCT_AND     6'b100100
`define INSTR_FUNCT_NOR     6'b100111
`define INSTR_FUNCT_OR      6'b100101
`define INSTR_FUNCT_XOR     6'b100110
`define INSTR_FUNCT_SLT     6'b101010
`define INSTR_FUNCT_SLTU    6'b101011
`define INSTR_FUNCT_SLL     6'b000000
`define INSTR_FUNCT_SRL     6'b000010
`define INSTR_FUNCT_SRA     6'b000011
`define INSTR_FUNCT_SLLV    6'b000100
`define INSTR_FUNCT_SRLV    6'b000110
`define INSTR_FUNCT_SRAV    6'b000111
`define INSTR_FUNCT_JR      6'b001000
`define INSTR_FUNCT_JALR    6'b001001

// ?????

`define INSTR_RT_BGEZ       5'b00001
`define INSTR_RT_BLTZ       5'b00000