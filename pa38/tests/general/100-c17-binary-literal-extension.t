#define PASTE(a, b) a ## b
#if PASTE(0, b101010) != 42
#error wrong preprocessing value
#endif
int main(void)
{
    return 0B101010u != 42 || 0b101010ULL != 42;
}
