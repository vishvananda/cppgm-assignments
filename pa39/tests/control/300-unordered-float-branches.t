// The optimizer inverts floating comparisons into their unordered forms
// (ult, ule, ugt, uge), which hold when an operand is NaN. Each of these
// functions reaches such a comparison as a branch, a selection or a value.
static int differs(double a, double b) {
    double d = a - b;
    return d > 1e-12 || d < -1e-12;
}

extern "C" __attribute__((noinline)) int settle(double x) {
    double xk = 1;
    int it = 8;
    while (it--) {
        double xn = (xk + x / xk) / 2;
        if (!differs(xn, xk))
            return 100 + it;
        xk = xn;
    }
    return it;
}

extern "C" __attribute__((noinline)) int count_outside(const double* values, int n, double low, double high) {
    int outside = 0;
    for (int i = 0; i < n; ++i)
        if (!(values[i] >= low && values[i] <= high))
            ++outside;
    return outside;
}

extern "C" __attribute__((noinline)) double clamp_below(double v, double limit) {
    return !(v < limit) ? limit : v;
}

extern "C" __attribute__((noinline)) int not_greater(float a, float b) {
    return !(a > b);
}

extern "C" __attribute__((noinline)) int first_unordered(const float* values, int n, float bound) {
    for (int i = 0; i < n; ++i)
        if (!(values[i] <= bound))
            return i;
    return -1;
}

extern "C" __attribute__((noinline)) int not_at_least(double a, double b) {
    return !(a >= b);
}
