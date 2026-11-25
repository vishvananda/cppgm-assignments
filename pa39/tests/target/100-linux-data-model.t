#if !defined(__aarch64__) || !defined(__AARCH64EL__) || !defined(__linux__) || defined(__x86_64__) || defined(__SSE2__)
#error wrong architecture
#endif
static_assert(sizeof(void*) == 8 && sizeof(long) == 8, "LP64");
static_assert(__is_same(__INT8_TYPE__, signed char) && __is_same(__UINT8_TYPE__, unsigned char), "8-bit header types");
static_assert(__is_same(__INT16_TYPE__, short) && __is_same(__UINT16_TYPE__, unsigned short), "16-bit header types");
static_assert(__is_same(__INT32_TYPE__, int) && __is_same(__UINT32_TYPE__, unsigned int), "32-bit header types");
static_assert(__is_same(__INT64_TYPE__, long) && __is_same(__UINT64_TYPE__, unsigned long), "64-bit header types");
static_assert(__is_same(decltype(__INT32_MAX__), __INT32_TYPE__) && __INT32_MAX__ == 2147483647, "signed 32-bit maximum");
static_assert(__is_same(decltype(__UINT32_MAX__), __UINT32_TYPE__) && __UINT32_MAX__ == 4294967295U, "unsigned 32-bit maximum");
static_assert(__is_same(decltype(__INT64_MAX__), __INT64_TYPE__) && __INT64_MAX__ == 9223372036854775807L, "signed 64-bit maximum");
static_assert(__is_same(decltype(__UINT64_MAX__), __UINT64_TYPE__) && __UINT64_MAX__ == 18446744073709551615UL, "unsigned 64-bit maximum");
static_assert(__is_same(__INTMAX_TYPE__, long) && __is_same(__UINTMAX_TYPE__, unsigned long), "maximum-width integers");
static_assert(__INTMAX_WIDTH__ == 64 && __UINTMAX_MAX__ == __UINT64_MAX__, "maximum-width limits");
static_assert(__WCHAR_WIDTH__ == 32 && __WCHAR_MAX__ == __UINT32_MAX__, "wide character limits");
static_assert(__is_same(__CHAR16_TYPE__, unsigned short) && __is_same(__CHAR32_TYPE__, unsigned int), "Unicode character types");
static_assert(__is_same(__SIZE_TYPE__, unsigned long) && __SIZE_MAX__ == __UINT64_MAX__, "size limits");
static_assert(sizeof(__builtin_va_list) == 32, "variadic register save state");
static_assert(char(-1) > 0 && wchar_t(-1) > 0, "unsigned character types");
#if defined(__CPPGM__)
#if __GNUG__ != __GNUC__ || __GNUG__ < 4
#error GNU C++ headers use the matching GNU version
#endif
static_assert(__FLT_EVAL_METHOD__ == 0, "evaluate at the nominal precision");
static_assert(__FLT_IS_IEC_60559__ == 1 && __DBL_IS_IEC_60559__ == 1 && __LDBL_IS_IEC_60559__ == 1,
              "floating formats consumed by GNU float.h");
static_assert(__SCHAR_WIDTH__ == __CHAR_BIT__, "GNU byte width for limits.h");
static_assert(__LONG_LONG_WIDTH__ == sizeof(long long) * __CHAR_BIT__, "GNU long long width for limits.h");
#endif
static_assert(sizeof(long double) == 16 && __LDBL_MANT_DIG__ == 113, "binary128");
#if !defined(__STRICT_ANSI__)
static_assert(__is_same(__GLIBCXX_TYPE_INT_N_0, __int128) && __GLIBCXX_BITSIZE_INT_N_0 == 128, "GNU dialects name the 128-bit integer for the library");
#endif
#define STRINGIFY_IMPL(value) #value
#define STRINGIFY(value) STRINGIFY_IMPL(value)
static_assert(sizeof(STRINGIFY(__USER_LABEL_PREFIX__)) == 1, "ELF declaration redirects use an empty prefix");
int main() { return sizeof(long double) + sizeof(void*); }
