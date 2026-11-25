asm(".pushsection .rodata\n"
    ".balign 4\n"
    ".globl assembly_initial\n"
    "assembly_initial: .word 19\n"
    ".popsection");
extern "C" const int assembly_initial;
extern "C" const unsigned short assembly_immediate;

void define_immediate()
{
    asm volatile(".pushsection .rodata\n"
                 ".balign 2\n"
                 ".globl assembly_immediate\n"
                 "assembly_immediate: .hword %0\n"
                 ".popsection" : : "i"(27u));
}

int step(int* value, int count)
{
    if (count < 0)
        asm goto("cbnz %w0, %l[negative]" : : "r"(count) : "cc" : negative);
    asm volatile("ldr %w0, %2\nadd %w0, %w0, %w1\nstr %w0, %2"
        : "=&r"(count) : "r"(count), "Q"(*value) : "memory");
    ++count;
negative:
    return count;
}

int adjust_link_register(int input)
{
    register int value asm("x30") = input;
    asm volatile("add %w0, %w0, #1" : "+r"(value));
    return value;
}

unsigned keep_across_assembly(unsigned x, unsigned y)
{
    unsigned live = x * 17 + y;
    asm volatile("mov x19, #7\nadd %w0, %w0, #3" : "+r"(y) : : "x0", "x19", "cc");
    return live * y;
}

int main()
{
    int value = assembly_initial;
    if (adjust_link_register(26) != assembly_immediate || assembly_immediate != 27)
        return 3;
    if (step(&value, -3) != -3 || value != 19)
        return 1;
    if (step(&value, 4) != 24 || value != 23)
        return 2;
    return keep_across_assembly(8, 2) != 690;
}
