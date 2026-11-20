// N4861 [expr.const]. must be rejected
constexpr int checked() {
  try {
    throw 7;
  } catch (int code) {
    return code;
  }
}

static_assert(checked() == 7);
