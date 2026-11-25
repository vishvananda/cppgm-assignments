#include <math.h>
#if !defined(__wasm__)
#include <fenv.h>
#endif

#pragma STDC FENV_ACCESS ON

static volatile double two = 2.0;
#if !defined(__wasm__)
static volatile double negative_zero = -0.0;
static volatile double infinity = INFINITY;
#endif

int main(void)
{
    if (sqrt(two) != 0x1.6a09e667f3bcdp0 || sqrtf(4.0f) != 2.0f || sqrtl(4.0L) != 2.0L)
        return 1;
#if defined(__wasm__)
    return pow(two, -1.0) != 0.5;
#else
    if (feclearexcept(FE_ALL_EXCEPT))
        return 2;
    (void)sqrt(two);
    if (!fetestexcept(FE_INEXACT))
        return 3;

    int entry = fegetround();
    if (fesetround(FE_DOWNWARD))
        return 4;
    double rounded = sqrt(two);
    if (fesetround(entry) || rounded != 0x1.6a09e667f3bccp0)
        return 5;

    if (feclearexcept(FE_ALL_EXCEPT))
        return 6;
    (void)pow(negative_zero, -1.0);
    if (!fetestexcept(FE_DIVBYZERO))
        return 7;

    double angle = infinity;
    if (feclearexcept(FE_ALL_EXCEPT))
        return 8;
    (void)sin(angle);
    if (!fetestexcept(FE_INVALID) || feclearexcept(FE_ALL_EXCEPT))
        return 9;
    (void)cos(angle);
    return !fetestexcept(FE_INVALID) ? 10 : 0;
#endif
}
