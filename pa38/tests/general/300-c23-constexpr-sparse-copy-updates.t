enum { last_cell = 150000, last_char = 8191 };

struct Cell {
    unsigned edited : 4;
    unsigned kept : 4;
};

struct Record {
    unsigned id;
    struct Cell cells[last_cell + 1];
    char label[last_char + 1];
};

struct Wrapper { struct Record record; };

constexpr struct Record original = {
    .id = 7, .cells[2] = {3, 4}, .cells[last_cell] = {5, 6}, .label = "tile"
};

constexpr struct Wrapper first = {
    .record = original,
    .record.cells[last_cell].edited = 8,
    .record.cells[1].kept = 2,
    .record.label[last_char] = '!'
};

constexpr struct Wrapper second = {
    .record = first.record,
    .record.cells[last_cell].kept = 9,
    .record.cells[2] = { .edited = 10 },
    .record.label[0] = 'T',
    .record.label[last_char] = '.'
};

static_assert(original.id == 7 && first.record.id == 7 && second.record.id == 7);

int main(void)
{
    volatile unsigned last = last_cell, end = last_char;
    return original.cells[last].edited != 5 || original.cells[last].kept != 6 ||
        original.label[end] != 0 || first.record.cells[last].edited != 8 ||
        first.record.cells[last].kept != 6 || first.record.cells[2].kept != 4 ||
        first.record.label[0] != 't' || first.record.label[end] != '!' ||
        second.record.cells[last].edited != 8 || second.record.cells[last].kept != 9 ||
        second.record.cells[1].kept != 2 || second.record.cells[2].edited != 10 ||
        second.record.cells[2].kept != 0 || second.record.cells[last - 1].kept != 0 ||
        second.record.label[0] != 'T' || second.record.label[2] != 'l' ||
        second.record.label[end - 1] != 0 || second.record.label[end] != '.';
}
