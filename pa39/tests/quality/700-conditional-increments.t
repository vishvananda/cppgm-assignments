// A comparison added to a value, or a selection between a value and its
// increment, is CINC. The driver passes 32-bit arguments whose high bits
// are set and checks that a 32-bit sum returned as 64 bits is zero-extended.
extern "C" {
int count_below(const int* p, int n, int limit) {
    int c = 0;
    for (int i = 0; i < n; ++i)
        c += p[i] < limit;
    return c;
}
int add_less(int x, int a, int b) { return x + (a < b); }
long add_equal(long x, long a, long b) { return x + (a == b); }
unsigned add_below(unsigned x, unsigned a, unsigned b) { return (a < b) + x; }
long add_word(long x, int a, int b) { return x + (a > b); }
int bump_less(int x, int a, int b) {
    if (a < b)
        ++x;
    return x;
}
long bump_pointer_equal(long x, const char* a, const char* b) { return a == b ? x + 1 : x; }
unsigned bump_unless(unsigned x, unsigned a, unsigned b) { return a >= b ? x : x + 1; }
int literal_plus(int a, int b) { return 5 + (a <= b); }
int self_plus(int a, int b) { return a + (a < b); }
unsigned long widened_sum(unsigned x, unsigned a, unsigned b) { return x + (a != b); }
}
