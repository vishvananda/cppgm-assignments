int runtime_value(void);
int f(void)
{
    static int value = runtime_value();
    return value;
}
