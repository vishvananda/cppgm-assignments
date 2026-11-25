.text
.globl _start
.type _start,@function
_start:
    andl $-16, %esp
    call read_values
    movl %eax, %ebx
    movl $1, %eax
    int $0x80
.size _start, .-_start
