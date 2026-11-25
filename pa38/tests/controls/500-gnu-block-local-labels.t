// expect exit 0

#define SELECT(value) ({          \
    __label__ done;               \
    int result = (value);         \
    if (result > 0)               \
        goto done;                \
    result = 12;                  \
done: (void)0;                    \
    result;                       \
})

static int nested(void)
{
    int result = 0;
    {
        __label__ again;
        void *volatile target = &&again;
        {
            __label__ again;
            goto again;
            return -1;
        again:
            result += 2;
        }
        goto *target;
        return -2;
    again:
        result += 8;
    }
    goto again;
    return -3;
again:
    return result;
}

#if defined(__x86_64__)
static int assembly_destination(void)
{
    __label__ success;
    __asm__ goto ("jmp %l[success]" : : : : success);
    return 0;
success:
    return 1;
}
#endif

int main(void)
{
    int first = SELECT(9);
    int second = SELECT(-1);
    if (first != 9 || second != 12 || nested() != 10)
        return 1;
#if defined(__x86_64__)
    if (!assembly_destination())
        return 2;
#endif
    return 0;
}
