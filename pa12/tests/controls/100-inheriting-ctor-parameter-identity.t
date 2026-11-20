// expect exit 0
// P0136R1 [class.inhctor.init]

int copies = 0;

struct Argument {
  int value;
  const int* identity;

  explicit Argument(int v) : value(v), identity(&value) {}
  Argument(const Argument& a) : value(a.value), identity(&value) { ++copies; }
};

struct Base {
  bool valid;
  explicit Base(Argument input) : valid(input.value == 42 && input.identity == &input.value) {}
};

struct Derived : Base { using Base::Base; };

int main() {
  Argument source(42);
  Derived value(source);
  return value.valid && copies == 1 ? 0 : 1;
}
