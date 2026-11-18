// expect exit 0
#if __STDC__ != 1 || __STDC_VERSION__ != 199901L
#error wrong C99 language version
#endif
#ifdef __cplusplus
#error C++ language selected
#endif
int main(void) { return 0; }
