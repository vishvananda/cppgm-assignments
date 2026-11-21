// -ffixed-x18 reserves x18 on Linux as Darwin reserves it, and
// -fsanitize=shadow-call-stack does too: the shadow stack's pointer lives
// there. The loop of 700-platform-register-loop, where Linux code takes x18
// for one of the twenty sums, names no x18 under the flag.
extern "C" __attribute__((noinline)) long crowded(const long* a, int n) {
    long s0 = 1, s1 = 2, s2 = 3, s3 = 4, s4 = 5, s5 = 6, s6 = 7, s7 = 8, s8 = 9, s9 = 10,
        s10 = 11, s11 = 12, s12 = 13, s13 = 14, s14 = 15, s15 = 16, s16 = 17, s17 = 18, s18 = 19, s19 = 20;
    for (int i = 0; i < n; ++i) {
        const long v = a[i];
        s0 += v ^ s1;
        s1 += v ^ s2;
        s2 += v ^ s3;
        s3 += v ^ s4;
        s4 += v ^ s5;
        s5 += v ^ s6;
        s6 += v ^ s7;
        s7 += v ^ s8;
        s8 += v ^ s9;
        s9 += v ^ s10;
        s10 += v ^ s11;
        s11 += v ^ s12;
        s12 += v ^ s13;
        s13 += v ^ s14;
        s14 += v ^ s15;
        s15 += v ^ s16;
        s16 += v ^ s17;
        s17 += v ^ s18;
        s18 += v ^ s19;
        s19 += v ^ s0;
    }
    return s0 + s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8 + s9 +
        s10 + s11 + s12 + s13 + s14 + s15 + s16 + s17 + s18 + s19;
}
