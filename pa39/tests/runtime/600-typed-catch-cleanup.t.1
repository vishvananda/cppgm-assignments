extern "C" { int cleanups = 0; }
extern "C" int guarded(int);
extern "C" void raise_remote(int kind) {
    if (kind == 1) throw 17;
    if (kind == 2) throw 2.0;
}
int main() {
    if (guarded(0) != 1 || guarded(1) != 17) return 1;
    try { guarded(2); }
    catch (double d) { return d == 2 && cleanups == 3 ? 39 : 2; }
    return 3;
}
