#define NONEMPTY wrong
#if __has_include("c-include-local.h" NONEMPTY)
int unexpected;
#endif
