// N4861 [class.temporary] and [expr.const]
// expect reject

void runtime_only();

struct Guard {
  bool bad;
  constexpr ~Guard() {
    if (bad)
      runtime_only();
  }
};

consteval Guard make(bool bad) { return Guard{bad}; }

constexpr bool evaluate(bool bad) {
  if (bad)
    void(make(true));
  else
    void(make(false));
  return true;
}

static_assert(evaluate(false));
static_assert(evaluate(true));
