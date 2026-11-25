static volatile float rounded_float = 0x1.ffffffp127f;
static volatile double overflow_double = -1.234e1234;
static volatile long double overflow_long_double = 1.234e56789L;
static volatile float largest_float = 0x1.fffffep127f;
static volatile float smallest_float = 0x1p-149f;
static volatile double negative_zero = -1.234e-56789;

typedef char double_type[__builtin_types_compatible_p(__typeof__(1.234e1234), double) ? 1 : -1];

static float local_float(void) { return 1.234e1234f; }
static double local_double(void) { return 0x1p1024; }
static long double local_long_double(void) { return -1.234e56789L; }

int main(void)
{
    if (!__builtin_isinf(rounded_float) || !__builtin_isinf(local_float()))
        return 1;
    if (!__builtin_isinf(overflow_double) || !(overflow_double < 0.0))
        return 2;
    if (!__builtin_isinf(local_double()) || !__builtin_isinf(overflow_long_double))
        return 3;
    long double local = local_long_double();
    if (!__builtin_isinf(local) || !(local < 0.0L))
        return 4;
    if (__builtin_isinf(largest_float) || !(smallest_float > 0.0f))
        return 5;
    return negative_zero != 0.0 || !__builtin_signbit(negative_zero);
}
