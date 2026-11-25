enum Color { Red, Blue };

static int bump(int *count)
{
    return ++*count;
}

int main(void)
{
    int effects = 0;
    int array[3] = {0};
    enum { unary = __builtin_classify_type((bump(&effects), Red)) };
    if (unary != 1 || effects != 0 ||
        __builtin_classify_type((_Bool)1) != 1 ||
        __builtin_classify_type(_Bool) != 4 ||
        __builtin_classify_type(enum Color) != 3 ||
        __builtin_classify_type(array) != 5 ||
        __builtin_classify_type(__typeof__(array)) != 14 ||
        __builtin_classify_type(int[bump(&effects)]) != 14 ||
        __builtin_classify_type(_Complex double) != 9 ||
        effects != 0)
        return 1;
    return __builtin_classify_type(bump(&effects), bump(&effects)) != 1 || effects != 2;
}
