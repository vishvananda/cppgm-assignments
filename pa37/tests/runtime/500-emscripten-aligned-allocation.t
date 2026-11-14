namespace std { enum class align_val_t : unsigned long {}; }
static_assert(__STDCPP_DEFAULT_NEW_ALIGNMENT__ == 8, "Emscripten allocation alignment");
static int ordinary_allocations, aligned_allocations, ordinary_deletions, aligned_deletions, destroyed;
static unsigned long seen_alignment, seen_size;
alignas(32) static unsigned char storage[128];
struct alignas(16) Object {
  int value;
  Object() : value(19) {}
  ~Object() { ++destroyed; }
  static void *operator new(unsigned long size) { ++ordinary_allocations; seen_size = size; return storage; }
  static void *operator new(unsigned long size, std::align_val_t alignment) {
    ++aligned_allocations; seen_size = size; seen_alignment = static_cast<unsigned long>(alignment); return storage;
  }
  static void operator delete(void *) noexcept { ++ordinary_deletions; }
  static void operator delete(void *, std::align_val_t alignment) noexcept {
    ++aligned_deletions; seen_alignment += static_cast<unsigned long>(alignment);
  }
};
extern "C" int observe() {
  ordinary_allocations = aligned_allocations = ordinary_deletions = aligned_deletions = destroyed = 0;
  seen_alignment = seen_size = 0;
  Object *object = new Object;
  int value = object->value;
  delete object;
  return value != 19 || ordinary_allocations != 0 || ordinary_deletions != 0 ||
         aligned_allocations != 1 || aligned_deletions != 1 || destroyed != 1 ||
         seen_alignment != 32 || seen_size != 16;
}
