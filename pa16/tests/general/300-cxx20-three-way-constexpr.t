// VALIDATION: compile-pass
namespace std {
struct strong_ordering {
  int padding;
  signed char value;
  constexpr strong_ordering(int v) : padding(71), value(v) {}
  static const strong_ordering less, equal, greater;
  friend constexpr bool operator==(strong_ordering, strong_ordering) = default;
  friend constexpr bool operator<(strong_ordering a, int) { return a.value < 0; }
  friend constexpr bool operator>(strong_ordering a, int) { return a.value > 0; }
  friend constexpr bool operator==(strong_ordering a, int) { return a.value == 0; }
};
inline constexpr strong_ordering strong_ordering::less(-1);
inline constexpr strong_ordering strong_ordering::equal(0);
inline constexpr strong_ordering strong_ordering::greater(1);
}
namespace std {
struct partial_ordering {
  signed char value;
  constexpr partial_ordering(int v) : value(v) {}
  static const partial_ordering less, equivalent, greater, unordered;
  friend constexpr bool operator==(partial_ordering,partial_ordering) = default;
};
inline constexpr partial_ordering partial_ordering::less(-1);
inline constexpr partial_ordering partial_ordering::equivalent(0);
inline constexpr partial_ordering partial_ordering::greater(1);
inline constexpr partial_ordering partial_ordering::unordered(-127);
}
static_assert((1.0 <=> 2.0) == std::partial_ordering::less);
static_assert((2 <=> 2.0) == std::partial_ordering::equivalent);
static_assert((3.0f <=> 2.0) == std::partial_ordering::greater);
struct Box {
 int value;
 friend constexpr std::strong_ordering operator<=>(Box a, Box b) { return a.value <=> b.value; }
 friend constexpr bool operator==(Box,Box) = default;
};
static_assert((1 <=> 2) == std::strong_ordering::less);
static_assert((4 <=> 4) == std::strong_ordering::equal);
static_assert(Box{1} < Box{2});
static_assert(Box{1} != Box{2});
struct Default { int value; constexpr auto operator<=>(const Default&) const = default; };
static_assert(Default{1} < Default{2});
// Deleted where defaulted: a declaration that nothing uses is valid.
struct Ref { int& value; constexpr auto operator<=>(const Ref&) const = default; };
enum class E : unsigned { first=1, second=2 };
static_assert((E::first <=> E::second) == std::strong_ordering::less);
constexpr int* null = nullptr;
static_assert((null <=> null) == 0);
static_assert(noexcept(Default{1} == Default{1}));
int calls;
int next() { return ++calls; }
int main() {
 std::strong_ordering x = next() <=> next();
 return calls != 2 || x.value != -1 || x.padding != 71 || !(Box{2} > Box{1});
}
