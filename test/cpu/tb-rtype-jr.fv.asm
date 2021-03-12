addi    $v0, $zero, 1
addi    $v1, $zero, 2
jal     SUB
add     $t1, $zero, $t0
j       EXIT

SUB:
add     $t0, $v0, $v1
jr      $ra

EXIT:
addi    $t7, $zero, 0x29