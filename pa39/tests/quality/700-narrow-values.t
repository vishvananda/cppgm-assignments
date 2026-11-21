// Narrow values whose readers take only their low bits are not extended
// after each operation, a literal copy is not extended again, and a sign
// extension of a load is a sign-extending load. The other functions keep
// values whose readers need the extension (compares, returns, calls,
// divisions), take parameters whose high bits the caller leaves undefined,
// and load at offsets that need each signed load form. A range test of a
// loaded byte or halfword subtracts from the load as it is.
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned uint32_t;
typedef unsigned long uint64_t;

extern "C" {
short sum16(const short* p, int n) {
    short s = 0;
    for (int i = 0; i < n; ++i)
        s += p[i];
    return s;
}
uint8_t divided(const uint8_t* p, int n, int a, int b) {
    uint8_t s = 0;
    for (int i = 0; i < n; ++i)
        s += (uint8_t)(p[i] / a / b);
    return s;
}
int parity(const uint8_t* p, int n) {
    uint8_t x = 0;
    for (int i = 0; i < n; ++i)
        x ^= p[i];
    return x == 0x5a;
}
void store16(short* p, short a, short b) { *p = a + b; }
int add32(int a, int b) { return a + b; }
unsigned literal() {
    unsigned x = 5000;
    return x;
}
long sext16(const short* p) { return *p; }
long sext8(const signed char* p, long i) { return p[i]; }
long sext32(const int* p, long i) { return p[i]; }
long sext32_back(const int* p) { return p[-3]; }
long sext16_far(const short* p) { return p[5000]; }
int sdiv16(const short* p, short d) { return *p / d; }
int widen16(short a) { return a; }
unsigned widen8(uint8_t a) { return a; }
int mixed16(short a, short b) {
    short c = a * 3 + b;
    return c;
}
unsigned shifted16(uint16_t a) {
    uint16_t b = a << 3;
    return b >> 2;
}
short negated16(short a) { return -a; }
uint16_t inverted16(uint16_t a) { return ~a; }
uint32_t low_sum(uint64_t a, uint32_t b) {
    uint32_t t = (uint32_t)a;
    return t + b;
}
void store_sum8(uint8_t* p, uint8_t a, uint8_t b) { *p = a + b; }
void mark(const uint8_t* p, int* out) {
    if ((uint8_t)(p[0] - 1) < 3)
        *out = 1;
}
void mark_half(const uint16_t* p, int* out) {
    if ((uint16_t)(p[0] - 100) < 900)
        *out = 1;
}
}
