typedef int Cell;
static int *const at_file_scope = (static Cell[]){ 5, 9 };
static unsigned long width = sizeof (static Cell){ 7 };

static Cell *static_cell(void)
{
    return &(static Cell){ 13 };
}

static int check_automatic(void)
{
    unsigned calls = 0;
    int visit = 0;
again:
    int *value = &(Cell){ ++calls };
    if (*value != visit + 1)
        return 1;
    *value = -1;
    if (++visit < 3)
        goto again;
    if (calls != 3 || (register int){ ++calls } != 4 || calls != 4)
        return 2;
    return 0;
}

int main(void)
{
    if (width != sizeof(Cell) || at_file_scope[1] != 9)
        return 1;
    Cell *first = static_cell();
    if (*first != 13)
        return 2;
    *first = 17;
    if (first != static_cell() || *static_cell() != 17)
        return 3;
    return check_automatic();
}
