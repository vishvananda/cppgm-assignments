extern "C" __attribute__((noinline)) int copy_bits(
    const unsigned char* input, unsigned bytes, int first, int last, unsigned* output) {
    unsigned written = 0;
    for (unsigned b = 0; b < bytes && first < last; ++b) {
        unsigned value = input[b];
        for (int bit = 7; bit >= 0 && first < last; --bit) {
            output[written++] = (value >> bit) & 1;
            ++first;
        }
    }
    return first;
}
