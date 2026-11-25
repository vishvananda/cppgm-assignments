#define NO_LINKAGE(name)
#define END(name) NO_LINKAGE(name) ; name:

.section .rodata,"a",@progbits
.globl real_mode_code
real_mode_code:
.code16
    movw (%bx,%si), %ax
    movl %eax, 8(%esp)
    pushfl
    popw %ds
    rep movsl
1:  callw 1b
.code16gcc
    push $7
    ret # use the code16gcc stack operand size
    ds; ds; ds; int $0x80
.code32
    rdpid %eax
.code64
.globl real_mode_code_end
END(real_mode_code_end)

.set WORD_ALIGNMENT, 4
.balign WORD_ALIGNMENT
.globl real_mode_word_count
real_mode_word_count:
    .long (2f - .) / 2
    .long 0
2:
.section .note.GNU-stack,"",@progbits
