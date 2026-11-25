.text
.globl _start
.type _start,@function
_start:
    andl $-16, %esp
    movl $23, %ebx
    movl $31, %esi
    movl $47, %edi
    pushl $8
    pushl $7
    pushl $3
    pushl $5
    call combine
    movl $2, %edx
    cmpl $23, %ebx
    jne .Lexit
    cmpl $31, %esi
    jne .Lexit
    cmpl $47, %edi
    jne .Lexit
    movl %eax, %edx
.Lexit:
    movl %edx, %ebx
    movl $1, %eax
    int $0x80
.size _start, .-_start
