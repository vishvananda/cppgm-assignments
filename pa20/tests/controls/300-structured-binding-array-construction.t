int copies;
struct Element {
  int value;
  explicit Element(int n) : value(n) {}
  explicit Element(Element& other) : value(other.value + 10) {}
  Element(const Element& other) : value(other.value + 20) { ++copies; }
  Element(Element&& other) : value(other.value + 30) { other.value = 0; }
};
using Pair = Element[2];

struct Immovable {
  int value;
  constexpr explicit Immovable(int n) : value(n) {}
  Immovable(const Immovable&) = delete;
};
constexpr int sum_prvalue() {
  using Values = Immovable[2];
  auto [a, b] = Values{Immovable(3), Immovable(4)};
  return a.value + b.value;
}
static_assert(sum_prvalue() == 7);

struct Converted {
  int value;
  explicit Converted(int n) : value(n) {}
  operator int() volatile { return value + 5; }
};

int main() {
  Pair values = {Element(1), Element(2)};
  auto [a, b] = values;
  auto [c, d]{values};
  auto [e, f] = static_cast<Pair&&>(values);
  if (copies != 2 || a.value != 21 || b.value != 22 || c.value != 11 || d.value != 12)
    return 1;
  if (e.value != 31 || f.value != 32 || values[0].value != 0)
    return 2;
  volatile Converted source[] = {Converted(7), Converted(8)};
  auto [g, h](source);
  return g.value == 12 && h.value == 13 ? 0 : 3;
}
