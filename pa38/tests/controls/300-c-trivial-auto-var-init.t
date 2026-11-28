// expect exit 0

#if !__has_attribute(__uninitialized__)
#error missing uninitialized attribute
#endif

struct padded {
    unsigned char tag;
    unsigned int count;
};

__attribute__((noinline)) static int all_zero(const volatile void *object, unsigned long size)
{
    const volatile unsigned char *bytes = object;
    for (unsigned long i = 0; i < size; ++i)
        if (bytes[i])
            return 0;
    return 1;
}

__attribute__((noinline)) static int check_storage(unsigned n)
{
    volatile int scalar;
    void *pointer;
    volatile struct padded record;
    unsigned char array[177];
    volatile unsigned variable_array[n];
    struct padded initialized = { 1, 2 };
    int explicit_value __attribute__((__uninitialized__)) = 9;
    const unsigned char *representation = (const unsigned char *)&initialized;

    for (unsigned long i = 1; i < __builtin_offsetof(struct padded, count); ++i)
        if (representation[i])
            return 1;

    return scalar != 0 || pointer != 0 || explicit_value != 9 ||
           initialized.tag != 1 || initialized.count != 2 ||
           !all_zero(&record, sizeof(record)) || !all_zero(array, sizeof(array)) ||
           !all_zero(variable_array, sizeof(variable_array));
}

__attribute__((noinline)) static int jump_over_declaration(int rounds)
{
again:
    if (!rounds--)
        return 0;
    {
        goto first;
        volatile int value;
    first:
        if (value != 0)
            return 1;
        value = 7;
        goto same_scope;
    same_scope:
        if (value != 7)
            return 1;
        goto again;
    }
}

__attribute__((noinline)) static int switch_over_declaration(int selector)
{
    switch (selector) {
        volatile int value;
        case 0:
            if (value != 0)
                return -1;
            value = 7;
        case 1:
            return value;
        default:
            return -1;
    }
}

int main(void)
{
    return check_storage(6) || jump_over_declaration(3) ||
           switch_over_declaration(0) != 7 || switch_over_declaration(1) != 0;
}
