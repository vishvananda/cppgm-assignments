static int storage[5];
int f(int n)
{
    static int (*p)[5] = (int (*)[n++])storage;
    return (*p)[0] + n;
}
