// Multiply-adds with a literal factor of 2^k or 1 + 2^k use shifted adds
// and build no literal. The other functions use the largest shifts of each
// width, a negative factor and a literal accumulator.
extern "C" long times3_plus1(long x) { return x * 3 + 1; }
extern "C" long add_times8(long x, long c) { return c + x * 8; }
extern "C" long sub_times8(long x, long c) { return c - x * 8; }
extern "C" long add_times3(long x, long c) { return c + x * 3; }
extern "C" long settle(long x, long y, long z) { return x + y * 3 + z * 5; }
extern "C" unsigned add_times5(unsigned x, unsigned c) { return c + x * 5; }
extern "C" unsigned sub_times4(unsigned x, unsigned c) { return c - x * 4; }
extern "C" unsigned top_word(unsigned x, unsigned c) { return c + x * 0x80000000u; }
extern "C" unsigned long top_double(unsigned long x, unsigned long c) { return c - x * 0x8000000000000000ul; }
extern "C" long minus_eight(long x, long c) { return c + x * -8; }
extern "C" long eight_plus(long x) { return x * 8 + 4095; }
extern "C" long nine_minus(long x) { return x * 9 - 4096; }
extern "C" long sub_minus_two(long x, long c) { return c - x * -2; }
extern "C" unsigned long top_negated(unsigned long x, unsigned long c) { return c + x * (0ul - 0x8000000000000000ul); }
