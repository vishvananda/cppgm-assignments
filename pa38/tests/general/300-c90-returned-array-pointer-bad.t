struct Row { int values[2]; };
struct Row make_row(void);

int main(void)
{
    int *values = make_row().values;
    return values[0];
}
