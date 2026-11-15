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

struct Base { int value; auto operator<=>(const Base&) const = default; };
struct Derived : Base { int values[2][2]; auto operator<=>(const Derived&) const = default; };
constexpr Derived a{{1},{{2,3},{4,5}}}, b{{1},{{2,3},{4,6}}};
static_assert(a < b);
static_assert(a == a);
static_assert(a != b);
template<class T> struct Box { T value; auto operator<=>(const Box&) const = default; };
static_assert(Box<int>{2} < Box<int>{3});
static_assert(Box<int>{2} == Box<int>{2});
struct Legacy { int v; friend constexpr bool operator==(Legacy a,Legacy b) { return a.v==b.v; } friend constexpr bool operator<(Legacy a,Legacy b) { return a.v<b.v; }};
struct Fallback { Legacy value; std::strong_ordering operator<=>(const Fallback&) const = default; };
static_assert(Fallback{{1}} < Fallback{{2}});
struct Ref { int& value; bool operator==(const Ref&) const = default; };
template<class T> concept Eq = requires(const T& a,const T& b) { a == b; };
static_assert(!Eq<Ref>);
struct Union { union {int a; long b;}; bool operator==(const Union&) const = default; };
static_assert(!Eq<Union>);
constexpr int* null = nullptr;
static_assert((null <=> null) == 0);
int main() { return !(a < b); }
