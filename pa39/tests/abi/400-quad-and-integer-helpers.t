using W = unsigned __int128;
extern "C" long double adjust(long double x, long double y) {
    return x * y + 2.5L;
}
extern "C" double divide_wide(W x, W y) {
    return static_cast<double>(x / y) + static_cast<double>(x % y);
}
