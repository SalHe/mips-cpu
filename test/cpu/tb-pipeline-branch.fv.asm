addi    $t0, $zero, 0
addi    $t1, $zero, 1
addi    $t2, $zero, 2

bne		$t0, $t1, NEXT
add		$v0, $t1, $t2

NEXT:
addiu   $v1, $zero, 0xFFFF
beq		$t0, $t0, EQL	# if $t0 == $t0 then EQL
add		$v0, $t1, $t2		# $v0 = $t1 + $t2

EQL:
add		$v0, $t1, $t1
add		$v0, $t2, $t2
add		$v0, $t1, $t1
add		$v0, $t2, $t2
add		$v0, $t1, $t1
add		$v0, $t2, $t2
add		$v0, $t1, $t1
add		$v0, $t2, $t2