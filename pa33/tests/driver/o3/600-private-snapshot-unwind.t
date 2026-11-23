// Avoid a redundant copy while preserving saved fields and exception cleanup.
struct Input {
    long key;
    long unused;
    const long* delta;
};

static int cleanups;

struct Cleanup {
    ~Cleanup() { ++cleanups; }
};

__attribute__((noinline)) static long inspect(Input input, Input* original, bool throws) {
    Cleanup cleanup;
    original->key = 31;
    if (throws) throw input.key;
    return input.key + *input.delta;
}

int main() {
    const long delta = 5;
    Input original{7, 19, &delta};
    if (inspect(original, &original, false) != 12 || original.key != 31 || cleanups != 1)
        return 1;
    try {
        inspect(original, &original, true);
        return 2;
    } catch (long old_key) {
        return old_key != 31 || cleanups != 2;
    }
}
