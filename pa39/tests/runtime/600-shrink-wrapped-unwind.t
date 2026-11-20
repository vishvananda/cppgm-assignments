extern "C" void maybe_throw(long value);
extern "C" void adjust(long* cell, long by);

// The early return needs no frame. Either call may throw once the frame
// is set up.
extern "C" long early_or_call(long n, long m) {
    if (n < 4) return n + 1;
    long a = n * 3, b = m ^ n, c = n + m;
    maybe_throw(c);
    long d = a + b;
    maybe_throw(d - 1000);
    return a + b + c + d;
}

// The loop keeps its sum in a callee-saved register for the calls, so the
// frame comes before it.
extern "C" long sum_then_call(const long* p, long n) {
    long s = 0;
    for (long i = 0; i < n; ++i) s += p[i] * 3;
    if (s >= 0) return s;
    for (long i = 0; i < n; ++i) maybe_throw(p[i] + s);
    return -s;
}

extern "C" long count_then_call(const long* p, long n, long limit) {
    long k = n;
    while (k > 0 && p[k - 1] < limit) --k;
    if (k == 0) return limit;
    for (long i = 0; i < k; ++i) maybe_throw(p[i] - limit + i);
    return k + limit;
}

// Two framed paths follow the early return.
extern "C" long two_paths(long k, long v) {
    if (k == 0) return v;
    if (k > 100) {
        long w = v * 5;
        maybe_throw(w);
        return w + k;
    }
    long cell = v;
    adjust(&cell, k);
    return cell - k;
}
