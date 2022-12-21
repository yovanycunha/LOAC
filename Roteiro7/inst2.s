.text
.globl main
main:
        addi x11, x0, 0xFE
        addi x12, x0, 0x000
        lui x12, 0x10000
        sw x11, 12 (x12)
        lw x10, 12 (x12)