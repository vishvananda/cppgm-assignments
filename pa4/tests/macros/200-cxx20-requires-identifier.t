#if __cplusplus != 202002L
#error wrong language mode
#endif
#define CAT_INNER(a, b) a ## b
#define CAT(a, b) CAT_INNER(a, b)
CAT(re, quires)
