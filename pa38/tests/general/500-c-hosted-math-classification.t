#include <float.h>
#include <math.h>
#ifndef __wasm__
#include <fenv.h>
#endif

#pragma STDC FENV_ACCESS ON

static const int classes[] = {
    FP_INFINITE, FP_NORMAL, FP_SUBNORMAL, FP_ZERO, FP_ZERO,
    FP_SUBNORMAL, FP_NORMAL, FP_INFINITE, FP_NAN
};

#define CHECK_REAL(name, type, minimum, epsilon)                                  \
static int name(void)                                                            \
{                                                                                \
    static volatile const type values[] = {                                      \
        -INFINITY, -(minimum), -(minimum) * (epsilon), -0.0, 0.0,                 \
        (minimum) * (epsilon), (minimum), INFINITY, NAN                           \
    };                                                                           \
    const int count = sizeof(values) / sizeof(values[0]);                         \
    for (int i = 0; i < count; ++i) {                                              \
        const type x = values[i];                                                 \
        const int category = classes[i];                                         \
        if (fpclassify(x) != category || !!isnan(x) != (category == FP_NAN)         \
            || !!isinf(x) != (category == FP_INFINITE)                            \
            || !!isfinite(x) != (category != FP_NAN && category != FP_INFINITE)    \
            || !!isnormal(x) != (category == FP_NORMAL)                           \
            || (category != FP_NAN && !!signbit(x) != (i < 4)))                    \
            return 0;                                                           \
        for (int j = 0; j < count; ++j) {                                         \
            const type y = values[j];                                             \
            const int ordered = category != FP_NAN && classes[j] != FP_NAN;        \
            const int equal = i == j || (category == FP_ZERO && classes[j] == FP_ZERO); \
            const int less = i < j && !equal;                                     \
            const int greater = i > j && !equal;                                  \
            if (!!isunordered(x, y) != !ordered                                   \
                || !!islessgreater(x, y) != (ordered && !equal)                     \
                || !!isless(x, y) != (ordered && less)                             \
                || !!islessequal(x, y) != (ordered && (less || equal))              \
                || !!isgreater(x, y) != (ordered && greater)                       \
                || !!isgreaterequal(x, y) != (ordered && (greater || equal)))       \
                return 0;                                                       \
        }                                                                        \
    }                                                                            \
    int a = 3, b = 6;                                                             \
    if (!signbit(values[a++]) || a != 4)                                          \
        return 0;                                                               \
    return isless(values[a++], values[b++]) && a == 5 && b == 7;                  \
}

CHECK_REAL(check_float, float, FLT_MIN, FLT_EPSILON)
CHECK_REAL(check_double, double, DBL_MIN, DBL_EPSILON)
CHECK_REAL(check_long_double, long double, LDBL_MIN, LDBL_EPSILON)

int main(void)
{
#ifndef __wasm__
    if (feclearexcept(FE_ALL_EXCEPT))
        return 1;
#endif
    if (!check_float())
        return 2;
    if (!check_double())
        return 3;
    if (!check_long_double())
        return 4;
    volatile float one = 1.0f;
    volatile double two = 2.0;
    volatile long double nan = NAN;
    if (!isless(one, two) || !isgreater(two, one) ||
        !isunordered(nan, two) || islessgreater(one, nan))
        return 5;
#ifndef __wasm__
    if (fetestexcept(FE_INVALID) & FE_INVALID)
        return 6;
#endif
    return 0;
}
