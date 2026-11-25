struct Item;
static struct Item *pointers[2];
struct Item { int value; };
typedef struct Item Items[2];

static int sum(columns, values, adjustment)
int adjustment[volatile 2];
int columns;
int values[const static 2][columns];
{
    int n = columns;
    int (*const *rows)[n] = &values;
    int *volatile *steps = &adjustment;
    int marker = 0;
    int cells[(++marker, n)];
    cells[n - 1] = (*rows)[1][n - 1];
    return marker == 1 && sizeof cells == sizeof values[0]
        ? cells[n - 1] + (*steps)[0] : 0;
}

int main(void)
{
    Items items = {{11}, {0}};
    pointers[0] = &items[0];
    int values[2][3] = {{0}, {0, 0, 7}};
    int adjustment[2] = {4, 0};
    return sum(3, values, adjustment) != pointers[0]->value;
}
