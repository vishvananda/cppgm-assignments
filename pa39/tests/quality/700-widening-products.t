// 64-bit products of extended 32-bit values use the widening multiplies,
// SBFIZ or UBFIZ for a power of two, and ADD or SUB of an extended register
// when a shifted product is accumulated. The other functions check the
// extremes of each extension, literals at the limits of the 32-bit range,
// and mixed extensions, which keep the 64-bit multiply.
extern "C" long smul(int a, int b) { return (long)a * b; }
extern "C" unsigned long umul(unsigned a, unsigned b) { return (unsigned long)a * b; }
extern "C" long smadd(long c, int a, int b) { return c + (long)a * b; }
extern "C" long smsub(long c, int a, int b) { return c - (long)a * b; }
extern "C" unsigned long umadd(unsigned long c, unsigned a, unsigned b) { return (unsigned long)a * b + c; }
extern "C" unsigned long umsub(unsigned long c, unsigned a, unsigned b) { return c - (unsigned long)a * b; }
extern "C" long square(int a) { return (long)a * a; }
extern "C" long thousand(int a) { return (long)a * 1000; }
extern "C" long minus_seven(int a) { return (long)a * -7; }
extern "C" long eight(int a) { return (long)a * 8; }
extern "C" long add_eight(long c, int a) { return c + (long)a * 8; }
extern "C" long sub_four(long c, int a) { return c - (long)a * 4; }
extern "C" unsigned long add_two(unsigned long c, unsigned a) { return c + (unsigned long)a * 2; }
extern "C" long add_sixty_four(long c, int a) { return c + (long)a * 64; }
extern "C" unsigned long top_bit(unsigned a) { return (unsigned long)a * 0x80000000u; }
extern "C" long past_int(int a) { return (long)a * 0x80000000L; }
extern "C" long below_int(int a) { return (long)a * -0x80000001L; }
extern "C" long int_min(int a) { return (long)a * -0x80000000L; }
extern "C" long mixed(int a, unsigned b) { return (long)a * (long)b; }
