struct alignas(64) Block { long words[8]; };
extern "C" long inspect(Block, const Block*, const unsigned char*,
                        int, int, int, int, int, int, int, int);
extern "C" long exercise(unsigned n, long value) {
    Block local;
    for (int i = 0; i != 8; ++i) local.words[i] = value + i;
    volatile unsigned char *first = (volatile unsigned char *)__builtin_alloca(n);
    first[0] = 6;
    first[n - 1] = 7;
    unsigned char *second = (unsigned char *)__builtin_alloca(n + 3);
    second[0] = 9;
    long sum = inspect(local, &local, second, 0, 1, 2, 3, 4, 5, 6, 7);
    return sum + first[0] + first[n - 1] + second[0];
}
