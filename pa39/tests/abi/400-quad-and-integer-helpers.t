using W = unsigned __int128;
extern "C" long double adjust(long double x, long double y) {
    return x * y + 2.5L;
}
extern "C" double divide_wide(W x, W y) {
    return static_cast<double>(x / y) + static_cast<double>(x % y);
}
extern "C" unsigned long long high_word(unsigned long long a, unsigned long long b) {
    return (W(a) * W(b)) >> 64;
}
extern "C" unsigned long long xor_words(unsigned long long a, unsigned long long b) {
    W product = W(a) * W(b);
    return static_cast<unsigned long long>(product >> 64) ^ static_cast<unsigned long long>(product);
}
extern "C" unsigned long long signed_high_word(long long a, long long b) {
    return W(static_cast<__int128>(a) * static_cast<__int128>(b)) >> 64;
}
extern "C" unsigned compare_quad(long double x, long double y) {
    return (x < y) | ((x <= y) << 1) | ((x > y) << 2) | ((x >= y) << 3) |
        ((__builtin_isinf(x) != 0) << 4);
}
extern "C" double _Complex divide_complex(double _Complex x, double _Complex y) {
    return x / y;
}
