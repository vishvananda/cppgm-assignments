struct Pair { int x, y; };
static int calls[4];

static int visit(int index, int value)
{
    ++calls[index];
    return value;
}

static struct Pair make_pair(void)
{
    ++calls[0];
    return (struct Pair){ 7, 8 };
}

static const struct Pair shared[] = {
    [1 ... 4] = { .x = 2, .y = 3 }, [2] = { 5 }, { 9, 10 }
};
static int matrix[4][4] = { [0 ... 2] = { [1 ... 2] = 5 }, [1] = { 6 } };
static char labels[4][5] = { [1 ... 3] = "ok" };

int main(void)
{
    volatile struct Pair values[] = {
        [2].x = visit(3, 99), [0 ... 5] = make_pair(),
        [1] = { visit(1, 4) }, [3 ... 4] = { visit(2, 9), 10 }, { 11, 12 }
    };
    int rows[][4] = { [0 ... 3] = { [1 ... 2] = 6 }, [1] = { 2 } };
    char words[5][4] = { [1 ... 3] = "yes", [2] = "no" };
    union Payload { int i; double d; } payloads[3] = {
        [0 ... 2] = { .d = 2.5 }, [1] = { .i = 7 }
    };

    return !(values[0].x == 7 && values[0].y == 8 && values[1].x == 4 && values[1].y == 0 &&
        values[2].x == 7 && values[3].x == 9 && values[4].y == 10 && values[5].x == 11 && values[5].y == 12 &&
        calls[0] == 1 && calls[1] == 1 && calls[2] == 1 && calls[3] <= 1 &&
        shared[0].x == 0 && shared[1].x == 2 && shared[1].y == 3 && shared[2].x == 5 && shared[2].y == 0 &&
        shared[3].x == 9 && shared[4].y == 3 && sizeof shared / sizeof shared[0] == 5 &&
        rows[0][2] == 6 && rows[1][0] == 2 && rows[1][1] == 0 && rows[2][1] == 6 && rows[3][2] == 6 &&
        matrix[0][1] == 5 && matrix[1][0] == 6 && matrix[1][2] == 0 && matrix[2][1] == 5 && matrix[3][2] == 0 &&
        labels[0][0] == 0 && labels[3][1] == 'k' && labels[2][2] == 0 &&
        words[1][2] == 's' && words[2][0] == 'n' && words[2][2] == 0 && words[3][1] == 'e' &&
        payloads[0].d == 2.5 && payloads[1].i == 7 && payloads[2].d == 2.5);
}
