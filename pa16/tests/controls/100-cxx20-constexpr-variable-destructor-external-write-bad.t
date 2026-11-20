// N4861 [dcl.constexpr] and [expr.const]
// expect reject

struct Object {
  int* pointer;
  constexpr ~Object() {
    if (pointer)
      *pointer = 9;
  }
};

int external;
constexpr Object empty{nullptr};
constexpr Object writes_outside{&external};
