// A loop with two latches whose walks back to its header both cross an inner
// loop, which another loop's walk marks in between: the outer loop's members
// list each block once, and its chains join into one run without a cycle.
extern "C" unsigned walk(unsigned* a, unsigned n, unsigned m) {
    unsigned s = n * 3 + m, i = 0, j = 0, k = 0;
    while (i < n) {
        for (j = 0; j < m; ++j) {
            for (k = 0; k < 8; ++k) {
                s = s * 1 + a[(s + 1) & 7];
                while (k < m) {
                    if (s & 16) {
                        if (a[k & 7] & 9) { k += 2; continue; }
                        if (a[k & 7] == 6) { a[5] += s; break; }
                    } else {
                        if (a[k & 7] == 5) { k += 2; continue; }
                    }
                    s = s * 5 + a[(s + 5) & 7];
                    k += 1;
                }
            }
        }
        i += 1;
    }
    return s;
}
