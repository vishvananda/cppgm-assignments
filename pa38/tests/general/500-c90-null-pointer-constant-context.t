static long *convert(int condition, int *value)
{
    return condition ? value : (void *)(1 ? 0 : (0, 0));
}

int main(void)
{
    return convert(0, 0) != 0;
}
