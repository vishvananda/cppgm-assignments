static int cells[4] = {0, 0, 0, 19};
static int calls;

static int (*read_row(void))[4]
{
    ++calls;
    return &cells;
}

int main(void)
{
    int n = 3;
    int (*(*reader)(void))[++n] = read_row;
    if (n != 4 || sizeof *reader() != sizeof cells || calls != 1)
        return 1;
    return (*reader())[3] != 19 || calls != 2;
}
