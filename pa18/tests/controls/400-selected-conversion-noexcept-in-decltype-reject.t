// expect reject
struct Field {};
struct Aggregate { Field field; };

template<class T> constexpr bool verify() {
  static_assert(sizeof(T) == 0, "the selected exception specification is needed");
  return true;
}

struct Initializer {
  template<class T> operator T() const noexcept(verify<T>());
};

typedef decltype(Aggregate{Initializer{}}) Result;
