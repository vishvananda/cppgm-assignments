// An extension of a 32-bit or narrower subscript read only by the next
// index is the index's extended register.
extern "C" {
struct Pair {
    double x, y;
};
double pick(const Pair* p, const int* map, int i, int k) { return p[map[i] - k].y; }
double sum_at(const Pair* p, int i, int k) {
    const Pair& q = p[i - k];
    return q.x + q.y;
}
const Pair* where(const Pair* p, int i, int k) { return &p[i + k]; }
const Pair* where_unsigned(const Pair* p, unsigned i, unsigned k) { return &p[i + k]; }
int load_at(const int* p, int i, int k) { return p[i * k]; }
long load_unsigned(const long* p, unsigned i, unsigned k) { return p[i * k]; }
char byte_at(const char* p, short i) { return p[i]; }
char byte_unsigned(const char* p, unsigned short i, unsigned short k) { return p[(unsigned short)(i + k)]; }
const Pair* where_short(const Pair* p, short i, short k) { return &p[(short)(i - k)]; }
typedef int v4 __attribute__((vector_size(16)));
v4 lanes_at(const v4* p, int i, int k) { return p[i - k]; }
void lanes_store(v4* p, unsigned i, unsigned k, v4 v) { p[i + k] = v; }
}
