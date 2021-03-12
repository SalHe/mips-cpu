lui     $v0, 0x8000
lui     $v1, 0x8000
addiu   $v1, $v1, 0xFFFF

add     $t0, $v0, $v1
addu    $t1, $v0, $v1

sub     $t2, $v0, $v1
subu    $t3, $v0, $v1

and     $t4, $v0, $v1
or      $t5, $v0, $v1
xor     $t6, $v0, $v1
nor     $t7, $v0, $v1

# 80000000, 8000ffff, 0000ffff, 0000ffff, ffff0001, ffff0001, 80000000, 8000ffff, 0000ffff, 7fff0000