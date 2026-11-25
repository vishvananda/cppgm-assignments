struct Row { int values[2]; };
struct Row make_row(void);

int main(int argc, char **argv)
{
    (void)argv;
    (void)(argc > 1 ? make_row().values : make_row().values);
    return 0;
}
