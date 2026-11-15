template<class T> concept Integral = requires(T value) { value % 1; };
constexpr auto checked = []<class T> requires Integral<T> (T x,auto y) { return x+y; };
template<class F> concept RejectsDouble = !requires(F f) { f(1.0,2); };
static_assert(RejectsDouble<decltype(checked)>);
static_assert(checked.operator()<int,long>(1,2) == 3);
template<int N> constexpr auto factory() {
  return []<class T> requires (sizeof(T)==N) (T x) { return x; };
}
static_assert(factory<sizeof(int)>()(3) == 3);
template<class F> concept AcceptsInt = requires(F f) { f(1); };
static_assert(AcceptsInt<decltype(factory<sizeof(int)>())>);
static_assert(!AcceptsInt<decltype(factory<sizeof(int)+1>())>);
constexpr auto poison = []<class T> requires false (T x) { return T::absent; };
static_assert(!AcceptsInt<decltype(poison)>);
int main() {
  int base=7;
  auto f=[base]<class T> requires Integral<T> (T x) mutable { return base+=x; };
  return f(2)!=9 || f(3)!=12;
}
