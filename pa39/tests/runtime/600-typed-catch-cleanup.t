extern "C" void raise_remote(int);
extern "C" int cleanups;
struct Guard { ~Guard() { ++cleanups; } };
extern "C" int guarded(int kind) {
    try {
        Guard g;
        raise_remote(kind);
        return 1;
    } catch (int n) {
        return n;
    }
}
