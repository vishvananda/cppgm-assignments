#include <float.h>
#ifndef __wasm__
#include <fenv.h>
#endif

#pragma STDC FENV_ACCESS ON

enum { Zero, Subnormal, Normal, Infinite, Nan };

static volatile const long double values[] = {
    -__builtin_infl(), -LDBL_MAX, -1.0L, -LDBL_MIN, -__LDBL_DENORM_MIN__,
    -0.0L, 0.0L, __LDBL_DENORM_MIN__, LDBL_MIN, 1.0L, LDBL_MAX,
    __builtin_infl(), __builtin_nanl(""), -__builtin_nanl("")
};

static const int classes[] = {
    Infinite, Normal, Normal, Normal, Subnormal, Zero, Zero,
    Subnormal, Normal, Normal, Normal, Infinite, Nan, Nan
};

static int classification_matches(long double value, int kind, int negative)
{
    return __builtin_fpclassify(Nan, Infinite, Normal, Subnormal, Zero, value) == kind
        && !!__builtin_isnan(value) == (kind == Nan)
        && !!__builtin_isfinite(value) == (kind < Infinite)
        && !!__builtin_isnormal(value) == (kind == Normal)
        && !!__builtin_isinf(value) == (kind == Infinite)
        && !!__builtin_signbit(value) == negative
        && __builtin_isinf_sign(value) == (kind != Infinite ? 0 : negative ? -1 : 1);
}

static int quiet_order_matches(long double x, long double y, int a, int b)
{
    const int ordered = classes[a] != Nan && classes[b] != Nan;
    const int equal = a == b || (classes[a] == Zero && classes[b] == Zero);
    const int less = a < b && !equal;
    const int greater = a > b && !equal;
    return !!__builtin_isunordered(x, y) == !ordered
        && !!__builtin_islessgreater(x, y) == (ordered && !equal)
        && !!__builtin_isless(x, y) == (ordered && less)
        && !!__builtin_islessequal(x, y) == (ordered && (less || equal))
        && !!__builtin_isgreater(x, y) == (ordered && greater)
        && !!__builtin_isgreaterequal(x, y) == (ordered && (greater || equal));
}

static int ordered_less(long double x, long double y)
{
    return x < y;
}

static void discard_ordered(long double x, long double y)
{
    (void)(x >= y);
}

int main(void)
{
    const int count = sizeof(values) / sizeof(values[0]);
#ifndef __wasm__
    if (feclearexcept(FE_ALL_EXCEPT) != 0)
        return 1;
#endif
    for (int i = 0; i < count; ++i) {
        const long double x = values[i];
        if (!classification_matches(x, classes[i], i <= 5 || i == count - 1))
            return 2;
        for (int j = 0; j < count; ++j) {
            const long double y = values[j];
            if (!quiet_order_matches(x, y, i, j))
                return 3;
        }
    }
    if (!ordered_less(values[4], values[5]) || ordered_less(values[5], values[6]))
        return 4;
#ifndef __wasm__
    if (fetestexcept(FE_INVALID) & FE_INVALID)
        return 5;
    if (ordered_less(values[count - 2], values[6]) || !(fetestexcept(FE_INVALID) & FE_INVALID))
        return 6;
    if (feclearexcept(FE_ALL_EXCEPT) != 0)
        return 7;
    discard_ordered(values[6], values[count - 1]);
    if (!(fetestexcept(FE_INVALID) & FE_INVALID))
        return 8;
#else
    discard_ordered(values[6], values[count - 1]);
    if (ordered_less(values[count - 2], values[6]))
        return 6;
#endif
    return 0;
}
