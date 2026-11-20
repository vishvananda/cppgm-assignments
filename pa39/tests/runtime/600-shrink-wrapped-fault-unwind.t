extern "C" long through_call(long n);

// The loop after the call reads its bound through k. Its framed copy
// follows frameless code; a fault there unwinds with the frame's rules.
extern "C" long join_after_call(long n, const long* q, const long* k) {
    long r;
    if (n < 10)
        r = n;
    else
        r = through_call(n);
    for (long i = 0; i < *k; ++i)
        r += q[i] * (i + 1);
    return r;
}

// The framed path sits between frameless blocks; a fault in the one after
// it unwinds with the entry's rules.
extern "C" long call_between(long n, const long* p) {
    if (n > 5)
        return through_call(n) + 1;
    return *p + n;
}
