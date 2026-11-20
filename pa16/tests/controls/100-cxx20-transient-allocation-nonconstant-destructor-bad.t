// N4861 [expr.const]
// expect reject

void runtime_only();

struct Object {
  bool runtime;
  constexpr ~Object() {
    if (runtime)
      runtime_only();
  }
};

constexpr int evaluate(bool runtime) {
  auto* value = new Object{runtime};
  delete value;
  return 7;
}

static_assert(evaluate(false) == 7);
static_assert(evaluate(true) == 7);
