#if __cplusplus != 202002L || __cpp_char8_t != 202207L
#error wrong language mode
#endif
#if u8'\xFF' != 255 || u8'A' != 65
#error wrong UTF-8 code unit value
#endif
#define PASTE(a,b) a ## b
PASTE(u8, 'A')
char8_t
