.text
.globl _start
.type _start,@function
_start:
    andl $-16, %esp
    pushl $2
    pushl $3
    pushl $1
    pushl $-1
    call wide_math
    addl $16, %esp
    movl $1, %ebx
    cmpl $0xdffffffd, %eax
    jne .Lexit
    cmpl $3, %edx
    jne .Lexit
    pushl $4
    pushl $0x76543210
    pushl $0xfedcba98
    pushl $2
    call read_variadic
    addl $16, %esp
    movl $2, %ebx
    cmpl $0x0fedcba9, %eax
    jne .Lexit
    cmpl $0x07654321, %edx
    jne .Lexit
    subl $8, %esp
    pushl $12
    pushl $-1
    call add_in_registers
    addl $16, %esp
    movl $3, %ebx
    testl %eax, %eax
    jne .Lexit
    cmpl $13, %edx
    jne .Lexit
    subl $12, %esp
    pushl $0xfedcba98
    call divide_word
    addl $16, %esp
    movl $4, %ebx
    cmpl $4275879, %eax
    jne .Lexit
    subl $12, %esp
    pushl $-12345
    call divide_signed_word
    addl $16, %esp
    movl $5, %ebx
    cmpl $-1547, %eax
    jne .Lexit
    xorl %ebx, %ebx
.Lexit:
    movl $1, %eax
    int $0x80
.size _start, .-_start
