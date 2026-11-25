#if defined(__APPLE__)
#define SYM(name) "_" name
#define SHIFT_EXPRESSION "1 + (2 << 3)"
#else
#define SYM(name) name
#define SHIFT_EXPRESSION "1 + 2 << 3"
#endif

asm(".data\n"
    ".globl " SYM("expression_data") "\n"
    SYM("expression_data") ":\n"
    ".if %Rsp == %rsp && %rsp != %esp\n"
    ".long " SHIFT_EXPRESSION ", 010 + 0b11\n"
    ".else\n"
    ".long 0, 0\n"
    ".endif\n"
    ".text\n"
    ".globl " SYM("expression_load") "\n"
    SYM("expression_load") ":\n"
    "movl " SYM("expression_data") "+(1 << 2)(%rip), %eax\n"
    "ret\n");

extern "C" unsigned expression_offset(const unsigned* data)
{
    unsigned result;
    asm("movl (2 * 4)(%1), %0\n\taddl $(3 + 2 * 5), %0"
        : "=r"(result)
        : "r"(data)
        : "memory", "cc");
    return result;
}
