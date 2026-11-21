// More values cross a call inside the loop than there are preserved
// registers. The call runs on a few iterations only.
extern "C" void note(long value);

extern "C" __attribute__((noinline)) long crowded(const long* data, int count, long limit) {
    long a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, k = 9, m = 10, p = 11, q = 12;
    for (int i = 0; i < count; ++i) {
        const long x = data[i];
        a += x;
        b ^= x * 3;
        c += b >> 1;
        d -= a ^ c;
        e += c ^ d;
        f += e >> 2;
        g ^= f + i;
        h += g * 5;
        k -= h >> 3;
        m += k ^ a;
        p ^= m + x;
        q += p >> 1;
        if (x > limit) note(x);
    }
    return a + b * 3 + c * 5 + d * 7 + e * 11 + f * 13 + g * 17 + h * 19 + k * 23 + m * 29 + p * 31 + q * 37;
}
