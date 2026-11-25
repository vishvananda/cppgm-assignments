.data
.balign 16
.globl wide_words
wide_words:
    .octa 0xfedcba98765432100123456789abcdef, -1

.text
.globl read_word
.type read_word,@function
read_word:
    .set pointer, %rdi
    .set result, %eax
    movl 8(pointer), result
    ret
.size read_word, . - read_word
.section .note.GNU-stack,"",@progbits
