// expect exit 0
#if !__has_attribute(__cleanup__)
#error GNU C cleanup attribute is unavailable
#endif

static int observed;

static int record(const int *value)
{
    observed = observed * 10 + *value;
    return 17;
}

static void set_and_record(int *value)
{
    *value = 8;
    record(value);
}

static int through_scope(int mode)
{
    int outer __attribute__((cleanup(record))) = 1;
    {
        const int inner __attribute__((__cleanup__(record))) = 2;
        if (mode == 0)
            return observed;
        if (mode == 1)
            goto done;
    }
    for (int i = 0; i < 2; ++i) {
        int iteration __attribute__((cleanup(record))) = 3 + i;
        if (i == 0)
            continue;
        break;
    }
done:
    return observed;
}

int main(void)
{
    if (through_scope(0) != 0 || observed != 21)
        return 1;
    observed = 0;
    if (through_scope(1) != 2 || observed != 21)
        return 2;
    observed = 0;
    if (through_scope(2) != 234 || observed != 2341)
        return 3;
    observed = 0;
    {
        int uninitialized __attribute__((cleanup(set_and_record)));
    }
    return observed != 8;
}
