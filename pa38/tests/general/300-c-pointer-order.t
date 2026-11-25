static int identity(int value)
{
    return value;
}

int main(void)
{
    int rows[3][3] = {{0}, {1}, {2}};
    int (*first)[3] = rows;
    int (*last)[3] = rows + 2;
    const int *start = rows[0];
    int *past = rows[0] + 3;
    void *erased_first = first;
    const void *erased_last = last;
    int (*function)(int) = identity;
    return !(first < last) || last <= first || !(start < past) ||
           !(erased_first < erased_last) || first != erased_first ||
           function != identity || function == (void *)0 || first == 0;
}
