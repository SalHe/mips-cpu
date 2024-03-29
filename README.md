# MIPS CPU



## 说明

MIPS CPU 的简单实现。

本代码仅作为本人《计算机组成与设计实验课程》的实验代码，不具备任何严谨性。

**存在已知问题需要修复，但由于本人课程已结束，所以不再更新，开摆！**

## 特性

- ✔基础指令实现（见[参考](#参考)）

- ✔五级流水线（IF/ID/EX/MEM/WB）

- ✔分支总不发生预测



## 工具集

- [iverilog](http://iverilog.icarus.com/)

  一款开源的Verilog编译器及仿真工具集。

- gcc

  C语言编译器，用于编译[bin2hex](./test/cpu/bin2hex.c)，用于将MIPS二进制机器码转换为HEX格式的文本文件，供仿真读入指令调试使用。

- gcc-mips-linux-gnu

  Linux上MIPS的交叉编译工具集，并使用了该工具提取出二进制机器代码。



## 参考

- [jmahler's mips cpu](https://github.com/jmahler/mips-cpu)

- 《计算机组成与设计 硬件软件接口 第五版》David A. Patterson, Joho L. Hennessy, 王党辉等翻译.

- [MIPS 指令集](https://blog.csdn.net/ben_chong/article/details/51794093)
