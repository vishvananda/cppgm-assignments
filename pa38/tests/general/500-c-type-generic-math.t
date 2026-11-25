static int candidates;
static int arguments;

double unused_candidate(double);

static float single(float x) { return x + 1.0f; }
static double twice(double x) { return x * 2.0; }
static long double triple(long double x) { return x * 3.0L; }

static float (*single_candidate(void))(float)
{
    ++candidates;
    return single;
}

static double (*double_candidate(void))(double)
{
    candidates += 10;
    return twice;
}

static float argument(void)
{
    ++arguments;
    return 2.0f;
}

static int integral_single(float x, float y, int fixed) { return 10 + fixed; }
static int integral_double(double x, double y, int fixed) { return 20 + fixed; }

static float narrow_double(double x) { return 31.0f; }
static float narrow_long(long double x) { return 47.0f; }

static float real_single(_Complex float x) { return __real__ x + __imag__ x; }
static double real_double(_Complex double x) { return __real__ x - __imag__ x; }

#define PICK(X) __builtin_tgmath(twice, single, triple, (X))
#define CALL_WITH_EFFECTS() __builtin_tgmath(single_candidate(), double_candidate(), argument())

int main(void)
{
    typedef char float_result[__builtin_types_compatible_p(__typeof__(PICK(1.0f)), float) ? 1 : -1];
    typedef char int_result[__builtin_types_compatible_p(__typeof__(PICK(1)), double) ? 1 : -1];
    typedef char long_result[__builtin_types_compatible_p(__typeof__(PICK(1.0L)), long double) ? 1 : -1];
    if (sizeof(CALL_WITH_EFFECTS()) != sizeof(float) || candidates != 0 || arguments != 0)
        return 1;
    if (CALL_WITH_EFFECTS() != 3.0f || candidates != 1 || arguments != 1)
        return 2;
    if (PICK(PICK(2.0f)) != 4.0f || PICK(2) != 4.0 || PICK(2.0L) != 6.0L ||
        __builtin_tgmath(unused_candidate, single, 2.0f) != 3.0f)
        return 3;
    if (__builtin_tgmath(integral_single, integral_double, 1.0f, 2.0f, 3) != 13 ||
        __builtin_tgmath(integral_single, integral_double, 1.0f, 2, 3) != 23)
        return 4;
    if (__builtin_tgmath(narrow_long, narrow_double, 2.0f) != 47.0f ||
        __builtin_tgmath(narrow_long, narrow_double, 2.0) != 31.0f)
        return 5;
    if (__builtin_tgmath(real_single, real_double, 2.0f) != 2.0f ||
        __builtin_tgmath(real_single, real_double, __extension__ (3.0 + 1.0i)) != 2.0)
        return 6;
    return 0;
}
