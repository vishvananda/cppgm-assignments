static unsigned tally;
struct Mark {
    unsigned value;
    ~Mark() { tally += value; }
};
static __attribute__((noinline)) unsigned risky(unsigned value) {
    if (value & 4u) throw value;
    return value * 3u + 1u;
}

// Every landing path reads values defined before its throwing calls. Mutually
// exclusive cases can share storage, but a successful-call store must not kill
// a value needed when that call throws.
extern "C" __attribute__((noinline)) unsigned eh_cases(unsigned value, unsigned mode) {
    unsigned kept = value * 7u + 3u;
    volatile unsigned stamp = value ^ 0x1357u;
    switch (value & 15u) {
#define CASE(n) case n: { unsigned left = kept + n; Mark guard = {left}; \
    try { unsigned first = risky(value + n); unsigned live = first ^ kept; \
        unsigned second = risky(first + mode); return live + second + left + stamp; } \
    catch (unsigned error) { return error + left + stamp + kept; } }
        CASE(0) CASE(1) CASE(2) CASE(3) CASE(4) CASE(5) CASE(6) CASE(7)
        CASE(8) CASE(9) CASE(10) CASE(11) CASE(12) CASE(13) CASE(14) CASE(15)
#undef CASE
    }
    return 0;
}

extern "C" unsigned observe(unsigned value, unsigned mode) {
    unsigned kept = value * 7u + 3u, left = kept + (value & 15u);
    unsigned stamp = value ^ 0x1357u, first = value + (value & 15u), expected;
    if (first & 4u) expected = first + left + stamp + kept;
    else {
        first = first * 3u + 1u;
        unsigned second = first + mode;
        expected = second & 4u ? second + left + stamp + kept
            : (first ^ kept) + second * 3u + 1u + left + stamp;
    }
    tally = 0;
    unsigned actual = eh_cases(value, mode);
    return actual == expected && tally == left ? 17 : 1;
}
