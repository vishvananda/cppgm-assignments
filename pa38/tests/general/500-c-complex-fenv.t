#if !defined(__wasm__)
#include <fenv.h>
#endif

#pragma STDC FENV_ACCESS ON
#if !defined(__wasm__)
static volatile double _Complex zero;
#endif
static volatile double one = 1.0;
static volatile double three = 3.0;

int main(void)
{
#if !defined(__wasm__)
    double _Complex left = zero, right = zero;
    if (feclearexcept(FE_ALL_EXCEPT))
        return 1;
    (void)(left / right);
    if (!fetestexcept(FE_INVALID))
        return 2;
    if (feclearexcept(FE_ALL_EXCEPT))
        return 3;
#endif
    {
        #pragma STDC CX_LIMITED_RANGE ON
#if defined(__wasm__)
        double _Complex quotient = __builtin_complex(one, 0.0) / __builtin_complex(three, 0.0);
        return __real__ quotient != 0x1.5555555555555p-2 || __imag__ quotient != 0.0;
#else
        (void)(__builtin_complex(one, 0.0) / __builtin_complex(three, 0.0));
#endif
    }
#if !defined(__wasm__)
    return !fetestexcept(FE_INEXACT) ? 4 : 0;
#endif
}
