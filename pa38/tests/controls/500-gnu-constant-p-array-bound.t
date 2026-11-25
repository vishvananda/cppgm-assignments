// expect exit 0

static int fallback(unsigned long value)
{
    return value == 16 ? 15 : -1;
}

#define LOG2(value) (__builtin_constant_p(value)     ? 63 - __builtin_clzll(value) : fallback(value))

struct buffer {
    char data[LOG2(sizeof(char[16]))];
};

_Static_assert(sizeof(struct buffer) == 4, "selected constant query operand");

int main(void)
{
    volatile unsigned long dynamic = 16;
    return LOG2(dynamic) != 15;
}
