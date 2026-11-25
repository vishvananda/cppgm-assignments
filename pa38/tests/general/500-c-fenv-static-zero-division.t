#ifndef __wasm__
#include <fenv.h>
#endif

#pragma STDC FENV_ACCESS ON

static volatile const float nan_value = 0.0f / 0.0f;
static volatile const double positive_inf = -1.0 / -0.0;
static volatile const double negative_inf = 1.0 / -0.0;
static volatile const long double wide_nan = 0.0L / 0.0L;
static volatile const long double wide_inf = -1.0L / 0.0L;

int main(void)
{
    if (!__builtin_isnan(nan_value) || !__builtin_isnan(wide_nan))
        return 1;
    if (__builtin_isinf_sign(positive_inf) != 1 ||
        __builtin_isinf_sign(negative_inf) != -1 ||
        __builtin_isinf_sign(wide_inf) != -1)
        return 2;
#ifndef __wasm__
    if (fetestexcept(FE_INVALID | FE_DIVBYZERO))
        return 3;
    volatile float zero = 0.0f;
    if (!__builtin_isnan(zero / zero) || !(fetestexcept(FE_INVALID) & FE_INVALID))
        return 4;
#endif
    return 0;
}
