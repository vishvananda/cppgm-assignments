// A selection between a value and its increment computed earlier for it
// alone is CINC, and a run of selections of comparisons of the same
// operands shares one comparison.
extern "C" {
// A merge step: one comparison, one CSEL and two CINC.
int merge_step(const int* a, int i, int j, int* out) {
    int x = a[i], y = a[j];
    int ni = i + 1, nj = j + 1;
    *out = x <= y ? x : y;
    int next_j = x <= y ? j : nj;
    int next_i = x <= y ? ni : i;
    return next_i * 1000 + next_j;
}
long count_up(long n, long a, long b) {
    long m = n + 1;
    long t = a * b;
    return t < 100 ? m : n;
}
unsigned count_down(unsigned n, unsigned a, unsigned b) {
    unsigned m = n + 1;
    return a > b ? n : m;
}
int float_step(int n, double a, double b) {
    int m = n + 1;
    return a < b ? m : n;
}
// Comparisons of the same pointers with different predicates.
long span(const char* p, const char* q) {
    const char* lo = p < q ? p : q;
    const char* hi = p >= q ? p : q;
    return hi - lo;
}
// Narrow comparisons keep their own extension per signedness.
int narrow(signed char a, signed char b, unsigned char c, unsigned char d) {
    int x = a < b ? 10 : 20;
    int y = (unsigned char)a < (unsigned char)b ? 30 : 40;
    return x + y + (c < d ? 1 : 0);
}
}
