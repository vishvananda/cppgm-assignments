// expect exit 0
// P0136R1 [class.inhctor.init]

int evaluations = 0;

int argument(int value) {
  ++evaluations;
  return value;
}

struct Root {
  int value;
  explicit Root(int input) : value(input) {}
  virtual ~Root() {}
};

struct Ordinary {
  int other = 9;
};

struct Middle : Ordinary, virtual Root {
  using Root::Root;
};

struct Bottom : Middle {
  using Middle::Middle;
};

struct BothVirtual : virtual Middle {
  using Middle::Middle;
};

struct Explicit : Middle {
  Explicit() : Root(45), Middle(argument(99)) {}
};

struct Delegating : virtual Root {
  using Root::Root;
  Delegating() : Delegating(argument(46)) {}
};

struct MoreDerived : Delegating {
  MoreDerived() : Root(47), Delegating() {}
};

int main() {
  Middle first(argument(42));
  Bottom second(argument(43));
  BothVirtual third(argument(44));
  Explicit fourth;
  Delegating fifth;
  MoreDerived sixth;
  return first.value == 42 && second.value == 43 && third.value == 44 &&
      fourth.value == 45 && fifth.value == 46 && sixth.value == 47 &&
      third.other == 9 && evaluations == 4 ? 0 : 1;
}
