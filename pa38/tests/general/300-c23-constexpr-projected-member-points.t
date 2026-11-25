struct Bits { unsigned char left : 3, right : 4; };
struct Cell { struct Bits bits; unsigned char values[2]; };
struct Record { struct Cell cells[200001]; };
struct Box { struct Record value; };

constexpr struct Record original = {
    .cells[10 ... 20].bits.left = 7, .cells[12 ... 22].bits.right = 9,
    .cells[14].values[0] = 27, .cells[15].values[0] = 15
};
constexpr struct Box points = {
    .value = original, .value.cells[12].bits.left = 1, .value.cells[14].values[1] = 30,
    .value.cells[15] = { 0 }, .value.cells[16].bits = { .right = 5 }
};
constexpr struct Box range = {
    .value = points.value, .value.cells[12 ... 15].bits.right = 2
};
constexpr struct Box last = {
    .value = range.value, .value.cells[12].values[1] = 6, .value.cells[14].bits.left = 0
};

int main(void)
{
    volatile unsigned first = 12, middle = 14, cleared = 15, replaced = 16;
    return original.cells[first].bits.left != 7 || original.cells[first].bits.right != 9 ||
        points.value.cells[first].bits.left != 1 || points.value.cells[first].bits.right != 9 ||
        last.value.cells[first].bits.left != 1 || last.value.cells[first].bits.right != 2 ||
        last.value.cells[first].values[1] != 6 || last.value.cells[middle].bits.left != 0 ||
        last.value.cells[middle].bits.right != 2 || last.value.cells[middle].values[0] != 27 ||
        last.value.cells[middle].values[1] != 30 || last.value.cells[cleared].bits.left != 0 ||
        last.value.cells[cleared].bits.right != 2 || last.value.cells[cleared].values[0] != 0 ||
        last.value.cells[replaced].bits.left != 0 || last.value.cells[replaced].bits.right != 5;
}
