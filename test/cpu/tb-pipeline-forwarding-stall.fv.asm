addi    $t0, $zero, 0x29

sw      $t0, 0($zero)
lw      $t5, 0($zero)           # IF - ID = EX - MM * WB

addi    $t1, $t5, 0x07          #      IF - ID * EX - MM - WB (Stall !!!!)