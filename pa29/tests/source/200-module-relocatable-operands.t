.text
.globl inspect_immediates
.type inspect_immediates,@function
inspect_immediates:
    xorl %eax, %eax
    movw $short_value, %ax
    btsl $bit_index, %eax
    orl $mask_value, %eax
    pushq $signed_value
    popq %rdx
    addq %rdx, %rax
    movl $word_value, (%rdi)
    ret
.size inspect_immediates, . - inspect_immediates

.globl indexed_address
.type indexed_address,@function
indexed_address:
    leaq external_words + 4(,%rdi,4), %rax
    ret
.size indexed_address, . - indexed_address

.globl load_address32
.type load_address32,@function
load_address32:
    movl external_words(%edi), %eax
    ret
.size load_address32, . - load_address32
.section .note.GNU-stack,"",@progbits
