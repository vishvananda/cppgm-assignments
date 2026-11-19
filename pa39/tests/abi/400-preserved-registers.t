using U = unsigned long;
extern "C" U sample(U);
extern "C" U kernel(U seed) {
    U a=sample(seed), b=sample(seed+1), c=sample(seed+2), d=sample(seed+3);
    U e=sample(seed+4), f=sample(seed+5), g=sample(seed+6), h=sample(seed+7);
    U i=sample(seed+8), j=sample(seed+9), k=sample(seed+10), l=sample(seed+11);
    return (a+b) ^ (c+d) ^ (e+f) ^ (g+h) ^ (i+j) ^ (k+l);
}

extern "C" double sample_fp(U);
extern "C" U fp_kernel(U seed) {
    double a=sample_fp(seed), b=sample_fp(seed+1), c=sample_fp(seed+2), d=sample_fp(seed+3);
    double e=sample_fp(seed+4), f=sample_fp(seed+5), g=sample_fp(seed+6), h=sample_fp(seed+7);
    U salt=sample(seed);
    return U(a+b+c+d+e+f+g+h) ^ salt;
}

extern "C" U sample_cold(U);
extern "C" U cold_fp_kernel(const volatile double* values, U seed, bool call) {
    double a = values[0], b = values[1], c = values[2], d = values[3];
    double e = values[4], f = values[5], g = values[6], h = values[7];
    double i = values[8], j = values[9], k = values[10], l = values[11];
    if (__builtin_expect(call, 0)) seed = sample_cold(seed);
    double x = double(seed & 31) + 0.5;
    return U((a+x)*(b+x) + (c+x)*(d+x) + (e+x)*(f+x) +
             (g+x)*(h+x) + (i+x)*(j+x) + (k+x)*(l+x));
}

extern "C" U fold_args(U, U, U, U, U, U, U, U);
extern "C" U shuffle_args(U a, U b, U c, U d, U e, U f, U g, U h) {
    return fold_args(h,g,f,e,d,c,b,a) ^ fold_args(b,a,d,c,3,g,h,f);
}
