.text
.p2align 4
.globl forward_layout
.type forward_layout,@function
forward_layout:
    .cfi_startproc
    jmp 1f
.globl before_space
before_space:
2:
    .byte 0xcc
3:
    .skip -(((5f-4f)-(3b-2b)) > 0) * ((5f-4f)-(3b-2b)), 0x90
.globl after_space
after_space:
1:
    movl $73, %eax
    ret
    .cfi_endproc
.globl forward_end
forward_end:
.set function_length, forward_end - forward_layout
.size forward_layout, function_length

.pushsection .text.replacement,"ax",@progbits
4:
    .byte 1, 2, 3, 4, 5, 6
5:
.popsection

.p2align 4, 0x90
.globl after_alignment
after_alignment:
    .byte 0x12
.org after_alignment + 4, 0x34
    .byte 0x56
.data
.globl measured_function
measured_function:
    .4byte function_length
.globl measured_space
measured_space:
    .4byte after_space - before_space
.globl saved_position
saved_position:
    .8byte after_alignment + 3
.section .note.GNU-stack,"",@progbits
