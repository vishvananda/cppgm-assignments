// expect exit 0
// N3485 focus: [over.match.oper], [temp.arg.nontype], and [temp.dep.constexpr].

namespace options {
enum class Mode { read = 1, write = 2, both = 3 };
constexpr Mode operator|(Mode lhs, Mode rhs) {
  return static_cast<Mode>(static_cast<int>(lhs) | static_cast<int>(rhs));
}
constexpr bool operator==(Mode lhs, Mode rhs) {
  return static_cast<int>(lhs) == static_cast<int>(rhs) || static_cast<int>(lhs) == 3;
}
constexpr bool operator!(Mode mode) { return static_cast<int>(mode) == 1; }
constexpr bool operator&&(bool lhs, Mode rhs) { return !lhs && !rhs; }
}

using options::Mode;
template<int I, Mode M, bool Readable> struct Result {
  static constexpr int value = I + static_cast<int>(M) + (Readable ? 10 : 0);
};

template<int I>
struct Fixed : Result<I, Mode::read | Mode::write, !Mode::read> {};

template<int I>
struct Compare : Result<I, Mode::write, Mode::both == Mode::read> {};

template<Mode M>
struct Select : Result<4, M | Mode::write, false && M> {};

static_assert(Fixed<1>::value == 14, "constexpr enum operators");
static_assert(Compare<1>::value == 13, "operator== selected over built-in equality");
static_assert(Select<Mode::read>::value == 17, "overload resolved after substitution");
int main() {}
