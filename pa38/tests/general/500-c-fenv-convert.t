#ifndef __wasm__
#include <fenv.h>
#endif

#pragma STDC FENV_ACCESS ON
static float static_halfway = 0x1.000001p0;

float round_integer(void)
{
    return 16777217;
}

float narrow_double(void)
{
    return (float)0x1.000001p0;
}

#ifndef __wasm__
void discard_invalid_conversion(void)
{
    volatile double infinite = __builtin_inf();
    (void)(int)infinite;
}
#endif

int main(void)
{
    if (static_halfway != 1.0f)
        return 1;
#ifdef __wasm__
    return round_integer() != 16777216.0f || narrow_double() != 1.0f;
#else
    if (fesetround(FE_UPWARD) != 0)
        return 2;
    volatile float up_integer = round_integer();
    volatile float up_narrow = narrow_double();
    if (fesetround(FE_DOWNWARD) != 0)
        return 3;
    volatile float down_integer = round_integer();
    volatile float down_narrow = narrow_double();
    if (fesetround(FE_TONEAREST) != 0)
        return 4;
    if (up_integer != 16777218.0f || up_narrow != 0x1.000002p0f ||
        down_integer != 16777216.0f || down_narrow != 1.0f)
        return 5;
    if (feclearexcept(FE_ALL_EXCEPT) != 0)
        return 6;
    discard_invalid_conversion();
    return (fetestexcept(FE_INVALID) & FE_INVALID) == 0;
#endif
}
