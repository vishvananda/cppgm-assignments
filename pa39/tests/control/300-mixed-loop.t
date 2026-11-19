extern "C" int twice(int);
extern "C" int series(const int* a, int count) {
    int sum = 5;
    for (int i = 0; i < count; ++i)
        sum += a[i] < 0 ? twice(-a[i]) : a[i];
    return sum;
}

extern "C" void overwrite(volatile int*);
extern "C" int pressure(volatile int* p, unsigned rounds) {
    int x = 3, y = 5, z = 7;
    for (unsigned i = 0; i < rounds; ++i) {
        int a = p[0], b = p[1], c = p[2], d = p[3], e = p[4], f = p[5];
        int g = p[6], h = p[7], j = p[8], k = p[9], m = p[10], n = p[11];
        overwrite(p);
        int next = x + a - b + 2*c - d + 3*e - f + 4*g - h + 5*j - k + 6*m - n;
        x = y;
        y = z;
        z = next;
    }
    return x + 3*y + 7*z;
}

extern "C" unsigned rotate(unsigned rounds, unsigned a, unsigned b, unsigned c) {
    unsigned short x = 0xabcd, y = 0x1234;
    unsigned sum = 0;
    while (rounds--) {
        unsigned t = a;
        a = b;
        b = c;
        c = t;
        unsigned short u = x;
        x = y;
        y = u;
        sum += a ^ x;
    }
    return a ^ (3*b) ^ (7*c) ^ (unsigned(x) << 16) ^ y ^ sum;
}

extern "C" unsigned long exit_pair(unsigned a, unsigned b, unsigned limit, unsigned stop) {
    for (unsigned i = 0; i < limit; ++i) {
        unsigned old = a;
        a = (a ^ b) + i;
        if (i == stop) return (static_cast<unsigned long>(old) << 32) | a;
        b += a;
    }
    return (static_cast<unsigned long>(b) << 32) | a;
}

extern "C" void mark_nonzero(const int* mask, int* output, int last) {
    for (int i = 0; i <= last; ++i)
        if (mask[i]) output[i] = 7;
}

extern "C" const long* bucket_start(const long* base, long position) {
    long bucket = position / 64;
    long remainder = position - bucket * 64;
    const long* at = base + bucket;
    return remainder < 0 ? at - 1 : at;
}

extern "C" const long* skip_bucket_start(const long* base, long position) {
    const long* at = base + position / 64;
    return position % 64 < 0 ? at - 2 : at;
}

extern "C" void observe_round(unsigned);
extern "C" void rotate_floats(double* wide, float* narrow, unsigned rounds) {
    double a = wide[0], b = wide[1], c = wide[2], d = wide[3], e = wide[4], f = wide[5];
    float p = narrow[0], q = narrow[1], r = narrow[2], s = narrow[3], t = narrow[4], u = narrow[5];
    for (unsigned i = 0; i < rounds; ++i) {
        if (i & 1) {
            double first = a;
            a = b; b = c; c = d; d = e; e = f; f = first + 0.5;
            float last = u;
            u = t; t = s; s = r; r = q; q = p; p = last + 0.25f;
        } else {
            double last = f;
            f = e; e = d; d = c; c = b; b = a; a = last - 1;
            float first = p;
            p = q; q = r; r = s; s = t; t = u; u = first - 0.5f;
        }
        if (i % 3 == 1) observe_round(i);
    }
    wide[0] = a; wide[1] = b; wide[2] = c; wide[3] = d; wide[4] = e; wide[5] = f;
    narrow[0] = p; narrow[1] = q; narrow[2] = r; narrow[3] = s; narrow[4] = t; narrow[5] = u;
}
