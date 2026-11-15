#if __cplusplus != 201703L
#error wrong language mode
#endif
#define CAT_INNER(a, b) a ## b
#define CAT(a, b) CAT_INNER(a, b)
CAT(re, quires)
