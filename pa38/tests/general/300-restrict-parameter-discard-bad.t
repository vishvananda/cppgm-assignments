void example(int values[restrict])
{
    int **p = &values;
    (void)p;
}
