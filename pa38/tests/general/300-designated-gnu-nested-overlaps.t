struct Pair { int a, b; };
struct Record { struct Pair pair; int marker; };
static int calls[3];

static int visit(int slot, int value)
{
    ++calls[slot];
    return value;
}

static struct Pair make_pair(void)
{
    ++calls[0];
    return (struct Pair){ 5, 6 };
}

static const struct Record values[] = {
    [0 ... 4].pair.a = 7, [1 ... 5].pair.b = 8,
    [2 ... 3].pair = { 9 }, [3].pair.b = 4
};

static int anchors[2];
struct Leaf { unsigned low : 3, high : 5; int *address; };
struct Middle { int tag; struct Leaf item[2]; };
struct Outer { int prefix; struct Middle middle; };
static const struct Outer tree[6] = {
    [0 ... 4].middle.item[1] = (struct Leaf){ 5, 19, anchors },
    [1 ... 3].middle.item[1].address = 0,
    [2 ... 4].middle.item[1].low = 0,
    [3].middle.item[1] = { .high = 3 },
    [3].middle.item[1].address = anchors + 1,
    [4 ... 5].middle.tag = 7
};

int main(void)
{
    struct Record local[] = {
        [0 ... 4].pair = make_pair(),
        [1 ... 3].pair.b = visit(1, 9), [2].pair = { 11 },
        [3 ... 4].pair.a = visit(2, 4), 12
    };

    return !(values[0].pair.a == 7 && values[0].pair.b == 0 &&
        values[1].pair.a == 7 && values[1].pair.b == 8 &&
        values[2].pair.a == 9 && values[2].pair.b == 0 &&
        values[3].pair.a == 9 && values[3].pair.b == 4 &&
        values[4].pair.a == 7 && values[4].pair.b == 8 &&
        values[5].pair.a == 0 && values[5].pair.b == 8 &&
        local[0].pair.a == 5 && local[0].pair.b == 6 &&
        local[1].pair.a == 5 && local[1].pair.b == 9 &&
        local[2].pair.a == 11 && local[2].pair.b == 0 &&
        local[3].pair.a == 4 && local[3].pair.b == 9 &&
        local[4].pair.a == 4 && local[4].pair.b == 12 && local[4].marker == 0 &&
        calls[0] == 1 && calls[1] == 1 && calls[2] == 1 &&
        tree[0].middle.item[1].low == 5 && tree[0].middle.item[1].address == anchors &&
        tree[1].middle.item[1].high == 19 && tree[1].middle.item[1].address == 0 &&
        tree[2].middle.item[1].low == 0 && tree[2].middle.item[1].high == 19 &&
        tree[3].middle.item[1].low == 0 && tree[3].middle.item[1].high == 3 &&
        tree[3].middle.item[1].address == anchors + 1 &&
        tree[4].middle.item[1].low == 0 && tree[4].middle.item[1].address == anchors &&
        tree[4].middle.tag == 7 && tree[5].middle.tag == 7 && tree[5].middle.item[1].address == 0);
}
