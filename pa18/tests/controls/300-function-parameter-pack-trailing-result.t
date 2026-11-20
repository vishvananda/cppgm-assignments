// expect exit 0
template<class T> T&& declval();

template<bool...> struct Result {};
template<int N> struct Item { static constexpr bool value = N > 0; };

struct Predicate {
  template<class T> T operator()(T) const;
};

template<class F> struct Inspect {
  template<class... T>
  auto operator()(T&&... items) const
    -> Result<decltype(declval<F>()(static_cast<T&&>(items)))::value...> {
    return {};
  }
};

int check(Result<true, false>) { return 0; }
int check_empty(Result<>) { return 0; }

int main() {
  return check(Inspect<Predicate>{}(Item<1>{}, Item<0>{}))
    + check_empty(Inspect<Predicate>{}());
}
