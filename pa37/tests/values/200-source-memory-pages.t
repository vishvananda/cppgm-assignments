#if !__has_builtin(__builtin_wasm_memory_size) || !__has_builtin(__builtin_wasm_memory_grow)
#error Wasm memory builtins must be available
#endif
typedef __SIZE_TYPE__ size_type;
static_assert(__is_same(decltype(__builtin_wasm_memory_size(0)), size_type), "size type");
static_assert(__is_same(decltype(__builtin_wasm_memory_grow(0, 0)), size_type), "grow type");
template<int Memory> size_type query() { return __builtin_wasm_memory_size(Memory); }
__attribute__((noinline)) static size_type grow_one() { return __builtin_wasm_memory_grow(0, 1); }
extern "C" int observe() {
  size_type before = query<0>();
  if (__builtin_wasm_memory_grow(0, 0) != before) return 1;
  if (__builtin_wasm_memory_grow(0, 1) != before) return 2;
  if (__builtin_wasm_memory_size(0) != before + 1) return 3;
  unsigned char* fresh = (unsigned char*)(before << 16);
  if (fresh[0] != 0 || fresh[65535] != 0) return 4;
  fresh[0] = 37;
  fresh[65535] = 41;
  __builtin_wasm_memory_grow(0, 1);
  if (__builtin_wasm_memory_size(0) != before + 2) return 5;
  if (grow_one() != before + 2 || query<0>() != before + 3) return 6;
  if (fresh[0] != 37 || fresh[65535] != 41) return 7;
  if (__builtin_wasm_memory_grow(0, (size_type)-1) != (size_type)-1) return 8;
  return __builtin_wasm_memory_size(0) != before + 3;
}
