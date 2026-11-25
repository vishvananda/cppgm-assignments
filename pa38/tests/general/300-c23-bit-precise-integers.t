typedef unsigned _BitInt(1) U1;
typedef _BitInt(7) S7;
typedef _BitInt(9) unsigned U9;
typedef _BitInt(17) S17;
typedef _BitInt(65) S65;
typedef unsigned _BitInt(65) U65;

#define TYPE_IS(x, t) _Generic((x), t: 1, default: 0)
_Static_assert(TYPE_IS((U9)0 + (U9)1, U9));
_Static_assert(TYPE_IS((U9)0 + (S7)1, U9));
_Static_assert(TYPE_IS((U9)0 + 1, int));
_Static_assert(TYPE_IS((unsigned _BitInt(32))0 + 1, unsigned int));
_Static_assert(TYPE_IS(((U65)0 + 1ULL), U65));
_Static_assert(sizeof(S7) == 1 && sizeof(U9) == 2 && sizeof(S17) == 4);
_Static_assert(sizeof(S65) == 16 && sizeof(S65[3]) == 48);
#if defined(__aarch64__)
_Static_assert(_Alignof(S65) == 16);
#else
_Static_assert(_Alignof(S65) == 8);
#endif
_Static_assert((U1)2 == 0 && (U1)3 == 1);
_Static_assert((U9)511 + (U9)1 == 0);
_Static_assert(((S65)-37 >> 4) == -3);
_Static_assert((((U65)1 << 64) + ((U65)1 << 64)) == 0);

struct Bits {
    U9 x : 4;
    S17 y : 6;
};

_Static_assert(TYPE_IS(+((struct Bits){0}).x, U9));
_Static_assert(TYPE_IS(+((struct Bits){0}).y, S17));

static struct Bits fields = {7, -10};
static S65 negative = -34;

static S7 divide(S7 a, S7 b)
{
    return a / b;
}

int main(void)
{
    volatile int two = 2;
    volatile U1 bit = two;
    volatile U9 a = 511;
    volatile S7 b = -17;
    volatile S17 c = -130;
    volatile U65 top = 0x10000000000000000uwb;
    if (bit++ != 0 || bit != 1 || ++bit != 0)
        return 1;
    if ((a + (U9)1) != 0 || ~a++ != 0 || a != 0)
        return 2;
    if (divide(b, 3) != -5 || (c /= 7) != -18)
        return 3;
    if (top + top != 0 || negative != -34)
        return 4;
    if (fields.y != -10 || fields.x++ != 7 || fields.x != 8)
        return 5;
    return 0;
}
