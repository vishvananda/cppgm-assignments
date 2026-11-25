#if !defined(__aarch64__) || !defined(__arm64__) || !defined(__APPLE__) || !defined(__MACH__) || defined(__ELF__) || defined(__linux__) || defined(__x86_64__)
#error Apple Silicon target macros required
#endif
static_assert(sizeof(long) == 8 && sizeof(int) == 4 && sizeof(void*) == 8, "LP64");
static_assert(sizeof(long double) == 8 && alignof(long double) == 8 && __LDBL_MANT_DIG__ == 53, "binary64 long double");
static_assert(sizeof(__builtin_va_list) == 8 && (char)-1 < 0 && (wchar_t)-1 < 0, "Darwin scalar ABI");
static_assert(1.00000000000000011102230246251565404236316680908203125L == 1.0L, "round binary64 literal to even");
constexpr long double operator""_binary64(long double value) { return value; }
static_assert(1.00000000000000011102230246251565404236316680908203125_binary64 == 1.0L,
              "round a cooked floating literal to its parameter type");
struct Empty {};
struct Floats { double x, y, z; };
struct SeparatedBits { unsigned char first : 3; unsigned : 0; unsigned char last : 5; };
static_assert(sizeof(SeparatedBits) == 5 && alignof(SeparatedBits) == 1, "Darwin bit-field alignment");
union FloatWithBits { float value; unsigned : 1; };
extern "C" FloatWithBits add_to_float_with_bits(FloatWithBits input) {
    input.value += 2.5f;
    return input;
}

extern "C" long fixed(int a, __int128 wide, Empty, int b, int c, int d, int e, int f,
                      signed char g, signed char h, short i, long double fp) {
    return a + long(wide >> 64) + long(wide) + b + c + d + e + f + g + h + i + long(fp);
}
extern "C" long varied(int bias, ...) {
    __builtin_va_list ap, copy;
    __builtin_va_start(ap, bias);
    __builtin_va_copy(copy, ap);
    int twice = __builtin_va_arg(copy, int);
    __builtin_va_end(copy);
    int once = __builtin_va_arg(ap, int);
    Floats fp = __builtin_va_arg(ap, Floats);
    __int128 wide = __builtin_va_arg(ap, __int128);
    int last = __builtin_va_arg(ap, int);
    __builtin_va_end(ap);
    return bias + twice + once + long(fp.x + fp.y + fp.z) + long(wide >> 64) + last;
}

struct Word { long value; };
struct SingleFloat { double value; };
extern "C" Word packed_word(long, long, long, long, long, long, long, long, char bias,
                            Word w, char tail, SingleFloat d) {
    return Word{w.value + bias + tail + long(d.value)};
}
