// expect exit 0
template<unsigned... I> struct Index {};
template<unsigned... I> struct Dispatcher {
  template<class F, class... V>
  static constexpr decltype(auto) dispatch(F f, V... v) { return f(v...); }
};
template<class F, class... V, unsigned... I>
static constexpr auto make_dispatch(Index<I...>) {
  return Dispatcher<I...>::template dispatch<F, V...>;
}
template<class F, class... V, unsigned... I>
static constexpr auto make_matrix(Index<I...> i) {
  return make_dispatch<F, V...>(i);
}
struct Call { constexpr int operator()() const { return 42; } };
int main() { return make_matrix<Call>(Index<>{})(Call{}) != 42; }
