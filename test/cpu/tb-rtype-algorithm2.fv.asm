lui     $v0, 0x8000
addiu   $v1, $zero, 1

addiu   $t0, $zero, 5
addiu   $t1, $zero, 5

slt     $t0, $v0, $v1
sltu    $t1, $v0, $v1