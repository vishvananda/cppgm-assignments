// Comparisons, divisions and selections of 32-bit values read W registers,
// so a value whose readers are all of these, or arithmetic, is not
// zero-extended first. The driver passes arguments whose high bits are set.
extern "C" {
int below(unsigned a, unsigned b) { return a < b; }
int less(int a, int b) { return a < b; }
int is_ten(int a) { return a == 10; }
int at_least(int a, int b) { return a + 1 >= b; }
int quotient(int a, int b) { return a / b; }
unsigned uquotient(unsigned a, unsigned b) { return a / b; }
int remainder_of(int a, int b) { return a % b; }
unsigned uremainder_of(unsigned a, unsigned b) { return a % b; }
int third(int a) { return a / 3; }
int larger(int a, int b) { return a > b ? a : b; }
unsigned pick(int c, unsigned a, unsigned b) { return c ? a : b; }
unsigned pick_sum(int c, unsigned a, unsigned b) { return c > 0 ? a + b : a; }
void flag(int a, int b, int* p) {
    if (a < b)
        *p = 1;
}
int count_below(const int* p, int n, int limit) {
    int c = 0;
    for (int i = 0; i < n; ++i)
        c += p[i] < limit;
    return c;
}
int guarded(const int* p, int i, int n) { return i < n ? p[i] : -1; }
long widened(int a, int b) { return (long)(a < b ? a : b) * 3; }
unsigned long zero_extended(unsigned a, unsigned b) { return a < b ? b : a; }
}
