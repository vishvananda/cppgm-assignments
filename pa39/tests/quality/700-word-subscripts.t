// A 32-bit subscript reads only its low word: a parameter used as a
// subscript and in 32-bit arithmetic is not extended on entry.
extern "C" {
struct Big {
    long a, b, c, d;
};
typedef int v4 __attribute__((vector_size(16)));
int load_next(const int* p, int i) { return p[i] + p[i + 1]; }
unsigned load_unsigned(const unsigned* p, unsigned u) { return p[u] + u; }
const int* where(const int* p, int i, int k) { return &p[i] + k; }
v4 lanes(const v4* p, int i) { return p[i]; }
long big_at(const Big* p, unsigned u) { return p[u].c; }
long big_signed(const Big* p, int i) { return p[i].d; }
int choose(const int* p, int i, int j) { return p[i] < p[j] ? i : j; }
}
