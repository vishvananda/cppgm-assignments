int exits(int n)
{
    volatile char outer[n];
    outer[n - 1] = 17;
    for (int i = 0; i < 12000; ++i) {
        volatile char values[n];
        values[n - 1] = i;
        if (i % 2) continue;
        { volatile char inner[n + 1]; inner[n] = i; }
    }
    for (int i = 0; i < 12000; ++i) {
        volatile char values[n];
        values[n - 1] = i;
        break;
    }
    int remaining = 12000;
again:
    {
        volatile char values[n];
        values[n - 1] = remaining;
        if (--remaining) goto again;
    }
    return outer[n - 1] != 17;
}
int back(int n)
{
    int remaining = 12000;
again:
    ;
    volatile char values[n];
    values[n - 1] = remaining;
    if (--remaining) goto again;
    return values[n - 1] != 1;
}
int main(void) { return exits(2048) || back(2048); }
