struct Pair { int x, y; };
struct Entry { struct Pair value; unsigned tag : 3; };

static int calls[4];

static int visit(int index, int value)
{
    ++calls[index];
    return value;
}

static const struct Entry records[] = {
    [1 ... 5].value.y = 4, [2 ... 3].value.y = 8, [4].value.y = 7
};
static int grid[4][5] = {
    [0][1 ... 3] = 3, [0 ... 0][1 ... 3] = 4,
    [0 ... 2][1 ... 3] = 9, [1] = { 6 }
};
static struct Entry tags[4] = { [0 ... 3].tag = 5, [1 ... 2].tag = 7 };

int main(void)
{
    struct Pair pairs[] = {
        [1 ... 5].y = visit(0, 6), [2 ... 3].y = visit(1, 8), [4].y = 9
    };
    int rows[][4] = {
        [1 ... 3][1 ... 2] = visit(2, 3), [2] = { 5 }
    };
    struct Pair continuation[] = { [1 ... 2].y = visit(3, 4), { 6, 7 } };
    struct Pair replaced[] = { [0 ... 2].x = 6, 8, [2] = { 4 }, [3 ... 3].x = 9, 5 };

    return !(sizeof records / sizeof records[0] == 6 && records[0].value.y == 0 &&
        records[1].value.x == 0 && records[1].value.y == 4 && records[2].value.y == 8 &&
        records[3].value.y == 8 && records[4].value.y == 7 && records[5].value.y == 4 &&
        grid[0][0] == 0 && grid[0][1] == 9 && grid[0][4] == 0 && grid[1][0] == 6 &&
        grid[1][2] == 0 && grid[2][3] == 9 && grid[3][3] == 0 &&
        tags[0].tag == 5 && tags[1].tag == 7 && tags[2].tag == 7 && tags[3].tag == 5 &&
        pairs[0].y == 0 && pairs[1].x == 0 && pairs[1].y == 6 && pairs[2].y == 8 &&
        pairs[3].y == 8 && pairs[4].y == 9 && pairs[5].y == 6 &&
        rows[0][1] == 0 && rows[1][1] == 3 && rows[1][2] == 3 && rows[1][3] == 0 &&
        rows[2][0] == 5 && rows[2][1] == 0 && rows[3][2] == 3 &&
        sizeof continuation / sizeof continuation[0] == 4 && continuation[1].y == 4 &&
        continuation[2].y == 4 && continuation[3].x == 6 && continuation[3].y == 7 &&
        replaced[0].x == 6 && replaced[0].y == 0 && replaced[1].x == 6 && replaced[1].y == 0 &&
        replaced[2].x == 4 && replaced[2].y == 0 && replaced[3].x == 9 && replaced[3].y == 5 &&
        calls[0] == 1 && calls[1] == 1 && calls[2] == 1 && calls[3] == 1);
}
