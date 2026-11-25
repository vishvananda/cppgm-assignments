#define UNUSED ??/
#define NEXT_LINE 42
#if NEXT_LINE != 42
#error trigraphs must not splice lines in this mode
#endif

_Static_assert(sizeof("??=") == 4);

int main(void) { return 0; }
