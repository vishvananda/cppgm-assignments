template<class T, class U> concept Same = __is_same(T,U);
template<class T> concept Integer = __is_integral(T);
template<class T> concept Valid = requires(T value) {
  { value.member } -> Same<int&>;
  { value.run() } noexcept -> Integer;
};
struct Good { int member; int run() noexcept; };
struct Wrong { long member; int run() noexcept; };
static_assert(Valid<Good> && !Valid<Wrong> && !Valid<int>, "return constraints");
extern "C" int concepts(int value) { return (Valid<Good> ? 40 : 0) + Valid<Wrong> + value; }
