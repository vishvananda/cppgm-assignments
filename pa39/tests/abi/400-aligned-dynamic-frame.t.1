struct alignas(64) Block { long words[8]; };
extern "C" long exercise(unsigned, long);
extern "C" long inspect(Block copy, const Block* original, const unsigned char* bytes,
                        int a, int b, int c, int d, int e, int f, int g, int h) {
    if ((reinterpret_cast<unsigned long>(original) & 63) ||
        (reinterpret_cast<unsigned long>(bytes) & 15)) return -100;
    copy.words[0] += h;
    return copy.words[0] + original->words[7] + bytes[0] + a+b+c+d+e+f+g;
}
int main() {
    return exercise(37, 11) == 88 && exercise(82, 23) == 112 ? 39 : 3;
}

// A freestanding Clang caller may copy its over-aligned argument out of line.
extern "C" void* memcpy(void* to, const void* from, unsigned long count) {
    auto dst = static_cast<volatile unsigned char*>(to);
    auto src = static_cast<const unsigned char*>(from);
    for (unsigned long i = 0; i < count; ++i) dst[i] = src[i];
    return to;
}
