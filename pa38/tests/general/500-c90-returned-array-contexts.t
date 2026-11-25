struct Row { char values[17]; };
static struct Row row = { { 17, 25 } };

static struct Row make_row(void)
{
    return row;
}

int main(void)
{
    int sum = __extension__ (make_row().values[0] + 1[make_row().values]);
    return sizeof(0, make_row().values) != 17 ||
           sizeof(0, row.values) != sizeof(char *) || sum != 42;
}
