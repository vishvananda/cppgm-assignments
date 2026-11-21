// A loop that swaps two values makes a cycle of moves on its back edge.
// Register moves through a scratch register make the cycle, so the phi
// snapshot area is not reserved and the leaf function keeps no frame.
extern "C" unsigned long swap_sum(unsigned long a, unsigned long b, unsigned long n) {
    unsigned long sum = 0;
    for (unsigned long i = 0; i < n; ++i) {
        sum += a * i;
        unsigned long t = a;
        a = b + i;
        b = t;
    }
    return sum;
}
