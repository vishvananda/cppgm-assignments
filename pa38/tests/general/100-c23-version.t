#if !defined(__STDC_VERSION__) || __STDC_VERSION__ != 202311L
#error C23 version macro has the wrong value
#endif
#if __BOOL_WIDTH__ != 1
#error incorrect boolean width
#endif
#ifdef __cplusplus
#error C mode must leave the C++ version macro undefined
#endif

static_assert(_Generic((__CHAR8_TYPE__)0, unsigned char: 1, default: 0));

int main(void) { return 0; }
