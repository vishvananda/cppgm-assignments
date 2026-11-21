// An access at offset zero and an adjacent increment of its base are one
// access with post- or pre-index writeback.
extern "C" {
// The partition step of std::sort: swap, then advance both cursors.
int* swap_step(int* first, int* last) {
    int a = *first, b = *last;
    *first = b;
    *last = a;
    return first + 1;
}
long walk(const long* p, const long* end) {
    long s = 0;
    while (p != end) {
        s += *p;
        ++p;
    }
    return s;
}
double* store_down(double* p, double v) {
    --p;
    *p = v;
    return p;
}
const unsigned char* bytes(const unsigned char* p, unsigned* out) {
    *out = *p;
    return p + 1;
}
}
