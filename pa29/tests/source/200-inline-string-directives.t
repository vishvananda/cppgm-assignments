extern "C" const char* instruction_data()
{
    const char* result;
    asm("leaq 1f(%%rip), %0\n"
        "jmp 2f\n"
        "1:\n"
        ".ascii \"A%c1\" \"B\"\n"
        ".asciz \"C\", \"D\"\n"
        ".string \"\\105\"\n"
        "2:"
        : "=r"(result) : "i"(7));
    return result;
}
