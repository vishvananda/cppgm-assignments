struct Cursor { int value, limit; };
extern "C" int refill(Cursor*);

// The prefix may mutate the cursor before the call. Re-entering the prefix
// on the slow path would advance it a second time.
static inline int take(Cursor* c) {
    if (!c) return -1;
    if (++c->value <= c->limit) return c->value;
    return refill(c);
}

extern "C" int read_three(Cursor* c) {
    int a = take(c);
    int b = take(c);
    int d = take(c);
    return a + 2 * b + 4 * d;
}
