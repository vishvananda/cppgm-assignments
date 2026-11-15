// VALIDATION: compile-pass
namespace std {
struct strong_ordering {
  int guard;
  signed char value;
  static const strong_ordering less, equal, greater;
  friend bool operator==(strong_ordering, strong_ordering) = default;
  friend bool operator==(strong_ordering a, int) { return a.value == 0; }
  friend bool operator<(strong_ordering a, int) { return a.value < 0; }
  friend bool operator>(strong_ordering a, int) { return a.value > 0; }
};
const strong_ordering strong_ordering::less = {71,-1};
const strong_ordering strong_ordering::equal = {71,0};
const strong_ordering strong_ordering::greater = {71,1};
}
struct Value {
  int n;
  friend std::strong_ordering operator<=>(Value a,Value b) { return a.n <=> b.n; }
  friend bool operator==(Value,Value) = default;
};
struct Default {
  int values[2][2];
  std::strong_ordering operator<=>(const Default&) const = default;
  bool operator!=(const Default&) const = default;
};
int calls;
int next() { return ++calls; }
int main() {
  std::strong_ordering result = next() <=> next();
  if (calls != 2 || result.guard != 71 || !(result == std::strong_ordering::less)) return 1;
  Value a{1}, b{2};
  if (!(a < b) || !(b > a) || !(a != b)) return 2;
  Default x{{{1,2},{3,4}}}, y{{{1,2},{3,5}}};
  return !(x < y) || !(x == x) || !(x != y);
}
