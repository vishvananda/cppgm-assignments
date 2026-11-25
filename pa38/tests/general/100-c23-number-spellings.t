#define COMBINE(a, b) a ## b
#define STRINGIZE(a) #a
#if 0b10 != 2 || 1'234 != 1234
#error bad separated or binary preprocessing number
#endif

#line 1'234
#if __LINE__ != 1234
#error incorrect decimal line number
#endif

int main(void)
{
    static const char separated[] = STRINGIZE(1'234);
    return COMBINE(0x, 2'A) != 42 || 1.2'5e+0'1 != 12.5 || 0x0'e-0xe != 0 ||
           !_Generic(0b101010, int: 1, default: 0) || 0b101010 != 42 ||
           !_Generic(0b1010u, unsigned int: 1, default: 0) || 0b1010u != 10 ||
           !_Generic(0b1'000ULL, unsigned long long: 1, default: 0) || 0b1'000ULL != 8 ||
           sizeof separated != 6 || separated[1] != '\'' || separated[4] != '4';
}
