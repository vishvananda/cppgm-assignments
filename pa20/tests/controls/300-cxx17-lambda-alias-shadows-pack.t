// expect exit 0
// N4659 [basic.scope.pdecl], [expr.prim.lambda], and [temp.variadic]

template<class T> struct Object { using Type = T; };
template<class T> struct Object<T&> { using Type = T; };
template<int Key> struct Entry { static constexpr int key = Key; };

template<class F, class... T>
bool visit(F function, T&... objects) { return function(objects...); }

template<class... T>
bool contains_key(int key, T&... objects) {
  return visit([key](auto&... entries) {
    auto matches = [key](auto& entry) {
      using entries = typename Object<decltype(entry)>::Type;
      return entries::key == key;
    };
    return (matches(entries) || ...);
  }, objects...);
}

int main() {
  Entry<1> first;
  Entry<42> second;
  return contains_key(42, first, second) && !contains_key(7, first, second) && !contains_key(42) ? 0 : 1;
}
