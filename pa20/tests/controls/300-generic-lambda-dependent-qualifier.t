// expect exit 0
// N4140 [expr.prim.lambda], [dcl.type.simple], and [temp.dep.type]

template<int N> struct Index { static constexpr int value = N; };
template<bool B> constexpr bool flag = B;

int main() {
  auto matches = [](auto expected) {
    return [](auto actual) {
      return flag<decltype(actual)::value == decltype(expected)::value>;
    };
  };
  auto is_three = matches(Index<3>{});
  return is_three(Index<3>{}) && !is_three(Index<4>{}) ? 0 : 1;
}
