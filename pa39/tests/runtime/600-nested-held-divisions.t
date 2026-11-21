// An outer loop divides by one literal before its inner loop and by another
// after it, and the inner loop divides by a third. Each multiplier is built
// in the block that enters its loop and held in a register through the loop:
// the inner loop's multiplier must not take the register that holds the
// outer loop's second one.
static int a[64], b[64];

__attribute__((noinline)) long run(const int* x, const int* y, int n, int m) {
    long sum = 0;
    for (int i = 0; i < n; ++i) {
        int q = x[i] / 7;
        for (int j = 0; j < m; ++j)
            sum += (y[j] + q) / 11;
        sum += x[i + 1] / 13;
    }
    return sum;
}

int main() {
    for (int i = 0; i < 64; ++i) {
        a[i] = i * 1000003 - 12345;
        b[i] = i * 77777 + 999;
    }
    return (int)(run(a, b, 60, 50) % 101);
}
