// A defaulted three-way comparison that cannot compare its category with 0 is accepted while unused; expect exit 0
namespace std {
struct strong_ordering {
  signed char value;
  static const strong_ordering less, equal, greater;
};
const strong_ordering strong_ordering::less = {-1};
const strong_ordering strong_ordering::equal = {0};
const strong_ordering strong_ordering::greater = {1};
}
struct M {
  int b;
  auto operator<=>(const M&) const = default;
};
int main() { return M{3}.b - 3; }
