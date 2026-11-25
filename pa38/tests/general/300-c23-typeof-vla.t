int main(void)
{
    int n = 2;
    typeof_unqual(const int[n++]) values;
    values[1] = 42;
    if (n != 3 || sizeof values != 2 * sizeof(int))
        return 1;

    typeof_unqual(typeof(int (*)[++n])) nested = 0;
    if (n != 4 || sizeof *nested != 4 * sizeof(int))
        return 2;

    typeof((n++, &values)) pointer = &values;
    if (n != 5 || (*pointer)[1] != 42 || sizeof *pointer != sizeof values)
        return 3;

    typeof_unqual(++n) unevaluated = 42;
    return n != 5 || unevaluated != 42;
}
