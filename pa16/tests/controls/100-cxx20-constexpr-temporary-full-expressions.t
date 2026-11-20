// N4861 [intro.execution] and [class.temporary]
// expect exit 0

struct Stamp {
  unsigned* log;
  unsigned digit;
  constexpr ~Stamp() { *log = *log * 10 + digit; }
};

constexpr unsigned statements() {
  unsigned log = 0;
  int value = (void(Stamp{&log, 1}), 4);
  if ((void(Stamp{&log, 2}), value) && log == 1)
    log = log * 10 + 3;
  (void(Stamp{&log, 5}), void(Stamp{&log, 4}));
  return log;
}

struct Record {
  unsigned first, second;
  constexpr Record(unsigned& log)
      : first((void(Stamp{&log, 7}), log)), second(log) {}
};

constexpr bool initializer() {
  unsigned log = 1;
  Record record(log);
  return record.first == 1 && record.second == 17;
}

constexpr bool loop() {
  unsigned log = 0;
  for (void(Stamp{&log, 1}); (void(Stamp{&log, 2}), log == 1);
       void(Stamp{&log, 4})) {
    if (log != 12)
      return false;
    log = log * 10 + 3;
  }
  return log == 12342;
}

static_assert(statements() == 12345);
static_assert(initializer());
static_assert(loop());
int main() {}
