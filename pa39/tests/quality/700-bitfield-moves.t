// Shift-and-mask pairs are one bitfield move (SBFX, UBFX, SBFIZ, UBFIZ) and
// a field inserted into a value is BFI or BFXIL, as Clang selects them. The
// other functions check the boundaries: a field that reaches the sign bit,
// a mask that is not one run, a shift past a field, a field wider than the
// shift leaves room for, an insertion whose mask and field differ, and
// 32-bit parameters whose high bits the caller leaves undefined.
extern "C" {
int sfield(int x) { return (x << 20) >> 27; }
long sfield64(long x) { return (x << 20) >> 47; }
int sfield_up(int x) { return (x << 20) >> 15; }
unsigned ufield_up(unsigned x) { return (x << 20) >> 15; }
int sign_bit(int x) { return (x << 31) >> 31; }
unsigned long low63(unsigned long x) { return (x << 1) >> 1; }
unsigned place(unsigned x) { return (x & 0x1f) << 3; }
unsigned place_over(unsigned x) { return (x & 0xffff) << 20; }
unsigned long place64(unsigned long x) { return (x & 0xffff) << 7; }
unsigned shr_and(unsigned x) { return (x & 0xff00) >> 8; }
unsigned shr_inside(unsigned x) { return (x & 0xff00) >> 12; }
int asr_top(int x) { return (x & -65536) >> 16; }
int asr_inside(int x) { return (x & 0x7fff0000) >> 16; }
unsigned split_mask(unsigned x) { return (x & 0xf0f0) >> 4; }
int sext_field(int x) { return (signed char)(x >> 8); }
long sxfield(int x) { return (short)(x >> 3); }
long wide_field(long y) { return (int)(y >> 20); }
int narrow_of_wide(long y) { return (signed char)(y >> 4); }
int too_wide(long y) { return (short)(y >> 40); }
unsigned insert(unsigned a, unsigned b) { return (a & ~0xf0u) | ((b & 0xf) << 4); }
unsigned insert_low(unsigned a, unsigned b) { return (a & ~0xffu) | (b & 0xff); }
unsigned insert_swapped(unsigned a, unsigned b) { return ((b & 0xf) << 4) | (a & ~0xf0u); }
unsigned insert_top(unsigned a, unsigned b) { return (a & 0x0fffffffu) | (b << 28); }
unsigned insert_xor(unsigned a, unsigned b) { return (a & ~0xf00u) ^ ((b & 0xf) << 8); }
unsigned insert_add(unsigned a, unsigned b) { return (a & ~0xf00u) + ((b & 0xf) << 8); }
unsigned insert_self(unsigned a) { return (a & ~0xf0u) | ((a & 0xf) << 4); }
unsigned insert_into_b(unsigned b, unsigned a) { return (a & ~0xf0u) | ((b & 0xf) << 4); }
unsigned long insert64(unsigned long a, unsigned long b) { return (a & ~(0xffffUL << 16)) | ((b & 0xffff) << 16); }
unsigned long insert_high(unsigned long a, unsigned b) { return (a & 0xffffffffUL) | ((unsigned long)b << 32); }
unsigned long insert_top16(unsigned long a, unsigned b) { return (a & 0xffffffffffffUL) | ((unsigned long)b << 48); }
unsigned long overlap(unsigned long a, unsigned long b) { return (a & ~0xf0UL) | ((b & 0x1f) << 4); }
unsigned long short_field(unsigned long a, unsigned long b) { return (a & ~0xff0UL) | ((b & 0xf) << 4); }
}
