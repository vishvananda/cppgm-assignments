.code32
.text
.globl _start
.type _start,@function
_start:
    movl $1, %ebx
    cmpb $0x66, real_mode_push
    jne .Lexit
    cmpb $0x66, real_mode_pop
    jne .Lexit
    cmpb $0x66, real_mode_ret
    jne .Lexit
    xorl %ebx, %ebx
.Lexit:
    movl $1, %eax
    int $0x80
.size _start, .-_start
