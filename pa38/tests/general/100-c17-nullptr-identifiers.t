#if __has_builtin(__builtin_c23_va_start)
#error C17 advertised the C23 variadic builtin
#endif

static int nullptr = 20, nullptr_t = 22;
static int alignas, alignof;

int main(void)
{
    return nullptr + nullptr_t + alignas + alignof != 42;
}
