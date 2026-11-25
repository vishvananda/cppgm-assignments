static volatile double large = 0x1p600;
static volatile long double two = 2.0L;
static volatile long double three = 3.0L;

extern "C" int observe()
{
    double _Complex wide = large;
    __imag__ wide = large;
    double _Complex ratio = wide / wide;
    if (__real__ ratio != 1.0 || __imag__ ratio != 0.0)
        return 1;

    long double _Complex first = two;
    __imag__ first = three;
    long double _Complex second = first;
    __imag__ second = -three;
    long double _Complex product = first * second;
    if (__real__ product != 13.0L || __imag__ product != 0.0L)
        return 2;
    long double _Complex quotient = product / second;
    return __real__ quotient != 2.0L || __imag__ quotient != 3.0L ? 3 : 0;
}
