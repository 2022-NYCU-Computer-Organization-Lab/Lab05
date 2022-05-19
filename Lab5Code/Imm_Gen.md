# Imm_Gen

| Instruction | type |Ins[6:0] opcode - Ins[14:12] func3 | imm12
| -------- | -------- | -------- | -------- |
|  | R-type |  | N/A |
| Addi |  I-type |0010011 - 000 | ins[31:20] |
| Load (LW) | I-type | 0000011 | ins[31:20] |
| Slti | I-type | 0010011 - 010 | ins[31:20] |
| Slli | I-type | 0010011 - 001 | ins[24:20] |
| Store (SW) | S-type | 0100011 | ins[31:25] + ins[11:7] |
| Branch (Beq) | SB-type | 1100011 | ins[31] + ins[7] + ins[30:25] + ins[11:8] + 1'b0 |
| Jal | UJ-type | 1101111 | ins[31] + ins[19:12] + ins[20] + ins[30:21] + 1'b0 |
| (not this time) Jalr | I-type | 1100111 | ins[31:20] |


https://zhuanlan.zhihu.com/p/394722400
https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
https://stenlyho.blogspot.com/2008/08/16-bits-sign-extender-to-32-bits.html?m=0
https://inst.eecs.berkeley.edu/~cs61c/resources/su18_lec/Lecture7.pdf
