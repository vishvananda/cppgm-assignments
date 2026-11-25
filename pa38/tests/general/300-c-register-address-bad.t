int *address(void)
{
    register int value = 7;
    return &(value);
}
