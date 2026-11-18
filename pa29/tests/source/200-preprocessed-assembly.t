#if !defined(__ASSEMBLER__)
#error assembler mode required
#endif

#if defined(__APPLE__)
#define ENTRY _assembly_add
#else
#define ENTRY assembly_add
.section .note.GNU-stack,"",%progbits
#endif
#define ADD(delta) leaq delta(%rdi), %rax; retq

.text
.globl ENTRY
#if !defined(__APPLE__)
.type ENTRY,@function
#endif
ENTRY:
    ADD(7)
#if !defined(__APPLE__)
.size ENTRY, .-ENTRY
#endif
