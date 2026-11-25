struct Cell { unsigned char low : 3, high : 4; unsigned char values[2]; };
struct Grid { struct Cell cells[768][512]; };
struct Box { struct Grid grid; };

constexpr struct Grid original = {
    .cells[700 ... 702][500 ... 504] = { 3, 4, { 10, 11 } },
    .cells[701 ... 703][501 ... 505] = { 5, 6, { 12, 13 } }
};
constexpr struct Box points = {
    .grid = original, .grid.cells[702][502] = { 7, 8, { 20, 21 } },
    .grid.cells[702][503].low = 1, .grid.cells[702][504].values[0] = 0
};
constexpr struct Box last = {
    .grid = points.grid, .grid.cells[702][502].high = 0,
    .grid.cells[702][503].values[1] = 22
};

int main(void)
{
    volatile unsigned row = 702, first = 501, replaced = 502, changed = 503, cleared = 504, last_col = 505;
    return original.cells[row][changed].low != 5 || original.cells[row][changed].high != 6 ||
        points.grid.cells[row][replaced].low != 7 || points.grid.cells[row][replaced].high != 8 ||
        last.grid.cells[row][first].low != 5 || last.grid.cells[row][first].values[1] != 13 ||
        last.grid.cells[row][replaced].low != 7 || last.grid.cells[row][replaced].high != 0 ||
        last.grid.cells[row][replaced].values[0] != 20 || last.grid.cells[row][replaced].values[1] != 21 ||
        last.grid.cells[row][changed].low != 1 || last.grid.cells[row][changed].high != 6 ||
        last.grid.cells[row][changed].values[0] != 12 || last.grid.cells[row][changed].values[1] != 22 ||
        last.grid.cells[row][cleared].low != 5 || last.grid.cells[row][cleared].high != 6 ||
        last.grid.cells[row][cleared].values[0] != 0 || last.grid.cells[row][cleared].values[1] != 13 ||
        last.grid.cells[row][last_col].low != 5 || last.grid.cells[row][last_col].values[1] != 13;
}
