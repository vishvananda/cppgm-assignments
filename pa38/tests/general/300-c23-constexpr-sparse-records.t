struct Record {
    unsigned tag : 3;
    unsigned char table[400123];
};

union Choice {
    int unused;
    struct Record record;
};

constexpr union Choice first = {
    .record = { .tag = 5, .table[2] = 12, .table[400122] = 4 }
};
constexpr struct Record copy = first.record;
enum { tag = (constexpr struct Record){ .tag = 7, .table[400122] = 15 }.tag };

static_assert(first.record.tag == 5);
static_assert(copy.tag == 5);
static_assert(tag == 7);

int main(void)
{
    const struct Record *literal = &(static constexpr struct Record){
        .tag = 6, .table[400122] = 11, .table[1200] = 10
    };
    volatile unsigned early = 2, last = 400122;
    return copy.table[last] != 4 || copy.table[early] != 12 ||
        first.record.table[last - 1] != 0 || literal->tag != 6 ||
        literal->table[last] != 11 || literal->table[1200] != 10 ||
        literal->table[1000] != 0;
}
