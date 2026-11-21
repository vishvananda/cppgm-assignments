// Fourteen values live across each call: more than the preserved registers
// hold, so some live in frame homes and are loaded at each use. A use needs
// no load when a register still holds what the last load of the home or
// store to it left there, and a move when another register holds it.
extern "C" __attribute__((noinline)) unsigned long step(unsigned long x) {
    return x * 3 + 1;
}

extern "C" __attribute__((noinline)) unsigned long spread(const unsigned long* p) {
    unsigned long a0 = p[0], a1 = p[1], a2 = p[2], a3 = p[3], a4 = p[4], a5 = p[5], a6 = p[6];
    unsigned long a7 = p[7], a8 = p[8], a9 = p[9], a10 = p[10], a11 = p[11], a12 = p[12], a13 = p[13];
    unsigned long r = step(a0);
    r = (((((r + a12) * a12) ^ a12) - a12) | a12) * a13;
    r = ((((r + a13) * a13) ^ a13) - a13) & a11;
    r += step(r ^ a1);
    r = (((((r + a11) * a11) ^ a11) - a11) | a11) * a12;
    r += step(r + a2);
    return r + a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13;
}
