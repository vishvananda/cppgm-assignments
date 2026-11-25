static const int (*read_only(int (*row)[3]))[3]
{
    return row;
}

static int first(int length, const int rows[][length])
{
    return rows[0][0];
}

static int check(int length, int (*rows)[3])
{
    int (*runtime)[length] = rows;
    const int (*fixed)[3] = runtime;
    const int (*later)[length] = rows + 1;
    volatile int (*changing)[3] = rows + 1;
    const volatile int (*selected)[3] = length == 3 ? later : changing;
    const void *erased = later;
    const int (*restored)[length] = erased;
    static_assert(_Generic(1 ? later : changing, const volatile int (*)[3]: 1, default: 0));
    static_assert(_Generic(1 ? later : (void *)rows, const void *: 1, default: 0));
    return later - runtime != 1 || runtime - changing != -1 ||
           later != changing || fixed >= later ||
           first(length, rows) != 3 || (*read_only(rows))[0] != 3 ||
           (*selected)[2] != 9 || (*restored)[2] != 9;
}

static int nested(int length, int (*blocks)[2][3])
{
    const int (*view)[2][length] = blocks;
    const int (*fixed)[2][3] = view;
    return (*fixed)[1][2];
}

int main(void)
{
    int rows[2][3] = {{3, 4, 5}, {7, 8, 9}};
    volatile int length = 3;
    return check(length, rows) || nested(length, &rows) != 9;
}
