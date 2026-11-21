// Every path that ends the function returns where it ends: no path jumps
// to another path's return.
extern "C" void spread(long** slot, long* const* from, const char* steps) {
    long* count = *from;
    *slot = count;
    if (!count)
        return;
    if (*steps) {
        for (long i = 0; steps[i]; ++i)
            count[i] += i;
    } else
        ++*count;
}
