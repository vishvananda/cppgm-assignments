struct Outer {
    struct Inner { int value; } inner;
    enum State { initial = 1, final } state;
};

struct Outer {
    struct Inner { signed int value; } inner;
    enum State { final = 2, initial = 1 } state;
};

static struct Outer object = { { 6 }, final };

typedef struct Blob { int count; unsigned char data[]; } Blob;
typedef struct Blob { signed int count; unsigned char data[]; } Blob;
static Blob blob = { .count = 8 };

int main(void)
{
    struct Inner inner = object.inner;
    struct Local { struct Local *next; int value; };
    struct Local end = { nullptr, inner.value };
    struct Local { struct Local *next; signed int value; } first = { &end, object.state };
    return first.next->value + first.value != blob.count;
}
