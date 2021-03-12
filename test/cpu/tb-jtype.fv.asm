j       L1
lui     $v0, 0x9999

L1:
j       L2
lui     $v1, 0x8888

L2:
jal     L3
lui     $t0, 0x7777

L3:
add     $t6, $zero, $zero
add     $t6, $zero, $ra
lui     $t7, 0x2929