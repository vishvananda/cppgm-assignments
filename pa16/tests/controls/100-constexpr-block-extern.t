// expect exit 0
// N4140 [basic.link] and [expr.const]: a block-scope extern declaration
// can name an existing object without starting a new lifetime.
int value = 7;

constexpr int* address() {
  extern int value;
  return &value;
}

constexpr int* pointer = address();

int main() {
  return pointer == &value && *pointer == 7 ? 0 : 1;
}
