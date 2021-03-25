
addi    $t1, $zero, 1       # IF - ID = EX - MM - WB
addi    $t2, $zero, 2       #      IF - ID = EX - MM * WB
addi    $t3, $zero, 3       #           IF - ID = EX - MM - WB
add     $v0, $t1, $t2       #                IF - ID * EX * MM - WB         ($t2: addi    $t2, $zero, 2)
add     $v1, $v0, $zero     #                     IF - ID * EX - MM - WB    ($v0: add $v0, $t1, $t2)
sub     $v1, $v1, $v1