// expect exit 0
struct Value { int n; consteval Value(int value) : n(value) {} };
int take(Value value) { return value.n; }
struct Number { int n; consteval operator int() const { return n + 1; } };
int stored = 7;
struct Reference { consteval operator int&() const { return stored; } };
int main()
{
  int value = Number{4};
  int& ref = Reference{};
  ref = 8;
  return take(7) == 7 && value == 5 && Number{3} + 2 == 6 &&
    (true ? Number{4} : Number{5}) + 3 == 8 && stored == 8 ? 0 : 1;
}
