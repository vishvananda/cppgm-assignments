// Fourteen sums live across calls. The callee-saved registers hold nine, the
// rest live in frame homes, and the edge into the loop stores those homes'
// zeros from the zero register, two to an instruction, with no register set
// to zero first.
extern "C" long step(long);

extern "C" __attribute__((noinline)) long sums(long n) {
    long a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0;
    long h = 0, i = 0, j = 0, k = 0, l = 0, m = 0, o = 0;
    for (long t = 0; t < n; ++t) {
        a += step(t);
        b += step(a);
        c += step(b);
        d += step(c);
        e += step(d);
        f += step(e);
        g += step(f);
        h += step(g);
        i += step(h);
        j += step(i);
        k += step(j);
        l += step(k);
        m += step(l);
        o += step(m);
    }
    return a ^ b ^ c ^ d ^ e ^ f ^ g ^ h ^ i ^ j ^ k ^ l ^ m ^ o;
}
