// A literal that the instruction reading it cannot encode is built once,
// before the loop, and read from a register on every pass: the compares
// with 5000 (beyond CMP's twelve-bit immediate) and the selects of 4321
// (CSEL reads registers, or zero).
extern "C" unsigned settle(const unsigned* in, int n) {
    unsigned x = 1, y = 2, z = 3;
    for (int i = 0; i < n; ++i) {
        x = (x ^ in[i]) > 5000 ? (x ^ in[i]) >> 1 : 4321;
        y = (y + in[i]) > 5000 ? (y + in[i]) >> 2 : 4321;
        z = (z - in[i]) > 5000 ? (z - in[i]) >> 3 : 4321;
    }
    return x + y * 3 + z * 5;
}
