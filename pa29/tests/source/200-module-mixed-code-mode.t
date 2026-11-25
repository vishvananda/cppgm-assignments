.section .rodata,"a",@progbits
.globl legacy_code
legacy_code:
.code32
    movl 4(%esp), %eax
    pushl %eax
    popl %eax
    movl %cr3, %eax
    calll *%eax
    lret
    ljmpl $16, $0x12345678
    ljmpl *2(%esp)
.code64
    lretq
.globl legacy_code_end
legacy_code_end:

.text
.globl after_legacy_mode
.type after_legacy_mode,@function
after_legacy_mode:
    movl $17, %eax
    ret
.size after_legacy_mode, . - after_legacy_mode
.section .note.GNU-stack,"",@progbits
