struct Present { using type = int; int value; };
template<class T> constexpr bool valid = requires(T value) {
  typename T::type;
  { value.value } noexcept;
  requires (sizeof(T) > 0);
};
static_assert(valid<Present> && !valid<int>, "substitution");
extern "C" int requirements(int value) {
  int changed = 0;
  bool unevaluated = requires { ++changed; };
  return (valid<Present> ? 40 : 0) + changed + unevaluated + value;
}
