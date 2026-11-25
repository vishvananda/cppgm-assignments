static int read(values)
int values[restrict 2];
{
    int *restrict *p = &values;
    return (*p)[1];
}

int main(void)
{
    int values[2] = {0, 21};
    return read(values) != 21;
}
