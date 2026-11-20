// N4861 [basic.life], [expr.call], and [class.dtor]
// expect exit 0

struct Stamp {
  unsigned* log;
  unsigned digit;
  constexpr ~Stamp() { *log = *log * 10 + digit; }
};

struct Pair {
  Stamp first, second;
  constexpr ~Pair() { *first.log = 3; }
};

union Slot {
  Pair value;
  constexpr Slot(unsigned& log) : value{{&log, 1}, {&log, 2}} {}
  constexpr ~Slot() {}
};

using Integer = int;

union Scalar {
  int value;
  constexpr Scalar() : value(42) {}
  constexpr ~Scalar() {}
};

constexpr unsigned close_pair() {
  unsigned log = 0;
  Slot slot(log);
  slot.value.~Pair();
  return log;
}

constexpr bool close_scalar() {
  Scalar scalar;
  scalar.value.~Integer();
  return true;
}

static_assert(close_pair() == 321);
static_assert(close_scalar());
int main() {}
