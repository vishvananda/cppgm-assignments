// A value merged at a join, from a frame home on one edge, crosses only a
// call to a leaf of this unit that takes eight arguments. The leaf leaves
// x12 to x14 alone, so the value stays in one of them across the call. The
// edge's copy from the home stays even when another register holds the
// home: the leaf call does not end that value.
extern "C" long step(long x);

static __attribute__((noinline)) long leaf(long a, long b, long c, long d, long e, long f, long g, long h) {
    return a * 5 + b + c * 2 + d + e * 3 + f + g * 7 + h * 11;
}

long seen;

extern "C" __attribute__((noinline)) long merge(const long* p, long c) {
    long a0 = p[0], a1 = p[1], a2 = p[2], a3 = p[3], a4 = p[4], a5 = p[5], a6 = p[6], a7 = p[7];
    long a8 = p[8], a9 = p[9], a10 = p[10], a11 = p[11], a12 = p[12], a13 = p[13], a14 = p[14], a15 = p[15];
    long r = step(a0);
    long s = a0 ^ a1 ^ a2 ^ a3 ^ a4 ^ a5 ^ a6 ^ a7 ^ a8 ^ a9 ^ a10 ^ a11 ^ a12 ^ a13 ^ a14 ^ a15;
    long q = a0 | a1 | a2 | a3 | a4 | a5 | a6 | a7 | a8 | a9 | a10 | a11 | a12 | a13 | a14 | a15;
    r += step(s + q);
    long v;
    if (c > 100)
        v = c;
    else {
        seen = a15;
        v = a15 * 2;
    }
    long t = leaf(r, a1, a2, a3, a4, a5, a6, a7);
    return v * 7 + t + a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 + a14 + a15;
}
