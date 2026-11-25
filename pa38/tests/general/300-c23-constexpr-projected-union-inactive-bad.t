struct Pair { unsigned char a, b; };
union Choice { unsigned short raw; struct Pair pair; };
struct Item { union Choice choice; };
struct Record { struct Item items[200001]; };
struct Copy { struct Record record; };

constexpr struct Record original = {
    .items[0 ... 10].choice.pair = { 1, 2 },
    .items[5].choice.raw = 160
};
constexpr struct Copy checked = {
    .record = original,
    .record.items[2 ... 4].choice.pair.a = 6
};
constexpr struct Copy copy = {
    .record = checked.record,
    .record.items[2 ... 8].choice.pair.a = 3
};
