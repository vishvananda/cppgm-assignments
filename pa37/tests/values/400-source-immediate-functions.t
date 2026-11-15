struct Pair { int first, second; };
consteval Pair pair(int n) { return Pair{n, n + 1}; }
consteval int square(int n) { return n * n; }
struct Number { int n; consteval operator int() const { return n + 1; } };
extern "C" int immediate(int runtime)
{
  Pair p = pair(8);
  auto next = [](int n) consteval { return n + 1; };
  return p.first + p.second + square(4) + Number{3} + next(2) + runtime;
}

consteval long double fraction() { return 1.5L; }
union Fraction { long double value; unsigned long long words[2]; };
extern "C" unsigned long long immediate_fraction(int high)
{
  Fraction bits;
  bits.value = fraction();
  return bits.words[high];
}
consteval unsigned __int128 wide() { return (static_cast<unsigned __int128>(1) << 100) + 9; }
extern "C" unsigned long long immediate_wide()
{
  return static_cast<unsigned long long>(wide() >> 64);
}

using ImmediateFunction = int (*)();
consteval int answer() { return 42; }
struct ImmediateTag {};
consteval int operator+(ImmediateTag, ImmediateFunction f) { return f(); }
struct ImmediateValue { int n; consteval ImmediateValue(ImmediateFunction f) : n(f()) {} };
int take_immediate(ImmediateValue value) { return value.n; }
extern "C" int immediate_address()
{
  ImmediateValue value(&answer);
  return (ImmediateTag{} + &answer) + value.n + take_immediate(&answer);
}
