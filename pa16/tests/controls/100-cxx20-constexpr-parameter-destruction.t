// N4861 [expr.call] and [class.temporary]
// expect exit 0

struct Allocation {
  unsigned* storage;
  constexpr Allocation(unsigned value) : storage(new unsigned(value)) {}
  Allocation(const Allocation&) = delete;
  constexpr ~Allocation() { delete storage; }
};

constexpr unsigned use(Allocation parameter) { return *parameter.storage; }

struct Stamp {
  unsigned* log;
  unsigned digit;
  constexpr ~Stamp() { *log = *log * 10 + digit; }
};

constexpr unsigned update(Stamp parameter, unsigned& log) {
  parameter.digit = 3;
  log = log * 10 + 2;
  return log;
}

constexpr bool call() {
  unsigned log = 1;
  const unsigned returned = update(Stamp{&log, 4}, log);
  return returned == 12 && log == 123;
}

static_assert(use(Allocation(42)) == 42);
static_assert(call());
int main() {}
