addi    $v0, $zero, 1
addi    $v1, $zero, 10

addi    $t0, $zero, 0

LOOP:
beq     $v0, $v1, EXIT  # $v0 == $v1 则 break;
addu    $t0, $t0, $v0
addiu   $v0, $v0, 1
bne     $v0, $v1, LOOP  # $v0 != $v1 则 continue;

EXIT:
addi    $t6, $zero, 0x8888

# 测试文件给定运行的周期数取决于机器码总长度
# 这里没有必要为了本测试文件额外改动规则
# 所以添加NOP多跑一些周期即可

# 表示这里调了很多次才想到
# 以为他莫名其妙就结束了（没有完整的去循环）

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop