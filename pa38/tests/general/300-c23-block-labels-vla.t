static int repeat_initialization(unsigned rounds)
{
    unsigned length = 2;
    unsigned seen = 0;
    goto start;
    return 1;
start: again:
    int values[length++] = {};
    if (values[0] != 0 || values[length - 2] != 0)
        return 2;
    values[0] = 11;
    if (++seen < rounds)
        goto again;
    if (length != rounds + 2 || values[0] != 11)
        return 3;
    return 0;
}

int main(void)
{
    return repeat_initialization(20);
}
