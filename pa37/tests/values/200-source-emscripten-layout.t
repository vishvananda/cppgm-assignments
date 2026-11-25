#include <stddef.h>
#include <stdint.h>
#include <limits.h>
#if !defined(__EMSCRIPTEN__) || !defined(__unix__) || defined(__wasi__) || defined(__x86_64__)
#error incorrect target predefines
#endif
static_assert(sizeof(long double) == 16 && alignof(long double) == 8, "Emscripten long double");
static_assert(sizeof(__float128) == 16 && alignof(__float128) == 8, "binary128 floating alignment");
static_assert(sizeof(max_align_t) == 24 && alignof(max_align_t) == 8, "Emscripten max_align_t");
static_assert(sizeof(__int128) == 16 && alignof(__int128) == 16, "integer alignment is independent");
static_assert(sizeof(long) == 4 && sizeof(void*) == 4, "wasm32 model");
static_assert(__is_same(int64_t, long long) && __is_same(intmax_t, long long), "64-bit integer types");
static_assert(__is_same(intptr_t, long) && __is_same(size_t, unsigned long), "pointer-sized types");
static_assert(INT32_MIN == INT_MIN && UINT32_MAX == UINT_MAX && INTMAX_MAX == LLONG_MAX, "integer limits");
static_assert(INT16_C(29) == 29 && UINT64_C(0xffffffffffffffff) == UINTMAX_MAX, "integer constants");
struct Record { char lead; long double value; char tail; };
static_assert(sizeof(Record) == 32 && alignof(Record) == 8, "record layout");
static_assert(offsetof(Record, value) == 8 && offsetof(Record, tail) == 24, "member offsets");
static int initializations;
static int initialize() { ++initializations; return 41; }
static int initialized = initialize();
extern "C" int observe() {
  Record record = {7, 1.5L, 11};
  unsigned long long bits[2] = {};
  __builtin_memcpy(bits, &record.value, 16);
  return initialized != 41 || initializations != 1 || record.lead != 7 || record.tail != 11 ||
         bits[0] != 0 || bits[1] != 0x3fff800000000000ULL;
}
