int main(void)
{
    int n = 2;
    auto pointer = (int (*)[++n])0;
    if (n != 3 || sizeof *pointer != 3 * sizeof(int))
        return 1;

    int array[2][n];
    auto row = array;
    auto next = ++row;
    next[0][2] = 19;
    return row != &array[1] || array[1][2] != 19 || sizeof *row != 3 * sizeof(int);
}
