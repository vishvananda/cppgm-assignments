// VALIDATION: compile-fail
namespace std {
struct strong_ordering {
  signed char value;
  static const strong_ordering less, equal, greater;
};
}
int main() { int a[2], b[2]; a <=> b; }
