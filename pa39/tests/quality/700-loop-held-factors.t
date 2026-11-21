// A multiply reads its factor from a register. A factor that is neither a
// power of two nor one more than a power of two (which a shift or a
// shifted addition forms) is built once, before the loop, and read from a
// register on every pass: 2654435761 needs two moves, 40503 and 37 one.
extern "C" unsigned mix(const unsigned* in, int n) {
    unsigned h = 1, g = 2, f = 3;
    for (int i = 0; i < n; ++i) {
        h = (h ^ in[i]) * 2654435761u;
        g = (g + in[i]) * 40503u;
        f = (f - in[i]) * 37u;
    }
    return h ^ g ^ f;
}
