int f(void)
{
    int automatic;
    static int *pointer = &automatic;
    return *pointer;
}
