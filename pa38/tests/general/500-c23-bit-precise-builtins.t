typedef unsigned _BitInt(7) U7;
typedef unsigned _BitInt(61) U61;
typedef unsigned _BitInt(65) U65;
typedef unsigned _BitInt(127) U127;

#if !__has_builtin(__builtin_stdc_bit_width)
#error C headers must be able to discover the type-generic bit builtins
#endif

static_assert(_Generic(__builtin_stdc_bit_floor((U65)1), U65: 1, default: 0));
static_assert(_Generic(__builtin_stdc_bit_ceil((unsigned char)1), unsigned char: 1, default: 0));
static_assert(_Generic(__builtin_stdc_has_single_bit(1u), bool: 1, default: 0));
static_assert(_Generic(__builtin_stdc_count_ones(1u), unsigned int: 1, default: 0));
static_assert(__builtin_clzg((U65)1 << 64) == 0);
static_assert(__builtin_ctzg((U127)1 << 115) == 115);
static_assert(__builtin_popcountg(((U127)1 << 115) | 1) == 2);
static_assert(__builtin_stdc_first_leading_zero((U7)127) == 0);
static_assert(__builtin_stdc_trailing_ones((U7)127) == 7);
static_assert(__builtin_stdc_bit_ceil(((U127)1 << 80) + 1) == (U127)1 << 81);
static_assert(__builtin_stdc_bit_floor(((U127)1 << 115) + 7) == (U127)1 << 115);

struct fields {
    unsigned int narrow : 7;
    U65 precise : 61;
};
static volatile struct fields fields = {65, 1};
static_assert(_Generic(__builtin_stdc_bit_floor(fields.precise), U61: 1, default: 0));

static volatile U7 small = 0x32;
static volatile U65 high = (U65)1 << 64;
static volatile U127 top = (U127)1 << 115;

int main(void)
{
    U7 x = small;
    if (__builtin_clzg(x) != 1 || __builtin_ctzg((U7)0, 13) != 13)
        return 1;
    if (__builtin_stdc_leading_zeros(x++) != 1 || x != 0x33)
        return 2;
    if (__builtin_stdc_trailing_ones(x) != 2 || __builtin_stdc_leading_ones(x) != 0)
        return 3;
    if (__builtin_stdc_first_leading_one(x) != 2 || __builtin_stdc_first_trailing_zero(x) != 3)
        return 4;
    if (__builtin_stdc_count_zeros(x) != 3 || __builtin_stdc_count_ones(x) != 4)
        return 5;

    U65 y = high;
    U127 z = top;
    if (__builtin_clzg(y) != 0 || __builtin_ctzg(y) != 64 || __builtin_popcountg(z) != 1)
        return 6;
    if (__builtin_stdc_bit_width(z) != 116 || __builtin_stdc_first_leading_zero(y) != 2)
        return 7;
    if (__builtin_stdc_first_trailing_one(z) != 116 || __builtin_stdc_trailing_zeros(z) != 115)
        return 8;
    if (__builtin_stdc_bit_floor(z + 7) != z || __builtin_stdc_bit_ceil(z + 1) != z << 1)
        return 9;
    if (!__builtin_stdc_has_single_bit(y) || __builtin_stdc_has_single_bit(y + 1))
        return 10;

    z ^= top;
    if (__builtin_stdc_leading_zeros(z) != 127 || __builtin_stdc_trailing_zeros(z) != 127)
        return 11;
    if (__builtin_stdc_bit_width(z) || __builtin_stdc_first_trailing_one(z) ||
        __builtin_stdc_bit_floor(z) || __builtin_stdc_bit_ceil(z) != 1)
        return 12;
    if (__builtin_stdc_leading_zeros(fields.narrow) != 0 || __builtin_stdc_bit_ceil(fields.narrow) != 0 ||
        __builtin_stdc_leading_zeros(fields.precise) != 60 || __builtin_stdc_bit_floor(fields.precise) != 1)
        return 13;
    return 0;
}
