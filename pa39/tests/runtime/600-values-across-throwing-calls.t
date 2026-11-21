// Many values cross a call that throws only rarely. The handler reads two
// of them; the others are dead once the call throws.
extern "C" void check_value(long value, long limit);

extern "C" __attribute__((noinline)) long mix(const long* data, int count, long limit) {
    long a = 1, b = 2, c = 3, d = 4, e = 5, f = 6, g = 7, h = 8, k = 9, m = 10, seen = 0;
    try {
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
            if (x > limit) check_value(x, limit);
            seen += x;
        }
    } catch (long thrown) {
        return seen * 1000 + thrown + a;
    }
    return a + b * 3 + c * 5 + d * 7 + e * 11 + f * 13 + g * 17 + h * 19 + k * 23 + m * 29;
}
