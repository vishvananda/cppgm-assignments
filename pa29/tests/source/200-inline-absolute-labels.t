extern "C" int match_label()
{
    unsigned long address, calculated;
    asm("pushq $1f\n\t"
        "popq %0\n\t"
        "leaq 0(%%rip), %1\n"
        "1:"
        : "=r"(address), "=r"(calculated));
    return address == calculated;
}
