static int read_row(int length, const int (*row)[length])
{
    void *erased = row;
    const int (*restored)[length] = erased;
#if __STDC_VERSION__ >= 201112L
    _Static_assert(_Generic(1 ? row : erased, void *: 1, default: 0),
                   "pre-C23 array is unqualified");
#endif
    return erased == row && (*restored)[length - 1] == 9;
}

int main(void)
{
    const int row[3] = {3, 5, 9};
    volatile int length = 3;
    return !read_row(length, &row);
}
