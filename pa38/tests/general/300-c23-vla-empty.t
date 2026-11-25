struct Cell {
    char small;
    int *pointer;
    double value;
    unsigned bits : 3;
};

int main(void)
{
    int n = 3;
    const volatile struct Cell cells[2][n++] = {};
    if (n != 4 || sizeof cells != 6 * sizeof(struct Cell))
        return 1;
    if (cells[1][2].small || cells[1][2].pointer ||
        cells[1][2].value != 0.0 || cells[1][2].bits)
        return 2;

    const volatile unsigned char *bytes = (const volatile unsigned char *)cells;
    for (typeof(sizeof cells) i = 0; i < sizeof cells; ++i)
        if (bytes[i] != 0)
            return 3;
    return 0;
}
