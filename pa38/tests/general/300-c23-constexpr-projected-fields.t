struct Cell { unsigned char first, second; };
struct Record { unsigned tag; struct Cell cells[500001]; };
struct Box { struct Record value; };
constexpr struct Record original = {
    .tag = 3, .cells[2] = { 12, 32 },
    .cells[499990 ... 499999].first = 7, .cells[499995 ... 500000].second = 6
};
constexpr struct Box first = {
    .value = original, .value.cells[499992 ... 499997].first = 0,
    .value.cells[499996 ... 499999].second = 9
};
constexpr struct Box last = {
    .value = first.value, .value.cells[499993] = { 4, 5 }, .value.cells[499996] = { 0 }
};
static_assert(last.value.tag == 3);
int main(void)
{
    volatile unsigned i = 499990, j = 499994, k = 499996, m = 500000, n = 499993, p = 499998, q = 2;
    return original.cells[i].first != 7 || original.cells[j].first != 7 ||
        original.cells[k].first != 7 || original.cells[k].second != 6 ||
        first.value.cells[k].first != 0 || first.value.cells[k].second != 9 ||
        last.value.cells[n].first != 4 || last.value.cells[n].second != 5 ||
        last.value.cells[j].first != 0 || last.value.cells[j].second != 0 ||
        last.value.cells[k].first != 0 || last.value.cells[k].second != 0 ||
        last.value.cells[p].first != 7 || last.value.cells[p].second != 9 ||
        last.value.cells[m].first != 0 || last.value.cells[m].second != 6 ||
        last.value.cells[q].first != 12 || last.value.cells[q].second != 32;
}
