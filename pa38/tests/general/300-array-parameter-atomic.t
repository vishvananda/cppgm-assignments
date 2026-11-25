static int last(int values[static _Atomic 2])
{
    int *_Atomic *ptr = &values;
    *ptr = values + 1;
    return values[0];
}

int main(void)
{
    int values[2] = {2, 7};
    return last(values) != 7;
}
