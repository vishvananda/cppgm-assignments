// A constrained placeholder deduces as auto does, then checks its type-constraint; expect exit 0
template <class T> concept Integral = requires(T v) { v % v; };
template <class T, class U> concept SizedAs = sizeof(T) == sizeof(U);
struct Fn {
  template <class T> constexpr Integral auto operator()(T&& t) const { return t.size(); }
};
struct A { int size() const { return 3; } };
Integral auto twice(int v) { return v * 2; }
auto thrice(int v) -> Integral auto { return v * 3; }
template <class T> SizedAs<T> auto same(T v) { return v; }
template <class T> Integral decltype(auto) ref(T& v) { return (v); }
Integral auto global = 4;
template <class T> struct Holder { static constexpr Integral auto value = sizeof(T); };
template <class T> struct Member { Integral auto get() { return T(); } };
int main() {
  Integral auto local = Fn()(A());
  const Integral auto& bound = local;
  int n = 1;
  SizedAs<int> auto sized = 7u;
  auto lambda = [](int v) -> Integral auto { return v; };
  Member<double> unused;
  (void) unused;
  int sum = 0;
  for (Integral auto i = 0; i < 2; ++i)
    sum += i;
  if (Integral auto c = lambda(5))
    sum += c;
  return local + twice(1) + thrice(1) + same(2L) + ref(n) + global + bound + sized + Holder<int>::value + sum +
    Member<int>().get() - 3 - 2 - 3 - 2 - 1 - 4 - 3 - 7 - sizeof(int) - 6;
}
