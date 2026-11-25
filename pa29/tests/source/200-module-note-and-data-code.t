.pushsection .note.course,"a",@note
.balign 4
.globl course_note
course_note:
    .long note_name_end - note_name, 4, 7
note_name:
    .asciz "CPPGM"
note_name_end:
    .balign 4
    .long 27
.popsection

.section .rodata,"a",@progbits
.globl encoded_code
encoded_code:
    nop
    ret
.section .note.GNU-stack,"",@progbits
