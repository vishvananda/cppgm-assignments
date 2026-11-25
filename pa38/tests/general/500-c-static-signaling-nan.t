static volatile float f = -__builtin_nansf("0x123");
static volatile double d = +__builtin_nans("0x456");
static volatile long double ld = -__builtin_nansl("0x789");

int main(void)
{
    float f_value = f;
    double d_value = d;
    unsigned f_bits = 0;
    unsigned long long d_bits = 0;
    __builtin_memcpy(&f_bits, &f_value, sizeof(f_bits));
    __builtin_memcpy(&d_bits, &d_value, sizeof(d_bits));
    if (f_bits != 0xff800123U || d_bits != 0x7ff0000000000456ULL)
        return 1;
    if (!__builtin_issignaling(ld) || !__builtin_signbit(ld))
        return 2;
    return 0;
}
