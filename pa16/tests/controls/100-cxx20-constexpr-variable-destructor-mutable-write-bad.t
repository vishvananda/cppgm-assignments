// N4861 [expr.const]: only non-mutable subobjects begin their lifetimes in
// the hypothetical destruction of a constexpr variable.
// expect reject

struct Object {
  mutable int value;
  bool modify;
  constexpr ~Object() {
    if (modify)
      value = 9;
  }
};

constexpr Object unchanged{4, false};
constexpr Object writes_mutable{4, true};
