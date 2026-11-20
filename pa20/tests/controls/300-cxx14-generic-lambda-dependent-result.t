// expect exit 0
// N4140 [expr.prim.lambda], [basic.scope.proto], and [temp.deduct]

template<class T> T&& declval();
template<class T> struct RemoveReference { using Type = T; };
template<class T> struct RemoveReference<T&> { using Type = T; };
template<class T> struct RemoveReference<T&&> { using Type = T; };
template<class T> using Object = typename RemoveReference<T>::Type;

struct HasValue { static constexpr int value = 42; };
struct NoValue {};

template<class F, class T> auto accepts(int) -> decltype(declval<F>()(declval<T>()), char(0));
template<class F, class T> long accepts(...);

int main() {
  auto member = [](auto&& object) -> decltype(Object<decltype(object)>::value) {
    return Object<decltype(object)>::value;
  };
  static_assert(sizeof(accepts<decltype(member), HasValue>(0)) == sizeof(char), "valid call");
  static_assert(sizeof(accepts<decltype(member), NoValue>(0)) == sizeof(long), "substitution failure");
  return member(HasValue{}) != 42;
}
