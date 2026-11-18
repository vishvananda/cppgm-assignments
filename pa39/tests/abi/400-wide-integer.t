using Wide = unsigned __int128;
extern "C" Wide transform(Wide x, Wide y, unsigned count) {
    return ((x * y + x - y) >> count) ^ (x << (count / 2));
}
