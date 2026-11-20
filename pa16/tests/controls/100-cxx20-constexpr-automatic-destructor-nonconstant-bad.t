// N4861 [expr.const] and [stmt.return]
// expect reject

void runtime_only();
struct Guard {
  bool fail;
  constexpr ~Guard() {
    if (fail)
      runtime_only();
  }
};

constexpr int run(bool fail) {
  Guard guard{fail};
  return 42;
}

static_assert(run(false) == 42);
static_assert(run(true) == 42);
int main() {}
