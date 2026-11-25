int values[3];

void use(void)
{
    int values = 0;
    {
        extern int values[];
        (void)sizeof values;
    }
    (void)values;
}
