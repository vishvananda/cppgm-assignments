// A name operand of a trailing requires-clause is an id-expression: the brace after it opens the body; expect exit 0
template<class T> struct Base { static constexpr bool enabled = sizeof(T) > 1; };
template<class T> struct Derived : Base<T> {
  using base = Base<T>;
  int get() requires base::enabled { return 1; }
  int get() requires (!base::enabled) { return 2; }
};
int main() { return Derived<int>().get() + Derived<char>().get() - 3; }
