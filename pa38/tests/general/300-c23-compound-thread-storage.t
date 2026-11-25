static unsigned long width = sizeof (thread_local int){ 3 };

static int *first_cell(void)
{
    return (thread_local static int[]){ 4, 9 };
}

static int *second_cell(void)
{
    return &(static _Thread_local int){ 11 };
}

int main(void)
{
    int *first = first_cell();
    int *second = second_cell();
    if (width != sizeof(int) || first[0] != 4 || first[1] != 9 || *second != 11)
        return 1;
    first[1] = 14;
    *second = 16;
    return first != first_cell() || first_cell()[1] != 14 || second != second_cell() || *second_cell() != 16;
}
