// expect exit 0
struct Base { int id; };
struct Key : Base {
  int values[2];
  constexpr bool operator==(const Key&) const { return false; }
};
constexpr Key first{{3}, {4, 0}};
constexpr Key equal{{3}, {4}};
constexpr Key different{{3}, {5}};

template<class, class> constexpr bool same = false;
template<class T> constexpr bool same<T, T> = true;

template<Key K> struct Entry {
  static_assert(same<decltype(K), Key>);
  static_assert(same<decltype((K)), const Key&>);
  static constexpr const Key* key() { return &K; }
};
template<auto K> constexpr const decltype(K)* deduced() { return &K; }

static_assert(same<Entry<first>, Entry<equal>>);
static_assert(!same<Entry<first>, Entry<different>>);
static_assert(Entry<first>::key()->id == 3);
static_assert(Entry<first>::key()->values[0] == 4);
static_assert(Entry<first>::key() == deduced<equal>());

const Key* object() { return Entry<first>::key(); }

int main() {
  return object() != Entry<equal>::key() || object() == Entry<different>::key() ||
         object()->values[0] != 4 || object()->values[1] != 0;
}
