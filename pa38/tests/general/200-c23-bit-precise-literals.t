#if 255uwb + 1uwb != 256
#error preprocessing must use uintmax_t arithmetic
#endif
#if -1wb >= 0 || -1uwb <= 0
#error preserve signedness in preprocessing
#endif

#define TYPE_IS(x, t) _Generic((x), t: 1, default: 0)
_Static_assert(TYPE_IS(0wb, _BitInt(2)));
_Static_assert(TYPE_IS(0WB, signed _BitInt(2)));
_Static_assert(TYPE_IS(0uWB, unsigned _BitInt(1)));
_Static_assert(TYPE_IS(017wb, _BitInt(5)));
_Static_assert(TYPE_IS(0xffWBU, unsigned _BitInt(8)));
_Static_assert(TYPE_IS(0b1'101wb, _BitInt(5)));
_Static_assert(TYPE_IS(18446744073709551615wb, _BitInt(65)));
_Static_assert(TYPE_IS(0x10000000000000001uwb, unsigned _BitInt(65)));
_Static_assert(0x10000000000000001uwb == (((unsigned _BitInt(65))1 << 64) | 1));
_Static_assert(0xffffffffffffffffffffffffffffffffuwb == (unsigned _BitInt(128))-1);
_Static_assert(__BITINT_MAXWIDTH__ >= 128);
_Static_assert(sizeof(unsigned _BitInt(__BITINT_MAXWIDTH__)) * __CHAR_BIT__ >= __BITINT_MAXWIDTH__);

static unsigned _BitInt(65) high_bits = 18446744073709551619uwb;

int main(void)
{
    volatile unsigned _BitInt(65) input = 0x10000000000000003uWB;
    return input != high_bits;
}
