extern "C" long record(long value);

// The scan runs frameless. Its exit to the call falls into the prologue
// copy, and the framed block follows that copy, so no jump joins them.
extern "C" long scan_then_record(const long* p, long n) {
    long i = 0;
    while (i < n && p[i] >= 0)
        ++i;
    if (i == n)
        return n;
    return record(p[i] + i) * 2;
}
