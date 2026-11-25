#if EXPECT_HOSTED != __STDC_HOSTED__
#error unexpected C execution environment
#endif

#if defined(__APPLE__)
#if !defined(__STDC_NO_THREADS__) || __STDC_NO_THREADS__ != 1
#error the Darwin target must advertise the C11 threads exclusion
#endif
#elif defined(__STDC_NO_THREADS__)
#error an unexpected compiler predefine excludes the C11 threads API
#endif

#if __STDC_HOSTED__
int main(int argc, char *argv[])
{
    if (__STDC_HOSTED__ != 1 || argc < 1 || !argv[0])
        return 1;
}
#else
static inline int main(int value) { return value + 2; }

__SIZE_TYPE__ strlen(const char *);

int freestanding_probe(void)
{
    return main(40) != 42 || strlen("abc") != 17 || __builtin_popcount(0x55u) != 4;
}
#endif
