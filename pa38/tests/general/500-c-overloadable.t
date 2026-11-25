#if !__has_attribute(__overloadable__) || !__has_attribute(unavailable) || !__has_extension(overloadable_unmarked)
#error expected Clang C overload support
#endif

#define OVERLOAD __attribute__((overloadable))

int select_number(int);
int select_number(float) OVERLOAD;

static int scalar_rank(int value) OVERLOAD
{
    return value + 11;
}

static OVERLOAD int scalar_rank(long double value)
{
    return (int)value + 21;
}

static int pointer_rank(char *value) OVERLOAD
{
    return *value + 31;
}

static int pointer_rank(const unsigned char *value) OVERLOAD
{
    return *value + 41;
}

static int pointer_rank(...) OVERLOAD
{
    return 51;
}

static __attribute__((unavailable("arithmetic arguments only"), overloadable)) void promotion(...);
static OVERLOAD float promotion(float);
static OVERLOAD double promotion(int);

static int file_scope_calls(void)
{
    int (*select_float)(float) = &select_number;
    return select_number(4) == 5 && select_number(4.0f) == 6 && select_float(5.0f) == 7;
}

int main(void)
{
    OVERLOAD int select_number(double);
    int effects = 1;
    __typeof__(promotion(++effects)) value = 2.0;
    typedef char integer_promotion[__builtin_types_compatible_p(__typeof__(value), double) ? 1 : -1];
    typedef char float_promotion[__builtin_types_compatible_p(__typeof__(promotion(1.0f)), float) ? 1 : -1];

    char character = 3;
    unsigned char unsigned_character = 4;
    int unrelated = 0;
    return !file_scope_calls() || select_number(value) != 5 || scalar_rank(value) != 23 ||
        pointer_rank(&character) != 34 || pointer_rank(&unsigned_character) != 45 ||
        pointer_rank(&unrelated) != 51 || effects != 1;
}
