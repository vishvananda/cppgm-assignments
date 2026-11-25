struct Pair { int x, y; };
union Number { int raw; struct Pair pair; };
struct Box { int marker; union Number numbers[3]; };
union Outer { struct Box box; long raw; };
struct Record { int outside; union Outer outer; };

static int marker;
static int calls[4];
static int visit(int id, int value) {
    ++calls[id];
    return value;
}

union Data {
    struct { int *pointer; unsigned x : 3, y : 5; } inner;
    int raw;
};
static union Data data[5] = {
    [0 ... 4].inner.pointer = &marker,
    [0 ... 4].inner.x = 5,
    [0 ... 4].inner.y = 9,
    [1 ... 3].raw = 17,
    [2 ... 3].inner.y = 13,
    [3].inner.pointer = &marker,
};

static union Number base(void) {
    return (union Number){ .pair = { 3, 4 } };
}

static struct Capsule { union Number number; int marker; } stored[4] = {
    [0 ... 3] = (struct Capsule){ .number.pair = { 5, 6 }, .marker = 41 },
    [0 ... 1].number.pair.x = 7,
    [2 ... 3].number.raw = 19,
    [3].number.pair.y = 8,
};

int main(void) {
    union Number numbers[] = {
        [0 ... 4].pair.x = visit(0, 9),
        [0 ... 4].pair.y = 4,
        [2 ... 3].raw = visit(1, 23),
        [3].pair.y = visit(2, 8),
        [1].pair.y = visit(3, 9),
    };
    if (sizeof numbers / sizeof *numbers != 5)
        return 1;
    if (numbers[0].pair.x != 9 || numbers[0].pair.y != 4 ||
        numbers[1].pair.x != 9 || numbers[1].pair.y != 9 ||
        numbers[2].raw != 23 || numbers[3].pair.x != 0 ||
        numbers[3].pair.y != 8 || numbers[4].pair.x != 9 ||
        numbers[4].pair.y != 4)
        return 2;
    if (calls[0] != 1 || calls[1] != 1 || calls[2] != 1 || calls[3] != 1)
        return 3;

    struct Record nested[4] = {
        [0 ... 3].outside = 31,
        [0 ... 3].outer.box.marker = 14,
        [0 ... 3].outer.box.numbers[1].pair.x = 5,
        [1 ... 2].outer.box.numbers[1].raw = 12,
        [2].outer.box.numbers[1].pair.y = 9,
        [3].outer.raw = 28,
        [3].outer.box.marker = 16,
    };
    if (nested[0].outer.box.numbers[1].pair.x != 5 ||
        nested[1].outer.box.numbers[1].raw != 12 ||
        nested[2].outer.box.numbers[1].pair.x != 0 ||
        nested[2].outer.box.numbers[1].pair.y != 9 ||
        nested[2].outer.box.marker != 14 || nested[3].outside != 31 ||
        nested[3].outer.box.numbers[1].pair.x != 0 ||
        nested[3].outer.box.marker != 16)
        return 4;

    union Number inherited[4] = {
        [0 ... 3] = base(),
        [1 ... 2].pair.x = 7,
        [2 ... 3].raw = 20,
        [3].pair.y = 8,
    };
    if (inherited[0].pair.x != 3 || inherited[0].pair.y != 4 ||
        inherited[1].pair.x != 7 || inherited[1].pair.y != 4 ||
        inherited[2].raw != 20 || inherited[3].pair.x != 0 ||
        inherited[3].pair.y != 8)
        return 5;

    if (data[0].inner.pointer != &marker || data[0].inner.x != 5 ||
        data[0].inner.y != 9 || data[1].raw != 17 ||
        data[2].inner.pointer || data[2].inner.x != 0 ||
        data[2].inner.y != 13 || data[3].inner.pointer != &marker ||
        data[3].inner.y != 13 || data[4].inner.x != 5 ||
        data[4].inner.y != 9 || data[4].inner.pointer != &marker)
        return 6;

    if (stored[0].number.pair.x != 7 || stored[0].number.pair.y != 6 ||
        stored[1].number.pair.y != 6 || stored[2].number.raw != 19 ||
        stored[3].number.pair.x != 0 || stored[3].number.pair.y != 8 ||
        stored[3].marker != 41)
        return 7;
    return 0;
}
