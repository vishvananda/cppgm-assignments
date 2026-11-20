#ifdef __cpp_char8_t
#error char8_t belongs to C++20
#endif
#if u8'A' != 65 || u8'\0' != 0
#error incorrect UTF-8 literal value
#endif
#define PASTE(a,b) a ## b
PASTE(u8, 'A')
