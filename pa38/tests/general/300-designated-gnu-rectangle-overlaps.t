static int calls[3];

static int visit(int id, int value)
{
    ++calls[id];
    return value;
}

static const int grid[][5] = {
    [1 ... 4][0 ... 3] = 7, [2 ... 3][2 ... 4] = 9, [3] = { 4 }, [0][4] = -1
};
static const char labels[][5] = {
    [1 ... 4] = "abc", [2][1 ... 2] = 'x', [3] = { "w" }, [2][0] = 'z'
};

struct Pair { int x, y; };
static const struct Pair pairs[3][4] = {
    [0 ... 2][1 ... 2] = { 3, 4 }, [1][0 ... 1] = { 8 }, [2] = { { 9, 8 } }
};

static const int levels[3][4][5] = {
    [0 ... 2] = { [0 ... 3] = { [0 ... 4] = 7 } },
    [0][1][2] = 0,
    [1][3][4] = 13,
    [2][0] = { 3 }
};

int main(void)
{
    int array[][5] = {
        [0 ... 2][1 ... 3] = visit(0, 8), 9, 10,
        [1][2 ... 4] = visit(1, 5), [2][0] = visit(2, 6)
    };
    char words[][5] = {
        [0 ... 3] = "ace", [0 ... 1][1 ... 2] = 'o', [1] = "b", [3][2] = 'd'
    };

    return !(sizeof array / sizeof array[0] == 4 &&
        array[0][0] == 0 && array[0][1] == 8 && array[0][3] == 8 && array[0][4] == 0 &&
        array[1][1] == 8 && array[1][2] == 5 && array[1][4] == 5 &&
        array[2][0] == 6 && array[2][1] == 8 && array[2][3] == 8 && array[2][4] == 9 &&
        array[3][0] == 10 && array[3][1] == 0 && calls[0] == 1 && calls[1] == 1 && calls[2] == 1 &&
        grid[0][0] == 0 && grid[0][4] == -1 && grid[1][3] == 7 && grid[1][4] == 0 &&
        grid[2][1] == 7 && grid[2][2] == 9 && grid[2][4] == 9 && grid[3][0] == 4 && grid[3][1] == 0 &&
        grid[4][2] == 7 && grid[4][4] == 0 &&
        labels[0][0] == 0 && labels[1][2] == 'c' && labels[2][0] == 'z' &&
        labels[2][1] == 'x' && labels[2][2] == 'x' && labels[2][3] == 0 && labels[3][0] == 'w' &&
        labels[3][1] == 0 && labels[4][1] == 'b' &&
        pairs[0][0].x == 0 && pairs[0][2].x == 3 && pairs[0][2].y == 4 &&
        pairs[1][0].x == 8 && pairs[1][1].y == 0 && pairs[1][2].y == 4 &&
        pairs[2][0].x == 9 && pairs[2][0].y == 8 && pairs[2][1].x == 0 &&
        words[0][0] == 'a' && words[0][2] == 'o' && words[1][0] == 'b' && words[1][1] == 0 &&
        levels[0][1][2] == 0 && levels[0][1][3] == 7 && levels[1][3][4] == 13 &&
        levels[1][3][3] == 7 && levels[2][0][0] == 3 && levels[2][0][1] == 0 && levels[2][1][1] == 7 &&
        words[2][1] == 'c' && words[3][0] == 'a' && words[3][1] == 'c' && words[3][2] == 'd');
}
