// Loops tested at their top run bottom-tested: the block entering a loop
// takes a copy of a short test, and each loop's run starts where its
// iterations take the fewest branches.
struct Slot {
    unsigned long key;
    unsigned value;
};

extern "C" __attribute__((noinline)) unsigned scan_table(const unsigned long* heap, unsigned long key, unsigned i) {
    while (heap[i] < key)
        ++i;
    return i;
}

extern "C" __attribute__((noinline)) int scan_found(
    const unsigned long* heap, unsigned long key, unsigned i, unsigned* where) {
    unsigned long value;
    while ((value = heap[i]) < key)
        ++i;
    *where = i;
    return value == key;
}

extern "C" __attribute__((noinline)) unsigned probe_sum(
    const Slot* slots, unsigned mask, const unsigned long* keys, unsigned count) {
    unsigned sum = 0;
    for (unsigned n = 0; n != count; ++n) {
        unsigned long key = keys[n];
        unsigned i = static_cast<unsigned>(key * 0x9e3779b97f4a7c15ull >> 40) & mask;
        while (slots[i].value != 0 && slots[i].key != key)
            i = (i + 1) & mask;
        sum += slots[i].value;
    }
    return sum;
}

extern "C" __attribute__((noinline)) void bubble_sort(int* a, int n) {
    for (int top = n - 1; top > 0; --top)
        for (int j = 0; j < top; ++j)
            if (a[j] > a[j + 1]) {
                int t = a[j];
                a[j] = a[j + 1];
                a[j + 1] = t;
            }
}

extern "C" __attribute__((noinline)) void sift_down(double* ra, unsigned l, unsigned ir) {
    double rra = ra[l];
    unsigned i = l, j = l * 2;
    while (j <= ir) {
        if (j < ir && ra[j] < ra[j + 1])
            ++j;
        if (rra < ra[j]) {
            ra[i] = ra[j];
            j += (i = j);
        } else
            j = ir + 1;
    }
    ra[i] = rra;
}

extern "C" __attribute__((noinline)) unsigned decode(const unsigned long* heap, const unsigned char* symbols,
    const unsigned char* bits, unsigned long count, unsigned first, unsigned char* out) {
    unsigned long code = 0, mask = 0x80, written = 0;
    unsigned i = first;
    while (written < count) {
        code = code * 2 + 1;
        if (*bits & mask)
            ++code;
        while (heap[i] < code)
            ++i;
        if (code == heap[i]) {
            out[written++] = symbols[i];
            code = 0;
            i = first;
        }
        if (mask > 1)
            mask >>= 1;
        else {
            mask = 0x80;
            ++bits;
        }
    }
    return i;
}
