void example(values)
int values[restrict];
{
    int **p = &values;
    (void)p;
}
