static int regular(double a, double b) { return 1; }
static int binary64(_Float64 a, _Float64 b) { return 2; }
static int extended(_Float32x a, _Float32x b) { return 3; }

static int imaginary_single(_Complex float a) { return 4; }
static int imaginary_double(_Complex double a) { return 5; }

int main(void)
{
    return __builtin_tgmath(regular, binary64, extended, (_Float32x)1, 2) != 3 ||
        __builtin_tgmath(extended, regular, binary64, 1.0, (_Float32x)2) != 1 ||
        __builtin_tgmath(binary64, extended, regular, (_Float32x)1, (_Float64)2) != 2 ||
        __builtin_tgmath(imaginary_single, imaginary_double, 3i) != 5;
}
