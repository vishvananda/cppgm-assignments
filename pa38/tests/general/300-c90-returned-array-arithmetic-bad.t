struct Row { int values[2]; };
struct Row make_row(void);

int main(void)
{
    return *(make_row().values + 1);
}
