struct Bits { unsigned int low : 3, high : 5; };
struct Cell { struct Bits bits; unsigned char mark; };
struct Box { struct Cell rows[6]; };
struct Copy { struct Box box; };

constexpr struct Copy seed = {
    .box.rows[1 ... 4].bits = { 5, 17 },
    .box.rows[1 ... 4].mark = 11
};
constexpr struct Copy low_zero = {
    .box = seed.box, .box.rows[1 ... 3].bits.low = 0
};
constexpr struct Copy point = {
    .box = low_zero.box, .box.rows[2].bits.high = 3
};
constexpr struct Copy unmarked = {
    .box = point.box, .box.rows[2 ... 3].mark = 0
};
constexpr struct Copy branch = {
    .box = low_zero.box, .box.rows[2 ... 4].bits.high = 0
};
constexpr struct Copy marked = { .box.rows[2 ... 3].mark = 9 };
constexpr struct Copy erased = {
    .box = marked.box, .box.rows[1 ... 4].mark = 0
};
constexpr struct Copy partly_erased = {
    .box = marked.box, .box.rows[3 ... 4].mark = 0
};

const struct Copy *const volatile snapshots[] = {
    &branch, &unmarked, &point, &low_zero, &seed, &erased, &partly_erased, &marked
};

int main(void)
{
    const struct Copy *other = snapshots[0];
    const struct Copy *latest = snapshots[1];
    const struct Copy *middle = snapshots[2];
    const struct Copy *first = snapshots[3];
    const struct Copy *original = snapshots[4];
    return other == latest || latest == middle || middle == first || first == original ||
        other->box.rows[2].bits.low != 0 || other->box.rows[2].bits.high != 0 ||
        other->box.rows[2].mark != 11 ||
        latest->box.rows[2].bits.low != 0 || latest->box.rows[2].bits.high != 3 ||
        latest->box.rows[2].mark != 0 || latest->box.rows[1].mark != 11 ||
        middle->box.rows[2].bits.high != 3 || middle->box.rows[2].mark != 11 ||
        first->box.rows[2].bits.low != 0 || first->box.rows[2].bits.high != 17 ||
        original->box.rows[2].bits.low != 5 || original->box.rows[2].bits.high != 17 ||
        latest->box.rows[4].bits.low != 5 || latest->box.rows[4].bits.high != 17 ||
        latest->box.rows[5].mark != 0 || snapshots[5]->box.rows[2].mark != 0 ||
        snapshots[6]->box.rows[2].mark != 9 || snapshots[6]->box.rows[3].mark != 0 ||
        snapshots[7]->box.rows[3].mark != 9;
}
