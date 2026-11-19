#if !defined(__aarch64__) || !defined(__AARCH64EL__) || !defined(__linux__) || defined(__x86_64__) || defined(__SSE2__)
#error wrong architecture
#endif
static_assert(sizeof(void*) == 8 && sizeof(long) == 8, "LP64");
static_assert(__is_same(__INT64_TYPE__, long) && __is_same(__UINT64_TYPE__, unsigned long), "64-bit header types");
static_assert(sizeof(__builtin_va_list) == 32, "variadic register save state");
static_assert(char(-1) > 0 && wchar_t(-1) > 0, "unsigned character types");
static_assert(sizeof(long double) == 16 && __LDBL_MANT_DIG__ == 113, "binary128");
#define STRINGIFY_IMPL(value) #value
#define STRINGIFY(value) STRINGIFY_IMPL(value)
static_assert(sizeof(STRINGIFY(__USER_LABEL_PREFIX__)) == 1, "ELF declaration redirects use an empty prefix");
int main() { return sizeof(long double) + sizeof(void*); }
