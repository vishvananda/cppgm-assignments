.text
.globl branch_over_section
.type branch_over_section,@function
branch_over_section:
    jmp 902f

.pushsection .rodata
.globl numbered_forward
numbered_forward:
    .long 902f - .
.popsection

    movl $0, %eax
    ret
.globl numbered_result
numbered_result:
902:
    movl $39, %eax
    ret

.pushsection .rodata
.globl numbered_backward
numbered_backward:
    .long 902b - .
.popsection

.globl count_with_numbered_loop
.type count_with_numbered_loop,@function
count_with_numbered_loop:
    movl $3, %ecx
    xorl %eax, %eax
902:
    addl $7, %eax
    subl $1, %ecx
    jne 902b
    ret

.section .note.GNU-stack, "", @progbits
