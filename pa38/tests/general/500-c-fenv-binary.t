#ifndef __wasm__
#include <fenv.h>
#endif

#define FENV_ON _Pragma("STDC FENV_ACCESS ON")
#define HALFWAY 0x1p-53

#pragma STDC FENV_ACCESS ON
static double static_tie = 1.0 + HALFWAY;

double add_tie(void)
{
    return 1.0 + HALFWAY;
}

void raise_inexact(void)
{
    (void)(1.0 + HALFWAY);
}

#pragma STDC FENV_ACCESS OFF
double ordinary(double value)
{
    return value + 16.0;
}

double nested_scope(double value)
{
    {
        FENV_ON
        value += 1.0;
        {
#pragma STDC FENV_ACCESS DEFAULT
            value += 2.0;
        }
        value += 4.0;
    }
    return value + 8.0;
}

int main(void)
{
    FENV_ON
    if (static_tie != 1.0 || ordinary(0.0) != 16.0 || nested_scope(0.0) != 15.0)
        return 1;
#ifdef __wasm__
    return add_tie() != 1.0;
#else
    if (fesetround(FE_UPWARD) != 0)
        return 2;
    volatile double above = add_tie();
    if (fesetround(FE_DOWNWARD) != 0)
        return 3;
    volatile double below = add_tie();
    if (fesetround(FE_TONEAREST) != 0)
        return 4;
    if (above != 0x1.0000000000001p0 || below != 1.0)
        return 5;
    if (feclearexcept(FE_ALL_EXCEPT) != 0)
        return 6;
    raise_inexact();
    return (fetestexcept(FE_INEXACT) & FE_INEXACT) == 0;
#endif
}
