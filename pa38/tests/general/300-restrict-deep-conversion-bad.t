void example(int ***source)
{
    int *restrict *const *destination = source;
    (void)destination;
}
