// expect exit 0
// CWG 2076 prevents the inner list from converting through Box(int).

template<unsigned Count>
struct Nonempty { using type = void; };

template<>
struct Nonempty<0> {};

struct Value { int field; };

template<class T>
struct Box {
  int stored;

  template<class U = T>
  Box(U&& input) : stored(input.field) {}

  template<class... U, class = typename Nonempty<sizeof...(U)>::type>
  explicit Box(U&&...) : stored(-1) {}
};

int main() {
  Box<Value> direct{{42}};
  Box<Value> copy = {{43}};
  return direct.stored == 42 && copy.stored == 43 ? 0 : 1;
}
