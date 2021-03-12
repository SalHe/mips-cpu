lui     $v0, 0x9988
ori     $v0, $v0, 0x7766
lui     $v1, 0x7766
ori     $v1, 0x5544

lui     $t0, 0x8000
addiu   $t1, $t0, 0x8000
addi    $t2, $t0, 0x8000
andi    $t3, $t2, 0x8000
xori    $t4, $t2, 0x8000

# sw lw 配套测试 Test in pair
sw      $t0, 0($zero)
lw      $t5, 0($zero)

# 99887766, 77665544, 80000000, 80008000, 7fff8000, 00008000, 7fff0000, 80000000, xxxxxxxx, xxxxxxxx 

