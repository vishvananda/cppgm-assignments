constexpr float f = __builtin_fmaf(1.0f + 0x1p-23f, 1.0f - 0x1p-23f, -1.0f);
static_assert(f == -0x1p-46f, "round a float result once");

constexpr double d = __builtin_fma(1.0 + 0x1p-52, 1.0 - 0x1p-52, -1.0);
static_assert(d == -0x1p-104, "round a double result once");

#if __LDBL_MANT_DIG__ == 113
constexpr long double step = 0x1p-112L, residue = -0x1p-224L;
#elif __LDBL_MANT_DIG__ == 64
constexpr long double step = 0x1p-63L, residue = -0x1p-126L;
#else
constexpr long double step = 0x1p-52L, residue = -0x1p-104L;
#endif
static_assert(__builtin_fmal(1.0L + step, 1.0L - step, -1.0L) == residue,
              "round at the target's long double precision");

constexpr double max_double = 0x1.fffffffffffffp1023;
static_assert(__builtin_fma(max_double, 2.0, -max_double) == max_double,
              "the intermediate product may exceed the result type's range");
static_assert(__builtin_fma(0x1p-1022, 0.5, 0.0) == 0x1p-1023,
              "an exact subnormal can be constant");
