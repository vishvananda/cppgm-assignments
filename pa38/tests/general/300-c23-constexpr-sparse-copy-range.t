struct Cell { unsigned char values[128]; };
struct Record { unsigned tag; struct Cell cells[4]; };
struct Wrapper { struct Record record; };

constexpr struct Record original = { .tag = 3, .cells[2].values[120] = 22 };
constexpr struct Wrapper copy = {
    .record = original,
    .record.cells[1 ... 2].values[125] = 8
};

static_assert(copy.record.tag == 3);

int main(void)
{
    volatile int first = 120, last = 125;
    return original.cells[2].values[first] != 22 || original.cells[2].values[last] != 0 ||
        copy.record.cells[2].values[first] != 22 || copy.record.cells[2].values[last] != 8 ||
        copy.record.cells[1].values[last] != 8 || copy.record.cells[0].values[last] != 0;
}
