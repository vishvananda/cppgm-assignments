// expect exit 0

__attribute__((noinline)) static int computed_jump(int selector)
{
    static void *const targets[] = { &&outside, &&inside };
    goto *targets[selector];
    {
        volatile int value;
    inside:
        return value;
    }
outside:
    return 3;
}

int main(void)
{
    return computed_jump(0) != 3 || computed_jump(1) != 0;
}
