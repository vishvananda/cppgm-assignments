#ifdef __STDC_NO_VLA__
#error cppgm must advertise its variable-length array support
#endif

static int check(int n)
{
    volatile int array[n];
    array[n - 1] = 21;
    return sizeof(array) != (unsigned)n * sizeof(int) || array[n - 1] != 21;
}

int main(void)
{
    volatile int size = 3;
    return check(size);
}
