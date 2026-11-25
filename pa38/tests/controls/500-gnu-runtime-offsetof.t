// expect exit 0

struct element {
    long count;
    int values[4];
};

struct table {
    char prefix;
    struct element items[3];
};

_Static_assert(__builtin_offsetof(struct table, items[0]) < __builtin_offsetof(struct table, items[1]),
               "static indices are integer constant expressions");

static int calls;

static int index_once(int n)
{
    ++calls;
    return n;
}

static unsigned long offset(int row, int col)
{
    return __builtin_offsetof(struct table, items[index_once(row)].values[col]);
}

int main(void)
{
    struct table object;
    const unsigned long expected = (char *)&object.items[2].values[1] - (char *)&object;
    if (offset(2, 1) != expected || calls != 1)
        return 1;
    (void)__builtin_offsetof(struct table, items[index_once(0)].values[0]);
    if (calls != 2)
        return 2;
    return offset(1, -1) != __builtin_offsetof(struct table, items[1].values[0]) - sizeof(int) || calls != 3;
}
