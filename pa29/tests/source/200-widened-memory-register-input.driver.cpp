#include <cstdio>

extern "C" unsigned long add_widened(volatile unsigned*, unsigned long, unsigned long*);

__attribute__((noinline)) static unsigned long fill_stack() {
    volatile unsigned long buffer[120];
    for (unsigned i = 0; i < 120; ++i)
        buffer[i] = 0xffeeddcc00112233ul + i;
    return buffer[119];
}

int main() {
    volatile unsigned input[] = {0x81234567u, 0xc0ffee42u};
    const unsigned long canary = 0x5566778899aabbccul;
    unsigned long observed = 0;
    if (fill_stack() != 0xffeeddcc001122aaul)
        return 1;
    unsigned long result = add_widened(input, canary, &observed);
    if (result != static_cast<unsigned long>(input[0]) + input[1] || observed != canary)
        return 2;
    std::puts("widened assembly inputs preserve their values across register clobbers");
}
