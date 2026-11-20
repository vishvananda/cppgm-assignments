namespace A {
  int pick(int);
  int pick(long);
}
namespace B {
  int pick(int);
  int pick(char);
}

using A::pick;
using B::pick;
using A::pick;

int from_a() { return pick(1L); }
int from_b() {
  using A::pick;
  using B::pick;
  return pick('a');
}
