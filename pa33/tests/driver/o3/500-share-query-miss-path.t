// Check the shared key before calls and preserve callbacks and unwinding.
static unsigned visits;
static unsigned long long last;

__attribute__((noinline)) void report(unsigned long long key) {
    ++visits;
    last = key;
    if (key == 0x400000024ull)
        throw visits;
}

static __attribute__((noinline)) bool matches(const unsigned long long* stored, unsigned long long key) {
    if (*stored == key) {
        report(key);
        return true;
    }
    return false;
}

extern "C" __attribute__((noinline)) int find_key(const unsigned long long* stored) {
    if (matches(stored, 0x100000021ull)) return 1;
    if (matches(stored, 0x200000022ull)) return 2;
    if (matches(stored, 0x400000024ull)) return 3;
    if (matches(stored, 0x800000028ull)) return 4;
    return 0;
}

int main() {
    unsigned long long stored = 0x200000021ull;
    if (find_key(&stored) || visits)
        return 1;
    stored = 0x800000028ull;
    if (find_key(&stored) != 4 || visits != 1 || last != stored)
        return 2;
    stored = 0x400000024ull;
    try {
        find_key(&stored);
        return 3;
    } catch (unsigned visits_at_throw) {
        if (visits_at_throw != 2 || visits != 2 || last != stored)
            return 4;
    }
    stored = 0x100000021ull;
    return find_key(&stored) != 1 || visits != 3 || last != stored;
}
