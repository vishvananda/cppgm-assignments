static unsigned long parameter(int n, _Atomic(int (*)[n]) p);

static unsigned long parameter(int n, _Atomic(int (*)[++n]) p)
{
    return n == 3 && (*p)[2] == 7 ? sizeof *p : 0;
}

int main(void)
{
    int n = 2;
    int data[3] = {0, 0, 7};
    _Atomic(int (*)[++n]) p = &data, q = &data;
    typedef int Row[n++];
    _Atomic(Row *) copy = &data;
    return n != 4 || sizeof *p != sizeof data || (*q)[2] != 7 ||
        (*copy)[2] != 7 || sizeof *copy != sizeof data || parameter(2, &data) != sizeof data;
}
