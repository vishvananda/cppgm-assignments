asm(".section .text.instruction_differences\n"
    ".globl external_object\n"
    ".code32\n1:\n.byte 0x90\n"
    "ljmpl $16, $(2f - 1b)\n"
    "leal (external_object - 1b)(%ecx), %eax\n"
    "2:\n.byte 0x90\n"
    ".code64\n"
    "movabsq $(external_object + 0x100000000), %rax\n"
    "movl $(. - 1b), %eax\n");
