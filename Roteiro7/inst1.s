.text
.globl main
main:
        addi x1, x0, 1
        addi x2, x0, 1
        addi x3, x0, 5
loop:
        beq x2, x3, end
        mul x1, x1, x2
        addi x2, x2, 1
        j loop

end:
        add a0, x1, x0