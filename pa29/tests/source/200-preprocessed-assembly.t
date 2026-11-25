#if !defined(__ASSEMBLER__)
#error assembler mode required
#endif

#if defined(__APPLE__)
#define ENTRY _assembly_add
#else
#define ENTRY assembly_add
.section .note.GNU-stack,"",%progbits
#endif
#define INCREMENT 7
#define ADD() movq %rdi, %rax; addq $INCREMENT, %rax; retq

.text
.globl ENTRY
#if !defined(__APPLE__)
.type ENTRY,@function
#endif
ENTRY:
    ADD()
#if !defined(__APPLE__)
.size ENTRY, .-ENTRY
#endif
