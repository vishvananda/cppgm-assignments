static volatile double large = 0x1p600;
static volatile double small = 0x1p-600;
static volatile float two = 2.0f;
static volatile float three = 3.0f;

static int full_range(double _Complex numerator, double _Complex denominator)
{
    double _Complex quotient = numerator / denominator;
    return __real__ quotient == 1.0 && __imag__ quotient == 0.0;
}

#pragma STDC CX_LIMITED_RANGE ON
static int file_scope(float a, float b)
{
    float _Complex left = __builtin_complex(a, b);
    float _Complex right = __builtin_complex(a, -b);
    left *= right;
    return __real__ left == 13.0f && __imag__ left == 0.0f;
}

#pragma STDC CX_LIMITED_RANGE DEFAULT
int main(void)
{
    double high = large, low = small;
    double _Complex big = __builtin_complex(high, high);
    double _Complex tiny = __builtin_complex(low, low);
    double _Complex infinite = __builtin_complex(__builtin_inf(), __builtin_nan(""));
    if (!full_range(big, big) || !full_range(tiny, tiny))
        return 1;
    if (!file_scope(two, three))
        return 2;
    {
        _Pragma("STDC CX_LIMITED_RANGE ON")
        #pragma STDC FP_CONTRACT OFF
        double _Complex value = __builtin_complex(2.0, 3.0);
        double _Complex quotient = __builtin_complex(8.0, -1.0);
        quotient /= value;
        if (__real__ quotient != 1.0 || __imag__ quotient != -2.0)
            return 3;
        {
            #pragma STDC CX_LIMITED_RANGE OFF
            double _Complex recovered = infinite * __builtin_complex(0.0, 1.0);
            if (!__builtin_isinf(__imag__ recovered))
                return 4;
        }
        quotient = value / value;
        if (__real__ quotient != 1.0 || __imag__ quotient != 0.0)
            return 5;
    }
    double _Complex again = big / big;
    return __real__ again != 1.0 || __imag__ again != 0.0 ? 6 : 0;
}
