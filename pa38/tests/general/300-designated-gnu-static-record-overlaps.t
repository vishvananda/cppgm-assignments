static int anchors[2];

struct Entry {
    unsigned low : 3, high : 5;
    int cells[2];
    int *address;
    unsigned char padding[1048576];
};

static const struct Entry entries[] = {
    [0 ... 4] = (struct Entry){ .low = 5, .high = 11, .cells = { 3, 4 }, .address = anchors },
    [1 ... 2].low = 0,
    [2 ... 3].high = 6,
    [2].address = anchors + 1,
    [3].cells = { 7 },
    [4] = { .low = 2 }
};

struct __attribute__((packed)) Tag { unsigned low : 3, high : 9; unsigned char tail; };
static const struct Tag tags[] = {
    [0 ... 3] = (struct Tag){ 5, 511, 123 }, [0].low = 0, [1].high = 18, [2].tail = 0
};

int main(void)
{
    const volatile struct Entry *row = entries;
    return !(row[0].low == 5 && row[0].high == 11 && row[0].cells[0] == 3 && row[0].address == anchors &&
        row[1].low == 0 && row[1].high == 11 && row[1].cells[1] == 4 && row[1].address == anchors &&
        row[2].low == 0 && row[2].high == 6 && row[2].cells[0] == 3 && row[2].address == anchors + 1 &&
        row[3].low == 5 && row[3].high == 6 && row[3].cells[0] == 7 && row[3].cells[1] == 0 &&
        row[3].address == anchors && row[3].padding[1048575] == 0 &&
        row[4].low == 2 && row[4].high == 0 && row[4].cells[0] == 0 && row[4].address == 0 &&
        tags[0].low == 0 && tags[0].high == 511 && tags[0].tail == 123 &&
        tags[1].low == 5 && tags[1].high == 18 && tags[1].tail == 123 &&
        tags[2].high == 511 && tags[2].tail == 0 && tags[3].low == 5 && tags[3].high == 511);
}
