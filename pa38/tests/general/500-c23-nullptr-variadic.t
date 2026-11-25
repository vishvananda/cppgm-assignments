#if !__has_builtin(__builtin_c23_va_start)
#error missing C23 variadic builtin
#endif

static volatile int evaluated;

static int from_ellipsis(...)
{
    __builtin_va_list arguments;
    __builtin_c23_va_start(arguments);
    int first = __builtin_va_arg(arguments, int);
    double second = __builtin_va_arg(arguments, double);
    char *end = __builtin_va_arg(arguments, char *);
    __builtin_va_end(arguments);
    return first == 17 && second == 1.5 && end == nullptr;
}

static int from_named(int first, ...)
{
    __builtin_va_list arguments;
    __builtin_c23_va_start(arguments, ++evaluated);
    void *end = __builtin_va_arg(arguments, void *);
    __builtin_va_end(arguments);
    return first == 22 && end == nullptr;
}

int main(void)
{
    int (*volatile read)(...) = from_ellipsis;
    typeof(nullptr) end = nullptr;
    return !read(17, 1.5, nullptr) || !from_named(22, end) || evaluated != 0;
}
