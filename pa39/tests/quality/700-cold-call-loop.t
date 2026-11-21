// Outer loops carry values across a rarely taken call in the inner loop.
// The inner loop's values are the hot ones.
struct Complex {
    double re, im;
};

int clamped;

extern "C" __attribute__((noinline)) Complex clamped_product(Complex a, Complex b) {
    ++clamped;
    Complex r = {a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re};
    if (r.re > 12) r.re = 12;
    return r;
}

static inline Complex product(Complex a, Complex b) {
    Complex r = {a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re};
    if (r.re > 12) r = clamped_product(a, b);
    return r;
}

extern "C" __attribute__((noinline)) void butterflies(
    Complex* data, unsigned long count, const Complex* roots, unsigned long stages) {
    unsigned long span = 2, half = 1;
    for (unsigned long stage = 0; stage < stages; ++stage) {
        Complex step = roots[stage], twiddle = {1, 0};
        for (unsigned long first = 0; first < half; ++first) {
            for (unsigned long k = first; k < count; k += span) {
                Complex t = product(twiddle, data[k + half]), u = data[k];
                data[k] = {u.re + t.re, u.im + t.im};
                data[k + half] = {u.re - t.re, u.im - t.im};
            }
            twiddle = product(twiddle, step);
        }
        span <<= 1;
        half <<= 1;
    }
}
