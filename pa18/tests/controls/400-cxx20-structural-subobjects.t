// expect exit 0
int first = 2;
int second = 3;
int answer() { return 5; }
struct Addresses {
  int* pointer;
  int& reference;
  int (*function)();
};
template<Addresses A> const Addresses* addresses() { return &A; }
constexpr Addresses left{&first, second, answer};
constexpr Addresses equal{&first, second, answer};
constexpr Addresses different{&second, first, answer};

struct Number { double value; };
union Variant { unsigned i; char c; };
template<auto V> constexpr const decltype(V)* value() { return &V; }
static_assert(value<Number{0.0}>() != value<Number{-0.0}>());
static_assert(value<Variant{.i = 0}>() != value<Variant{.c = 0}>());
static_assert(value<Variant{.c = 0}>() == value<Variant{.c = 0}>());

int main() {
  const Addresses* a = addresses<left>();
  return a != addresses<equal>() || a == addresses<different>() ||
         *a->pointer + a->reference + a->function() != 10;
}
