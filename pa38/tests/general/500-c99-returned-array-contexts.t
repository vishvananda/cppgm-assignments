struct Row { char values[17]; };
static struct Row row = { { 17, 25 } };

static struct Row make_row(void)
{
    return row;
}

int main(int argc, char **argv)
{
    (void)argv;
    return sizeof(make_row().values) != 17 ||
           sizeof(0, make_row().values) != sizeof(char *) ||
           *(&make_row().values[0]) != 17 ||
           *((argc > 1 ? row.values : make_row().values) + 1) != 25;
}
