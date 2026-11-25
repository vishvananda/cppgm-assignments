#include <cstdio>

extern "C" unsigned long named_registers(unsigned long, unsigned long);
extern "C" unsigned long tied_named_register(unsigned long);
extern "C" unsigned long named_register_alternatives(unsigned long);
extern "C" unsigned long repeated_named_register(unsigned long);

int main() {
    const unsigned long input = 0x1234567890abcdeful;
    if (named_registers(input, 23) != input + 57) return 1;
    if (tied_named_register(input) != input + 7) return 2;
    if (named_register_alternatives(input) != input + 3) return 3;
    if (repeated_named_register(input) != input + 5) return 4;
    std::puts("GNU local register variables select the declared assembly operands");
}
