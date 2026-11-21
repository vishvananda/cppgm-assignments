// A vector multiply whose product the next instruction adds to an
// accumulator in the same register is MLA, and one it subtracts is MLS. MLA
// reads its accumulator a cycle after another MLA or MLS makes it, but after
// the whole multiply when anything else does, so the pair fuses only where
// no loop-carried chain waits on the product: the sums of scaled_sum,
// scaled_halves and scaled_difference carry their vectors from MLA (or MLS)
// to MLA, and affine_into's accumulator is loaded on each pass. A product
// that first meets another addend, acc + (x * k + c), is MLA, then the add of
// c, where the accumulator is not carried (affine_into); affine_words'
// carried sum keeps the multiply and both adds, so that its chain adds only.
extern "C" {
unsigned scaled_sum(const unsigned* a, unsigned k) {
    unsigned s = 0;
    for (int i = 0; i < 1024; ++i)
        s += a[i] * k;
    return s;
}
unsigned short scaled_halves(const unsigned short* a, unsigned short k) {
    unsigned short s = 0;
    for (int i = 0; i < 1024; ++i)
        s += static_cast<unsigned>(a[i]) * k;
    return s;
}
unsigned scaled_difference(const unsigned* a, unsigned k) {
    unsigned s = 0;
    for (int i = 0; i < 1024; ++i)
        s -= a[i] * k;
    return s;
}
void affine_into(unsigned* __restrict y, const unsigned* a, const unsigned* b, unsigned k, unsigned c) {
    for (int i = 0; i < 1024; ++i)
        y[i] = b[i] + (a[i] * k + c);
}
int affine_words(const int* a, int k, int c) {
    int s = 0;
    for (int i = 0; i < 1024; ++i)
        s += a[i] * k + c;
    return s;
}
}
