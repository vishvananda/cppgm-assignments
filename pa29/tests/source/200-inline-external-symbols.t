extern "C" int external_sequence(int input)
{
    int result;
    asm volatile("call asm_transform@PLT\n"
                 "addl asm_adjustment(%%rip), %%eax\n"
                 "jmp 1f\n"
                 "movl $0, %%eax\n"
                 "1:\n"
                 : "=a"(result)
                 : "D"(input)
                 : "rcx", "rdx", "rsi", "r8", "r9", "r10", "r11", "cc", "memory");
    return result;
}
