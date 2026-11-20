// N4861 [basic.life] and [expr.const]
// expect reject

using Integer = int;

union Slot {
  int value;
  constexpr Slot() : value(42) {}
  constexpr ~Slot() {}
};

constexpr int stale() {
  Slot slot;
  slot.value.~Integer();
  return slot.value;
}

static_assert(stale() == 42);
