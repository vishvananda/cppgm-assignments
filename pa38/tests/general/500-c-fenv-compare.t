#include <float.h>
#ifndef __wasm__
#include <fenv.h>
#endif

#pragma STDC FENV_ACCESS ON
int ordered_less(double value)
{
    return value < 0.0;
}

void discard_ordered(double value, double bound)
{
    (void)(value >= bound);
}

int quiet_equal(double value)
{
    return value == value;
}

int quiet_less(double value)
{
    return __builtin_isless(value, 0.0);
}

#if !defined(__wasm__) && LDBL_MANT_DIG == 64
int ordered_long_double(long double value)
{
    return value > 0.0L;
}
#endif

int main(void)
{
    volatile double qnan = __builtin_nan("");
    if (!ordered_less(-1.0) || !quiet_equal(0.0) || !quiet_less(-1.0))
        return 1;
#ifdef __wasm__
    discard_ordered(qnan, 1.0);
    return ordered_less(qnan) || quiet_equal(qnan) || quiet_less(qnan);
#else
    if (feclearexcept(FE_ALL_EXCEPT) != 0)
        return 2;
    if (quiet_equal(qnan) || quiet_less(qnan) || (fetestexcept(FE_INVALID) & FE_INVALID))
        return 3;
    if (ordered_less(qnan) || !(fetestexcept(FE_INVALID) & FE_INVALID))
        return 4;
    if (feclearexcept(FE_ALL_EXCEPT) != 0)
        return 5;
    discard_ordered(qnan, 1.0);
    if (!(fetestexcept(FE_INVALID) & FE_INVALID))
        return 6;
#if LDBL_MANT_DIG == 64
    volatile long double wide_nan = __builtin_nanl("");
    if (feclearexcept(FE_ALL_EXCEPT) != 0)
        return 7;
    if (ordered_long_double(wide_nan) || !(fetestexcept(FE_INVALID) & FE_INVALID))
        return 8;
#endif
    return 0;
#endif
}
