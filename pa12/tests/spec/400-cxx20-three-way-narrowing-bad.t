// VALIDATION: compile-fail
namespace std {
struct strong_ordering {
  signed char value;
  static const strong_ordering less, equal, greater;
};
}
void compare(int x) { x <=> 0u; }
