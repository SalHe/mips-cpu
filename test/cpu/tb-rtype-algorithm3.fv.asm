lui     $v0, 0x8000
ori     $v0, $v0, 0x0404
addi    $v1, $zero, 2

sll     $t0, $v0, 2
srl     $t1, $v0, 2
sra     $t2, $v0, 2

sllv    $t3, $v0, $v1
srlv    $t4, $v0, $v1
srav    $t5, $v0, $v1