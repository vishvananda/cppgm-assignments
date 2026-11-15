int count;
int consume(int *values, int size)
{
    int sum = 0;
    for (int i = 0; i < size; ++i) sum += values[i];
    return sum;
}
int sizes(int n)
{
    int values[n++];
    unsigned long bytes = sizeof values;
    int original = n - 1;
    for (int i = 0; i < original; ++i) values[i] = i + 1;
    n = 1;
    if (sizeof values != bytes || bytes != original * sizeof(int)) return 1;
    if (sizeof *(++count, &values) != bytes || count != 1) return 2;
    sizeof *(++count, &values);
    if (count != 2 || sizeof &values != sizeof(int *)) return 3;
    if ((&values + 1) - &values != 1) return 4;
    if ((char *)(&values + 1) - (char *)&values != bytes) return 5;
    return consume(values, original) == original * (original + 1) / 2 ? 0 : 6;
}
int pointers(int argc)
{
    char *argv[argc + 1];
    for (int i = 0; i < argc; ++i) argv[i] = "x";
    argv[argc] = 0;
    if (sizeof argv != (argc + 1) * sizeof(char *)) return 7;
    return argv[argc - 1][0] != 'x' || argv[argc] != 0;
}
int cwd(char *buf)
{
    char tmp[buf ? 1 : 4096];
    if (sizeof tmp != (buf ? 1 : 4096)) return 8;
    tmp[sizeof tmp - 1] = 42;
    return tmp[sizeof tmp - 1] != 42;
}
int aligned(int n)
{
    _Alignas(64) int values[n];
    values[n - 1] = 17;
    return (unsigned long)values % 64 != 0 || values[n - 1] != 17;
}
int constant_bound(void)
{
    const int n = 3;
    int values[n];
    unsigned long size = sizeof values;
    values[n - 1] = 11;
    return size != 3 * sizeof(int) || values[2] != 11;
}
int main(void)
{
    if (sizes(7) || constant_bound()) return 1;
    count = 0;
    if (sizes(3) || pointers(5) || cwd(0) || cwd("x") || aligned(9)) return 2;
    return 0;
}
