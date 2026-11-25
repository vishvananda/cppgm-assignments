#define PASTE(a, b) a ## b
#if PASTE(0, b101010) == 42
int accepted;
#endif
