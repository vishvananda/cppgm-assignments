int *object(int value)
{
    return &(static int){ value };
}
