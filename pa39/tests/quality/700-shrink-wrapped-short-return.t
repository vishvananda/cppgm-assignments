extern "C" long record(long value);

// Both stores run frameless and end in a copy of the short return they
// share, so neither jumps to it. Only the call path builds a frame.
extern "C" long store_then_return(long k, long* p) {
    if (k < 0)
        return record(-k) + 1;
    if (k & 1)
        p[0] = k;
    else
        p[1] = k * 3;
    return k + 48;
}
