void invalid(int n)
{
    goto entered;
    typedef int Row[n];
entered:
    (void)sizeof(Row);
}
