static _Complex float stored = 1.25iF;
static _Complex long double extended = 2.5Lj;
static __complex__ unsigned long count = 7uIl;
static __complex__ unsigned long long wide = 0x100000003ULLi;

static _Complex double make_value(double real)
{
    return real + 0x1.8p+2J;
}

int main(void)
{
    _Complex double value = make_value(3.0);
    _Complex float local = 2.0fi;
    return !__builtin_types_compatible_p(__typeof__(1.0iF), _Complex float) ||
        !__builtin_types_compatible_p(__typeof__(3i), __complex__ int) ||
        !__builtin_types_compatible_p(__typeof__(7uIl), __complex__ unsigned long) ||
        __real__ stored != 0.0f || __imag__ stored != 1.25f ||
        __real__ extended != 0.0L || __imag__ extended != 2.5L ||
        __real__ count != 0UL || __imag__ count != 7UL ||
        __real__ wide != 0ULL || __imag__ wide != 0x100000003ULL ||
        __real__ value != 3.0 || __imag__ value != 6.0 || __imag__ local != 2.0f;
}
