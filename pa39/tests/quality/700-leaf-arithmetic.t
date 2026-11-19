extern "C" long kernel(long a, long b) {
    return ((a + b) * 3 - b) ^ 53;
}

extern "C" int store_if_less(const int* a, int* b) {
    int n = *a;
    if (n < *b) *b = n;
    return n;
}
extern "C" bool unsigned_limit(unsigned x) { return x < 0xffffffffu; }

extern "C" unsigned indexed(const unsigned* data, int left, unsigned right) {
    return data[left] + data[right];
}
extern "C" void replace_half(unsigned short* data, long i, unsigned short v) { data[i] = v; }

extern "C" unsigned long mix_bits(unsigned long x, unsigned shift, unsigned long divisor) {
    unsigned long v = (x << 17) ^ (x >> 13) ^ (x >> shift);
    return ((v & 0xff00ff00ff00ff00UL) | 0x000f000f000f000fUL) % divisor;
}
extern "C" int signed_remainder(int x, int divisor) { return x % divisor; }
extern "C" int fixed_signed_remainder(int x) { return x % 139968; }
extern "C" unsigned fixed_unsigned_quotient(unsigned x) { return x / 255u; }
extern "C" double narrow_lane_counter(const double* data, long count, long start) {
    double sum = 0;
    for (long j = 0, i = start; j < count; ++j, ++i)
        sum += data[j] * static_cast<double>(static_cast<int>(i));
    return sum;
}
extern "C" unsigned long step_bit_cursor(const unsigned char* data, long count, unsigned long mask) {
    const unsigned char* cursor = data;
    unsigned long sum = 0;
    for (long i = 0; i < count; ++i) {
        sum += *cursor & mask;
        if (mask > 1) {
            mask >>= 1;
        } else {
            mask = 128;
            ++cursor;
        }
    }
    return (sum << 12) | (static_cast<unsigned long>(cursor - data) << 8) | mask;
}
extern "C" unsigned long widen_choice(bool a, unsigned x) { return a ? x : 0xffffffffu; }

extern "C" unsigned byte_offset(const unsigned* data, signed char i, unsigned char j) {
    return i < -4 && j >= 250 ? data[i] + data[j] : 0;
}
extern "C" bool signed_order(short left, short right) { return left < right; }
extern "C" int signed_entries(const signed char* bytes, const short* words, long i) {
    return bytes[i] + words[i];
}
extern "C" int signed_lookup(const signed char* bytes, long i, const int* negative, const int* other) {
    if (bytes[i] < 0) return *negative;
    return *other;
}

extern "C" unsigned adjacent(const unsigned* a, long i) {
    const unsigned* p = a + i;
    return p[0] - p[1];
}
extern "C" unsigned observed(const volatile unsigned* p, unsigned* target) {
    unsigned first = p[0];
    *target = first + 5;
    return first ^ p[1];
}

extern "C" unsigned long inspect_widened(unsigned long, unsigned long, unsigned, unsigned long);
extern "C" unsigned long widen_across_call(const unsigned* in, unsigned char byte, bool take_word) {
    unsigned word = *in;
    unsigned long wide = word;
    unsigned long choice = take_word ? wide : (unsigned long)byte;
    unsigned long check = inspect_widened(choice, byte, word, wide);
    return check + choice + wide;
}

struct Arms { unsigned pad, left, right, tail; };
extern "C" unsigned replace_fields(Arms* p, unsigned left, unsigned right) {
    unsigned old_right = p->right;
    unsigned old_left = p->left;
    p->left = left;
    p->right = right;
    return old_right - old_left;
}
extern "C" unsigned narrow_ops(unsigned char a, unsigned char b, unsigned short c) {
    unsigned char sum = a + b;
    unsigned short diff = c - (a | b);
    return (unsigned(sum) << 16) | diff;
}

extern "C" unsigned narrow_window(unsigned char c) {
    unsigned char delta = c - 8;
    if (delta < 2) return 1;
    unsigned char wrap = c - 250;
    return wrap < 9 ? 2 : 3;
}

extern "C" int bit_call(unsigned long x, int (*callback)(int)) {
    if (x & (1UL << 63)) return callback(9);
    if (x & (1UL << 31)) return callback(7);
    if (x & 2) return callback(3);
    return callback(1);
}

extern "C" void update_at(float*, float);
extern "C" float before_cursor(float* end, bool update) {
    float* previous = end - 1;
    float old = *previous;
    if (update) update_at(previous, old + 4.0f);
    return *previous + old;
}
extern "C" unsigned field_across_branch(Arms* a, unsigned i, bool write) {
    unsigned old = a[i].right;
    if (write) a[i].right = old + 3;
    return a[i].right + old;
}

extern "C" unsigned rotate_word(unsigned value) {
    return (value >> 19) + (value << 13);
}
extern "C" unsigned long rotate_mix(unsigned long value, unsigned long key) {
    return key ^ ((value << 63) | (value >> 1));
}
extern "C" unsigned different_shifts(unsigned value) {
    return (value << 13) ^ (value >> 18);
}

extern "C" unsigned projected_bytes(unsigned long* word, unsigned char v, unsigned char* write, signed char s) {
    unsigned char* b = reinterpret_cast<unsigned char*>(word);
    *word = v;
    unsigned before = b[0] + 257u * b[6];
    *write = 91;
    unsigned after = b[0] + 257u * b[6];
    *word = static_cast<unsigned long>(s);
    return before + 3 * after + 65536u * b[1];
}

extern "C" unsigned shift_fields(unsigned long v, int s) {
    return static_cast<unsigned char>(v >> 41) + 257u * static_cast<unsigned char>(s >> 28);
}
extern "C" unsigned mask_shift_word(unsigned value) { return (value >> 10) & 63u; }
extern "C" unsigned long mask_shift_long(long value) { return (value >> 41) & 511UL; }
extern "C" int shift_cmp(long limit, long value) {
    return limit < (value >> 5) ? 7 : -3;
}
extern "C" bool shift_eq(unsigned a, unsigned b) { return a == (b << 29); }

extern "C" bool conditions_and(long a, long b, unsigned k) { return (a < b) & (k >= 19); }
extern "C" bool conditions_or(unsigned c, unsigned d, long x) { return (x != -37) | (c <= d); }

extern "C" unsigned short place_nibbles(unsigned long a, unsigned long b) {
    return static_cast<unsigned short>(a << 12) | static_cast<unsigned char>(b << 4);
}
extern "C" unsigned clear_low_word(unsigned long x) { return static_cast<unsigned>(x << 39); }

extern "C" unsigned narrow_join(bool select, unsigned long a, unsigned long b) {
    unsigned long both = select ? (a >> 56) : (b & 255);
    return static_cast<unsigned char>(both) * 257u;
}
extern "C" unsigned narrow_join_full(bool select, unsigned long a, unsigned long b) {
    unsigned long either = select ? (a >> 55) : b;
    return static_cast<unsigned char>(either) * 257u;
}

extern "C" unsigned long selected_field(const unsigned long* fields, unsigned selector) {
    return (selector & 64) ? fields[3] : fields[1];
}

extern "C" unsigned scaled_with_bias(unsigned value) {
    return (value + 0xffff0007u) * 19u + 2027u;
}

extern "C" unsigned triangle_slots(const unsigned* values) {
    unsigned pairs[5][5];
    for (int i = 0; i < 5; ++i)
        for (int j = i + 1; j < 5; ++j) pairs[i][j] = values[i] + values[j];
    unsigned result = 0;
    for (int i = 0; i < 5; ++i)
        for (int j = i + 1; j < 5; ++j) result += pairs[i][j];
    return result;
}
