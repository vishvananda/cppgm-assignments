// Two values compared for equality are taken to differ more often than
// not. The scan below ends at the first code not below the bits read so
// far, and a symbol is complete only when that code equals them: the
// mismatch branches straight to the bit step at the top of the loop, and
// the rare match jumps back after its store, so the loop's exit test is
// not also copied to its entry. The function needs no preserved register,
// so no frame and no test ahead of one adds to the count.
extern "C" unsigned long decode(const unsigned char* bits, unsigned long count, const unsigned long* codes,
    unsigned char* out) {
    unsigned long code = 0, mask = 0x80;
    const unsigned long* first = codes;
    for (unsigned long n = 0; n < count;) {
        code = (code << 1) + ((*bits & mask) ? 2 : 1);
        while (*first < code)
            ++first;
        if (*first == code) {
            out[n++] = static_cast<unsigned char>('a' + (first - codes));
            code = 0;
            first = codes;
        }
        mask >>= 1;
        if (!mask) {
            mask = 0x80;
            ++bits;
        }
    }
    return count;
}
