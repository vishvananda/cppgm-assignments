// A test of two comparisons joined by || runs as one compare, one
// conditional compare and one branch when the second comparison is all its
// block does and runs about as often as the first: the Newton iteration
// below takes one branch per step for its convergence test.
static int differs(double a, double b) {
    double d = a - b;
    return d > 1e-12 || d < -1e-12;
}

extern "C" double settle(double x) {
    double xk = 1, xn = 0;
    int it = 100;
    while (it--) {
        xn = (xk + x / xk) / 2;
        if (!differs(xn, xk))
            return xn;
        xk = xn;
    }
    return xn;
}

// The second test of a NaN check runs only for a NaN; it stays a branch
// of its own.
extern "C" int count_nan_pairs(const double* re, const double* im, int n) {
    int count = 0;
    for (int i = 0; i < n; ++i)
        if (re[i] != re[i] && im[i] != im[i])
            ++count;
    return count;
}
