#if defined(__APPLE__) && defined(__aarch64__)
int entry_status(void);
int _start(void) { return entry_status(); }
#elif defined(__aarch64__)
__asm__(".text\n"
        ".globl _start\n"
        "_start:\n"
        "  bl entry_status\n"
        "  mov x8, #93\n"
        "  svc #0\n");
#elif defined(__APPLE__)
__asm__(".text\n"
        ".globl __start\n"
        "__start:\n"
        "  andq $-16, %rsp\n"
        "  callq _entry_status\n"
        "  movl %eax, %edi\n"
        "  movl $0x2000001, %eax\n"
        "  syscall\n");
#else
__asm__(".text\n"
        ".globl _start\n"
        "_start:\n"
        "  call entry_status\n"
        "  movl %eax, %edi\n"
        "  movl $60, %eax\n"
        "  syscall\n");
#endif
