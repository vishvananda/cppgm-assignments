// A pair forwards neither half before both halves have their data. `carried`
// keeps a counter and a slower sum in adjacent words, and each pass of its
// loop reads what the pass before stored: every word is loaded and stored
// alone, so the counter does not wait for the sum. Clang pairs them, so the
// bound is on this compiler's code only. `walked` moves its pointer, and no
// later pass reads what it stores: its adjacent words pair.
extern "C" void carried(long* state, long* log, long n) {
    for (long i = 0; i < n; ++i) {
        long count = state[0], sum = state[1];
        state[0] = count + 1;
        state[1] = sum + count * count * count;
        log[i] = count;
    }
}

extern "C" long walked(long* p) {
    long total = 0;
    for (; p[0]; p += 2) {
        long a = p[0], b = p[1];
        p[0] = b;
        p[1] = a + 1;
        total += a ^ b;
    }
    return total;
}
