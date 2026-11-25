struct Pair { int x, y; };
struct Flags { unsigned low : 3, high : 4; };
struct Holder { struct Pair pair[3]; };
static int calls[5];

static int visit(int id, int value)
{
    ++calls[id];
    return value;
}

static struct Pair make_pair(void)
{
    ++calls[3];
    return (struct Pair){ 7, 8 };
}

static const struct Pair table[] = {
    [1 ... 5] = { 3, 4 }, [2 ... 4].y = 9, [3] = { 7 }, [4].x = 6
};
static const struct Flags mask[] = {
    [0 ... 2].low = 5, [1 ... 3].high = 9, [2].low = 2
};
static const struct Pair literals[] = {
    [0 ... 2] = (struct Pair){ 1, 2 }, [1 ... 2].x = 3, [2] = { 4 }
};

int main(void)
{
    struct Pair points[] = {
        [1 ... 4].x = visit(0, 7), 8, 9,
        [2 ... 3].y = visit(1, 4), [3] = { 5, visit(2, 6) }
    };
    struct Pair copied[] = {
        [1 ... 4] = make_pair(), [2].x = 3, [3] = { 5 }
    };
    struct Pair elided[] = { [0 ... 2] = visit(4, 2), 6 };
    struct Flags flags[] = { [0 ... 2].low = 5, [1 ... 3].high = 9, [2].low = 2 };
    const struct Holder base = { { { 1, 2 }, { 3, 4 }, { 5, 6 } } };
    struct { struct Holder item; } inherited = {
        .item = base, .item.pair[0 ... 2].x = 7, .item.pair[1] = { 9 }
    };

    return !(points[0].x == 0 && points[0].y == 0 && points[1].x == 7 && points[1].y == 0 &&
        points[2].x == 7 && points[2].y == 4 && points[3].x == 5 && points[3].y == 6 &&
        points[4].x == 7 && points[4].y == 8 && points[5].x == 9 && points[5].y == 0 &&
        copied[1].x == 7 && copied[1].y == 8 && copied[2].x == 3 && copied[2].y == 8 &&
        copied[3].x == 5 && copied[3].y == 0 && copied[4].x == 7 && copied[4].y == 8 &&
        elided[0].x == 2 && elided[0].y == 0 && elided[1].x == 2 && elided[1].y == 0 &&
        elided[2].x == 2 && elided[2].y == 6 &&
        table[0].x == 0 && table[0].y == 0 && table[1].x == 3 && table[1].y == 4 &&
        table[2].x == 3 && table[2].y == 9 && table[3].x == 7 && table[3].y == 0 &&
        table[4].x == 6 && table[4].y == 9 && table[5].x == 3 && table[5].y == 4 &&
        flags[0].low == 5 && flags[0].high == 0 && flags[1].low == 5 && flags[1].high == 9 &&
        flags[2].low == 2 && flags[2].high == 9 && flags[3].low == 0 && flags[3].high == 9 &&
        mask[0].low == 5 && mask[0].high == 0 && mask[1].low == 5 && mask[1].high == 9 &&
        mask[2].low == 2 && mask[2].high == 9 && mask[3].low == 0 && mask[3].high == 9 &&
        literals[0].x == 1 && literals[1].x == 3 && literals[1].y == 2 && literals[2].y == 0 &&
        inherited.item.pair[0].x == 7 && inherited.item.pair[0].y == 2 &&
        inherited.item.pair[1].x == 9 && inherited.item.pair[1].y == 0 && inherited.item.pair[2].y == 6 &&
        calls[0] == 1 && calls[1] == 1 && calls[2] == 1 && calls[3] == 1 && calls[4] == 1);
}
