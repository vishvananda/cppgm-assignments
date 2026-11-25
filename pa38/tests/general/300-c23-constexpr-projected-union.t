struct Pair { unsigned char a, b; };
union Inner { unsigned short raw; struct Pair pair; };
struct Payload { union Inner inner; };
union Outer { unsigned int raw; struct Payload payload; };
struct Row { union Outer value; unsigned char tag; };
struct Record { struct Row items[200001]; };
struct Copy { struct Record record; };

constexpr struct Record original = {
    .items[9 ... 19].value.payload.inner.pair = { 1, 2 },
    .items[10 ... 15].tag = 3,
    .items[9].value.raw = 43
};
constexpr struct Copy point = {
    .record = original, .record.items[12].value = { .payload.inner.pair = { 17, 19 } }
};
constexpr struct Copy first = {
    .record = point.record,
    .record.items[10 ... 14].value.payload.inner.pair.a = 7
};
constexpr struct Copy last = {
    .record = first.record,
    .record.items[12 ... 14].value.payload.inner.pair.b = 8
};

int main(void)
{
    volatile unsigned raw = 9, patched = 12, other = 15;
    return original.items[raw].value.raw != 43 || last.record.items[raw].value.raw != 43 ||
        original.items[patched].value.payload.inner.pair.a != 1 ||
        point.record.items[patched].value.payload.inner.pair.a != 17 ||
        first.record.items[patched].value.payload.inner.pair.a != 7 ||
        first.record.items[patched].value.payload.inner.pair.b != 19 ||
        last.record.items[patched].value.payload.inner.pair.a != 7 ||
        last.record.items[patched].value.payload.inner.pair.b != 8 ||
        last.record.items[patched].tag != 3 ||
        last.record.items[other].value.payload.inner.pair.a != 1 ||
        last.record.items[other].value.payload.inner.pair.b != 2;
}
