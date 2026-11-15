template<class... T> bool check() {
  return requires(T... value) { (value + ...); requires (sizeof...(value) > 0); };
}
template<class... T> bool empty() {
  return requires(T... value) { requires (sizeof...(value) == 0); };
}
int main() { return !check<int, int>() || check<void>() || !empty<>() || empty<int>(); }
