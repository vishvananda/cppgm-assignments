// N4861 [class.temporary] and [expr.const]
// expect reject

struct Item {
  int value;
  constexpr ~Item() {}
};

constexpr const Item& identity(const Item& ref) { return ref; }

constexpr int dangling() {
  const Item& ref = identity(Item{4});
  return ref.value;
}

static_assert(dangling() == 4);
