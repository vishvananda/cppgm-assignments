static int last(int values[static restrict _Atomic 2])
{
    int *restrict _Atomic *p = &values;
    return (*p)[1];
}

int main(void)
{
    int values[] = {1, 9};
    return last(values) != 9;
}
