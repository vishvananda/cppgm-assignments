static_assert(sizeof(_Float64x) == 16 && alignof(_Float64x) == 16, "wasm binary128 extension");
extern "C" int observe() {
  _Float64x value = 1.5f64x;
  unsigned long long bits[2];
  __builtin_memcpy(bits, &value, 16);
  return bits[0] != 0 || bits[1] != 0x3fff800000000000ULL;
}
