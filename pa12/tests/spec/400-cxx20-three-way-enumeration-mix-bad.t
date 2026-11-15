// VALIDATION: compile-fail
namespace std {
struct strong_ordering {
  signed char value;
  static const strong_ordering less, equal, greater;
};
}
enum E { a }; enum F { b };
void compare() { a <=> b; }
