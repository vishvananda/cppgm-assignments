// expect exit 0
// N4140 [dcl.constexpr] and [expr.const]

struct Item { int value; };

template<int Number>
struct Constant {
  static constexpr Item item = {Number};
};

int read(const Item& item) { return item.value; }

int main() {
  constexpr Item local = Constant<42>::item;
  return read(local) == 42 ? 0 : 1;
}
