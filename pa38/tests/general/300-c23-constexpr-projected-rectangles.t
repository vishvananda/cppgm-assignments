struct Record { unsigned tag; unsigned char cells[1024][1024]; };
struct Box { struct Record value; };
constexpr struct Record original = {
    .tag = 3, .cells[2][3] = 1,
    .cells[1000 ... 1003][1000 ... 1003] = 7,
    .cells[1002 ... 1005][1002 ... 1005] = 6
};
constexpr struct Box first = {
    .value = original,
    .value.cells[1001 ... 1004][1001 ... 1002] = 0,
    .value.cells[1002 ... 1003][1000 ... 1003] = 9
};
constexpr struct Box last = {
    .value = first.value, .value.cells[1002] = { [1000] = 4 }, .value.cells[1005][1004] = 2
};
static_assert(last.value.tag == 3);
int main(void)
{
    volatile unsigned i = 1000, j = 1001, k = 1002, l = 1003, m = 1004, n = 1005, p = 2, q = 3;
    return original.cells[k][k] != 6 || original.cells[j][j] != 7 ||
        first.value.cells[j][j] != 0 || first.value.cells[k][k] != 9 ||
        last.value.cells[i][j] != 7 || last.value.cells[k][i] != 4 ||
        last.value.cells[k][k] != 0 || last.value.cells[k][m] != 0 ||
        last.value.cells[l][k] != 9 || last.value.cells[l][m] != 6 ||
        last.value.cells[m][k] != 0 || last.value.cells[n][m] != 2 ||
        last.value.cells[n][n] != 6 || last.value.cells[p][q] != 1;
}
