struct Item {
    unsigned bits : 3;
    const volatile int *ptr;
    int length;
};

union Choice {
    int inactive;
    struct Item item;
};

struct Outer {
    union Choice choice;
    int values[3];
};

constexpr struct Outer setup = {
    .values = {1, 2, 3},
    .choice.item = {.length = 9, .ptr = nullptr, .bits = 7}
};
extern const struct Outer setup;
constexpr struct Outer copy = setup;
constexpr int extent = copy.choice.item.length;
constexpr unsigned encoded = setup.choice.item.bits;
constexpr int sparse[4096] = {[4095] = extent};

static_assert(extent == 9);
static_assert(encoded == 7);
static_assert(sizeof(unsigned _BitInt(copy.choice.item.length)) == 2);
static_assert(sizeof(int[extent]) == 9 * sizeof(int));

int main(void)
{
    return copy.values[2] != 3 || copy.choice.item.ptr != nullptr ||
        sparse[4094] != 0 || sparse[4095] != 9;
}
