static inline int no_call(void)
{
    extern int unresolved(void);
    return unresolved();
}

static inline int effects(int* n)
{
    ++*n;
    return 0;
}

int main(void)
{
    int n = 3, calls = 0;
    int matrix[1][n];
    unsigned long row = sizeof(matrix[effects(&calls)]);
    unsigned long element = sizeof(matrix[(no_call(), 0)][0]);
    return !(row == 3 * sizeof(int) && element == sizeof(int) && calls == 1);
}
