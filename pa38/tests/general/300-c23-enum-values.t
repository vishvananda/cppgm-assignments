enum Wide {
    signed_max = 2147483647,
    signed_next,
    stayed_signed = (signed_next > -1),
    unsigned_max = 4294967295U,
    unsigned_next,
    stayed_unsigned = (unsigned_next > -1) == 0,
    bit_precise = 4294967295uwb,
    held_bit_precise = _Generic(bit_precise, unsigned _BitInt(32): 1, default: 0)
};
enum Other { other = 4294967296ULL };
enum Small { small = 4ULL, small_is_int = _Generic(small, int: 1, default: 0) };
enum Mixed { negative = -1, large = 1ULL << 42 };

static_assert(stayed_signed == 1 && stayed_unsigned == 1 && held_bit_precise == 1);
static_assert(signed_next == 2147483648LL && unsigned_next == 4294967296ULL);
static_assert(sizeof(signed_max) == sizeof(enum Wide));
static_assert(_Generic(signed_next, enum Wide: 1, default: 0));
static_assert(!_Generic(signed_next, enum Other: 1, default: 0));
static_assert(small_is_int == 1 && _Generic(small, int: 1, default: 0));
static_assert(negative < 0 && large == 1ULL << 42);

static volatile enum Mixed stored = large;
enum Mixed read_value(void) { return stored; }

int main(void)
{
    return read_value() != 1ULL << 42 || unsigned_next <= signed_next;
}
