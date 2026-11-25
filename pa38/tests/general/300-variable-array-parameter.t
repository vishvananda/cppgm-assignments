static int sum(int rows, int columns, int values[*][*]);
static int sum(int rows, int columns, int values[rows][columns]);

static int sum(int rows, int columns, int values[static rows++][columns++])
{
    return rows == 3 && columns == 5 && sizeof values[0] == 4 * sizeof(int)
        ? values[0][3] + values[1][3] : 0;
}

static int first(int *bound, int values[(*bound)++][3])
{
    return *bound == 3 ? values[1][2] : 0;
}

int main(void)
{
    int values[2][4] = {{1, 2, 3, 4}, {5, 6, 7, 8}};
    int narrow[2][3] = {{0}, {0, 0, 17}};
    int bound = 2;
    return !(sum(2, 4, values) == 12 && first(&bound, narrow) == 17 && bound == 3);
}
