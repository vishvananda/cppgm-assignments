#define PRESENT
#define ALIAS ABSENT
#if 0
#error initial group should be skipped
#elifdef ALIAS
#define FIRST 17
#elifndef ABSENT
#error the first satisfied branch wins
#endif

#if 0
#elifdef ABSENT
#error macros are tested as written
#elifndef ABSENT
#define SECOND 25
#elifdef PRESENT
#error a prior branch was selected
#endif

int main(void) { return FIRST + SECOND != 42; }
