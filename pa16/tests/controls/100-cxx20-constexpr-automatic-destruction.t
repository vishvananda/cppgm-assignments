// N4861 [stmt.dcl], [stmt.iter], and [stmt.return]
// expect exit 0

struct Digit {
  unsigned* log;
  unsigned digit;
  constexpr ~Digit() { *log = *log * 10 + digit; }
};

constexpr unsigned reverse_scope_order() {
  unsigned log = 0;
  {
    Digit first{&log, 4}, rest[2]{{&log, 3}, {&log, 2}};
    if (true)
      Digit inner{&log, 1};
    if (log != 1)
      return 0;
  }
  return log;
}

constexpr unsigned leave_loops() {
  unsigned log = 0;
  for (unsigned i = 1; i <= 2; ++i, log = log * 10 + 3)
    Digit body{&log, i};
  for (unsigned i = 0; i < 2; ++i) {
    Digit body{&log, i + 4};
    if (i == 0)
      continue;
    break;
  }
  return log;
}

constexpr unsigned exit_early(unsigned& log) {
  Digit first{&log, 9};
  return log;
}

constexpr bool sequence_return() {
  unsigned log = 1;
  return exit_early(log) == 1 && log == 19;
}

static_assert(reverse_scope_order() == 1234);
static_assert(leave_loops() == 132345);
static_assert(sequence_return());
int main() {}
