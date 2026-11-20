// N4861 [expr.const] and [class.dtor]
// expect exit 0

struct Digit {
  unsigned* log;
  unsigned digit;
  constexpr ~Digit() { *log = *log * 10 + digit; }
};

struct Base {
  Digit base;
};

struct Object : Base {
  Digit first;
  Digit rest[2];
  constexpr ~Object() {
    // The destructor may allocate and deallocate other storage before the
    // original allocation is released.
    auto* digit = new unsigned(1);
    *first.log = *first.log * 10 + *digit;
    delete digit;
  }
};

constexpr unsigned delete_object() {
  unsigned log = 0;
  auto* value = new Object{{{&log, 5}}, {&log, 4}, {{&log, 3}, {&log, 2}}};
  delete value;
  return log;
}

constexpr unsigned delete_array() {
  unsigned log = 0;
  auto* values = new Digit[3]{{&log, 3}, {&log, 2}, {&log, 1}};
  delete[] values;
  return log;
}

static_assert(delete_object() == 12345);
static_assert(delete_array() == 123);
int main() {}
