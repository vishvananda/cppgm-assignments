typedef _BitInt(9) S9;
typedef _BitInt(65) S65;
typedef unsigned _BitInt(65) U65;

static S65 boundary(long a, long b, long c, long d, long e, long f, long g, S65 n, long tail)
{
    return n + a + g + tail;
}

static int variadic(int tag, ...)
{
    __builtin_va_list ap;
    __builtin_c23_va_start(ap);
    S9 first = __builtin_va_arg(ap, S9);
    S65 second = __builtin_va_arg(ap, S65);
    U65 third = __builtin_va_arg(ap, U65);
    __builtin_va_end(ap);
    return first == -106 && second == -34 && (third >> 64) == 1 ? tag : 0;
}

static int select(U65 value)
{
    switch (value) {
    case 3:
        return 1;
    case 0x10000000000000003uwb:
        return 2;
    case -1:
        return 3;
    default:
        return 0;
    }
}

int main(void)
{
    volatile S65 n = -34;
    volatile U65 high = 0x10000000000000003uwb;
    if (boundary(1, 2, 3, 4, 5, 6, 7, n, 20) != -6)
        return 1;
    if (variadic(9, (S9)-106, n, high) != 9)
        return 2;
    if (select(3) != 1 || select(high) != 2 || select((U65)-1) != 3 || select(4) != 0)
        return 3;
    return 0;
}
