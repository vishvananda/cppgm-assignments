// expect reject
// The == implied by an immediate <=> must remain immediate.
namespace std {
struct strong_ordering {
  signed char value;
  constexpr strong_ordering(int v) : value(v) {}
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
struct Value { int member; consteval auto operator<=>(const Value&) const = default; };
int main() { Value x{1}; x.member = 2; return x == x; }
