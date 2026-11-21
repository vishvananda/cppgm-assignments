// A rare edge whose moves wait out of line until after 20480 struct
// copies. Its conditional branch is about 298,000 instructions from those
// moves, beyond the 2^18-instruction reach of B.cond, so it becomes a
// branch on the inverse condition over a jump. Each group of 4096 copies
// has its own test, which reaches past the group; the runs skip every group
// so that the guest does not translate the copies.
typedef unsigned long U;

struct line {
    U w[16];
};

line src[64], dst[0x5000];
volatile U vin[64];
volatile int fill;

#ifdef __CPPGM__
// Pasted hexadecimal digits keep each index a literal.
#define S(k) dst[k] = src[(k) & 63];
#define X16(k) \
    S(k##0) S(k##1) S(k##2) S(k##3) S(k##4) S(k##5) S(k##6) S(k##7) \
    S(k##8) S(k##9) S(k##a) S(k##b) S(k##c) S(k##d) S(k##e) S(k##f)
#define X256(k) \
    X16(k##0) X16(k##1) X16(k##2) X16(k##3) X16(k##4) X16(k##5) X16(k##6) X16(k##7) \
    X16(k##8) X16(k##9) X16(k##a) X16(k##b) X16(k##c) X16(k##d) X16(k##e) X16(k##f)
#define X4096(k) \
    X256(k##0) X256(k##1) X256(k##2) X256(k##3) X256(k##4) X256(k##5) X256(k##6) X256(k##7) \
    X256(k##8) X256(k##9) X256(k##a) X256(k##b) X256(k##c) X256(k##d) X256(k##e) X256(k##f)
#define G(k) \
    if (__builtin_expect(fill != 0, 1)) { \
        X4096(k) \
    }
#define COPIES G(0x0) G(0x1) G(0x2) G(0x3) G(0x4)
#else
// Clang's instruction schedulers take minutes over a block this long.
#define COPIES \
    if (fill) \
        for (int k = 0; k < 0x5000; k++) \
            dst[k] = src[k & 63];
#endif

__attribute__((noinline)) U mix(const volatile U* p, U n) {
    U a = n, b = p[1], c = n * 7;
    if (__builtin_expect(p[0] == 77, 0)) {
        U t = a;
        a = b;
        b = c;
        c = t;
    } else {
        COPIES
        a = a * 3 + p[0];
        b ^= a >> 1;
        c += a ^ b;
    }
    for (U i = 0; i < (n & 3); i++)
        c += p[i] * a;
    return a * 3 + b * 5 + c;
}

// The same function without the copies.
static U plain(const volatile U* p, U n) {
    U a = n, b = p[1], c = n * 7;
    if (p[0] == 77) {
        U t = a;
        a = b;
        b = c;
        c = t;
    } else {
        a = a * 3 + p[0];
        b ^= a >> 1;
        c += a ^ b;
    }
    for (U i = 0; i < (n & 3); i++)
        c += p[i] * a;
    return a * 3 + b * 5 + c;
}

int main() {
    for (int i = 0; i < 64; i++)
        vin[i] = i * 37 % 150 + 1;
    U r = mix(vin, 3), expect = plain(vin, 3);
    vin[0] = 77;
    r = r * 31 + mix(vin, 6);
    expect = expect * 31 + plain(vin, 6);
    return r == expect ? 42 : 1;
}
