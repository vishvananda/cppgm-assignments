struct Opaque;
typedef int *Pointer;
typedef int (*Callback)(void);

static int read(int, int *, int *, int *);

static int read(int count, int values[static restrict count], int *__restrict other,
    int *__restrict__ third)
{
    restrict Pointer *row = &values;
    int *restrict *extra = &other;
    int *restrict *again = &third;
    Callback *restrict callbacks = 0;
    struct Opaque *restrict unknown = 0;
    void *restrict bytes = 0;

    _Static_assert(_Generic(&values, int *restrict *: 1, default: 0),
        "the adjusted parameter object is restricted");
    _Static_assert(_Generic(values, int *: 1, default: 0),
        "reading the parameter drops its top qualifier");
    return (*row)[1] + **extra + **again + (callbacks != 0) + (unknown != 0) + (bytes != 0);
}

int main(void)
{
    int values[2] = {1, 2};
    int other = 4;
    int third = 8;
    int *p = &third;
    int **plain = &p;
    int *restrict *qualified = plain;
    _Static_assert(_Generic(1 ? plain : qualified, int *restrict *: 1, default: 0),
        "the conditional expression combines pointed-to qualifiers");
    return plain != qualified || read(2, values, &other, *qualified) != 14;
}
