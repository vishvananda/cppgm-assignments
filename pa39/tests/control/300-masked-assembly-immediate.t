extern "C" const unsigned short assembly_immediate;

void define_immediate(unsigned input)
{
    asm volatile(".pushsection .rodata\n"
                 ".balign 2\n"
                 ".globl assembly_immediate\n"
                 "assembly_immediate: .hword %0\n"
                 ".popsection" : : "i"(((input & 768u) | 27u) & 63u));
}

int main()
{
    return assembly_immediate != 27;
}
