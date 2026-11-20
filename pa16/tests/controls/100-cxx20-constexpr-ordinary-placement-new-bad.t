// N4861 [expr.const]
// expect reject

void* operator new(decltype(sizeof(0)), void* address) noexcept {
  return address;
}

constexpr int replace() {
  int value = 0;
  int* replacement = ::new (&value) int(42);
  return *replacement;
}

static_assert(replace() == 42);
