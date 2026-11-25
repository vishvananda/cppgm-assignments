struct Block
{
    unsigned long words[12];
};

extern "C" __attribute__((noinline)) void copy_block(Block* destination, const Block* source)
{
    *destination = *source;
}

extern "C" __attribute__((noinline)) unsigned long total(unsigned count, ...)
{
    __builtin_va_list args;
    __builtin_va_start(args, count);
    unsigned long sum = 0;
    while (count--)
        sum += __builtin_va_arg(args, unsigned long);
    __builtin_va_end(args);
    return sum;
}

int main()
{
    Block source = {{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}};
    Block destination = {};
    copy_block(&destination, &source);
    for (unsigned i = 0; i < 12; ++i)
        if (destination.words[i] != i + 1)
            return 1;
    return total(12, 1ul, 2ul, 3ul, 4ul, 5ul, 6ul, 7ul, 8ul, 9ul, 10ul, 11ul, 12ul) != 78;
}
