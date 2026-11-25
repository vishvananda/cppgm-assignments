.text
.globl _start
.type _start,@function
_start:
    andl $-16, %esp
    movl $23, %ebx
    movl $31, %esi
    movl $47, %edi
    subl $12, %esp
    pushl $8
    movl $5, %eax
    movl $3, %edx
    movl $7, %ecx
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
