// A bit writer stores a byte every eighth bit and grows its buffer on a
// rare call. The values that cross only that call stay in caller registers
// saved around it, so the common path through the function saves none.
extern "C" void* memmove(void* to, const void* from, unsigned long size);
extern "C" [[noreturn]] void too_long();

struct bit_writer {
    unsigned char* begin;
    unsigned char* end;
    unsigned char* limit;
    unsigned char buffer;
    int bits;
    int written;
    void write_bit(int bit);
};

static unsigned long check_length(const bit_writer& w) {
    const unsigned long most = 0x7fffffffffffffff;
    const unsigned long size = w.end - w.begin;
    if (most - size < 1)
        too_long();
    unsigned long length = size + (size > 1 ? size : 1);
    if (length < size || length > most / 2)
        length = most / 2;
    return length;
}

static void grow(bit_writer& w, unsigned char value) {
    const unsigned long capacity = check_length(w);
    const unsigned long size = w.end - w.begin;
    unsigned char* begin = capacity ? static_cast<unsigned char*>(::operator new(capacity)) : nullptr;
    begin[size] = value;
    if (size > 0)
        memmove(begin, w.begin, size);
    if (w.begin)
        ::operator delete(w.begin);
    w.begin = begin;
    w.end = begin + size + 1;
    w.limit = begin + capacity;
}

__attribute__((noinline)) void bit_writer::write_bit(int bit) {
    buffer = (buffer << 1) | (bit & 1);
    bits++;
    written++;
    if (bits == 8) {
        if (end != limit)
            *end++ = buffer;
        else
            grow(*this, buffer);
        buffer = 0;
        bits = 0;
    }
}
