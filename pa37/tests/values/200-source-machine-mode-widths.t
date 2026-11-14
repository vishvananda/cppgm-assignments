typedef int Wide __attribute__((mode(DI)));
typedef unsigned int UWide __attribute__((mode(__DI__)));
#ifndef __clang__
typedef int Compare __attribute__((mode(__libgcc_cmp_return__)));
static_assert(sizeof(Compare) == 4, "Wasm comparison results use int");
#endif
static_assert(sizeof(Wide) == 8 && sizeof(UWide) == 8, "DI is 64 bits on wasm32");
extern "C" int observe(int input) {
  UWide value = (UWide(1) << 40) + input;
  return int(value >> 40);
}
