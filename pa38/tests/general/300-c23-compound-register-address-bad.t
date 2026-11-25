struct Cell { int value; };

int *address(void)
{
    return &((register struct Cell){ 7 }.value);
}
