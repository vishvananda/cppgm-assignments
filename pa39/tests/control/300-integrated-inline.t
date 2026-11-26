asm(".macro increment reg, amount\n"
    "add \\reg, \\reg, #\\amount\n"
    ".endm");

asm(".pushsection .text, \"ax\", %progbits\n"
    ".globl assembly_answer\n"
    ".type assembly_answer, %function\n"
    "assembly_answer: mov w0, #13\n"
    "ret\n"
    ".size assembly_answer, .-assembly_answer\n"
    ".popsection");
extern "C" int assembly_answer();

extern "C" const unsigned short asm_value;
extern "C" const __INTPTR_TYPE__ asm_delta;
extern "C" const unsigned char asm_lengths[2];
int anchor = 1;

__attribute__((noinline)) void emit_value()
{
    asm volatile(".pushsection .rodata\n"
                 ".balign 2\n"
                 ".globl asm_value\n"
                 "asm_value: .hword %c0\n"
                 ".balign 8\n"
                 ".globl asm_delta\n"
                 "asm_delta: .quad %c1 - .\n"
                 ".popsection" : : "i"(17), "i"(&anchor));
}

__attribute__((noinline)) int adjust(int value)
{
    if (value < 0)
        asm goto("cbnz %w0, %l[negative]" : : "r"(value) : : negative);
    asm volatile("b 1f\n"
                 "add %w0, %w0, #100\n"
                 "1: increment %w0, 3\n"
                 "2:\n"
                 ".pushsection .rodata\n"
                 ".globl asm_lengths\n"
                 "asm_lengths: .byte 2b-1b, 4f-3f\n"
                 ".popsection\n"
                 ".subsection 1\n"
                 "3:\n"
                 ".rept (2b - 1b) / 4\n"
                 "sub %w0, %w0, #3\n"
                 ".endr\n"
                 "4:\n"
                 ".org . - (4b - 3b) + (2b - 1b)\n"
                 ".org . - (2b - 1b) + (4b - 3b)\n"
                 ".previous\n"
                 "cbz %w0, 1b" : "+r"(value));
negative:
    return value;
}

int main()
{
    emit_value();
    const auto address = reinterpret_cast<__UINTPTR_TYPE__>(&asm_delta) + asm_delta;
    if (address != reinterpret_cast<__UINTPTR_TYPE__>(&anchor) || asm_value != 17 || assembly_answer() != 13)
        return 1;
    if (asm_lengths[0] != asm_lengths[1] || asm_lengths[0] == 0)
        return 2;
    return adjust(-13) == -13 && adjust(21) == 24 ? 0 : 3;
}
