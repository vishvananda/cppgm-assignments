typedef unsigned long long WordPair;
extern WordPair product(WordPair, WordPair);

WordPair wide_math(WordPair a, WordPair b)
{
    return product(a, b) ^ ((a + b) >> 5);
}

WordPair read_variadic(unsigned count, ...)
{
    __builtin_va_list ap;
    __builtin_va_start(ap, count);
    WordPair value = __builtin_va_arg(ap, WordPair);
    unsigned shift = __builtin_va_arg(ap, unsigned);
    __builtin_va_end(ap);
    return value >> shift;
}

WordPair add_in_registers(WordPair value)
{
    __asm__("addl $1, %%eax; adcl $0, %%edx" : "+A"(value) : : "cc");
    return value;
}

unsigned divide_word(unsigned value)
{
    return value / 1000 + value % 7;
}

int divide_signed_word(int value)
{
    return value / 8 + value % -7;
}
