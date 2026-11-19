extern "C" void raise_remote(int);
extern "C" int cleanups;
extern "C" int cursor_cleanup;
struct Guard { ~Guard() { ++cleanups; } };
struct Cursor {
    const int* position;
    ~Cursor() { cursor_cleanup = position[0]; }
};
inline void advance_cursor(Cursor& cursor, const int* second, int i, int fail) {
    if (i == 1) cursor.position = second;
    if (i == fail) raise_remote(1);
}
extern "C" int guarded(int kind) {
    try {
        Guard g;
        raise_remote(kind);
        return 1;
    } catch (int n) {
        return n;
    }
}
extern "C" int cursor_total(const int* first, const int* second, int count, int fail) {
    Cursor cursor{first};
    int total = 0;
    for (int i = 0; i < count; ++i) {
        advance_cursor(cursor, second, i, fail);
        if (i & 1) total += cursor.position[0];
        else total += cursor.position[1];
    }
    return total;
}
