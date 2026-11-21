// Loads and stores of globals at a literal offset address the symbol with
// ADRP and the access's :lo12: offset. The bounds allow no separate ADD and
// one ADRP per global. The other functions access a packed global whose
// fields are not aligned to their size, an untyped external array, a vector
// global, sign-extending loads and offsets past one 4 KiB page. A weak
// definition is replaced by the other unit's strong one, which a peer
// compiler may place at an odd address: its eight-byte read takes the
// address first.
struct Pair {
    int key;
    long value;
};

struct __attribute__((packed)) Packed {
    char tag;
    int word;
    long wide;
};

typedef int v4 __attribute__((vector_size(16)));

int counter;
short half = 7;
long table[1024];
Pair pairs[4] = {{1, 10}, {2, 20}, {3, 30}, {4, 40}};
Packed packed = {'p', 0x1234, 0x123456789};
double weights[3] = {0.5, 1.5, 2.5};
v4 lanes = {1, 2, 3, 4};
signed char bytes[8] = {-1, -2, -3, -4, 5, 6, 7, 8};
extern char shared_text[];
struct __attribute__((packed)) Loose {
    long wide;
    int word;
};
__attribute__((weak)) Loose replaced[3] = {{9, 9}, {9, 9}, {9, 9}};

extern "C" long pair_value() { return pairs[2].value; }

extern "C" void bump() {
    counter++;
    half++;
}

extern "C" long far_entry() { return table[1000]; }

extern "C" void set_far(long v) { table[1001] = v; }

extern "C" int packed_word() { return packed.word; }

extern "C" long packed_wide() { return packed.wide; }

extern "C" double weight() { return weights[1]; }

extern "C" int lane_sum() {
    v4 v = lanes;
    return v[0] + v[3];
}

extern "C" void set_lanes(int x) {
    v4 v = {x, x, x, x};
    lanes = v;
}

extern "C" int signed_byte() { return bytes[1]; }

extern "C" int text_word() { return *(int*)shared_text; }

extern "C" long replaced_wide() { return replaced[0].wide; }
