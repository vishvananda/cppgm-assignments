#define suffix expanded
#define STRING_AS_WRITTEN(x) #x
#define STRING(x) STRING_AS_WRITTEN(x)
#define JOIN(a, b) a ## b
#define EXPONENTS STRING(0x1p+suffix 0x1P-suffix 1e+suffix 1E-suffix)

static int different(const char *left, const char *right)
{
    while (*left && *left == *right)
    {
        ++left;
        ++right;
    }
    return *left != *right;
}
