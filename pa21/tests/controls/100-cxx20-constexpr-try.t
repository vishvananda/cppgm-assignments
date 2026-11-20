// N4861 [dcl.constexpr] and [expr.const]. expect exit 0
constexpr int checked(bool invalid) {
  try {
    if (invalid)
      throw 7;
    int values[] = {8, 13};
    return values[0] + values[1];
  } catch (int code) {
    return code;
  }
}

constexpr int wrapped() try {
  return checked(false) * 2;
} catch (...) {
  return 0;
}

struct Number {
  int value;
  constexpr Number(int input) try : value(input) {} catch (...) { throw; }
};

static_assert(wrapped() == 42);
static_assert(Number(9).value == 9);

int main() { return checked(true) == 7 ? 0 : 1; }
