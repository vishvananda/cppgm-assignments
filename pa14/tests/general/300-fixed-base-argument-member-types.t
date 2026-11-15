// N3485 10.2, 14.7.1: a base that is a specialization of a template inheriting
// a parameter gives the class its argument's members. Their type names are used
// where no second reading of a statement settles them: a parameter of an
// out-of-class member definition and a qualified name after `const`.
template<class Self, class Parent> struct Extends : Parent {};
struct Root { typedef long Wide; };
struct Stream {
  int total;
  void add(int n) { total += n; }
};
struct Extension : Extends<Extension, Root> {
  typedef Stream Builder;
  int state() const { return 5; }
};
struct Tested : Extends<Tested, Extension> {
  void hash(Builder &builder) const;
  void widen(Wide &wide) const;
};
void Tested::hash(Builder &builder) const { builder.add(state()); }
void Tested::widen(Wide &wide) const { wide += 1; }
template<class StateTy, class Base> struct Wrapper : Base, StateTy {
  typedef StateTy StateType;
  const StateType &get() const { return *this; }
};
struct Known { int known; };
template<class Kind, class Base, class Self> struct Attribute : Base {};
struct Align : Attribute<int, Wrapper<Known, Root>, Align> {};
int read(const Align &align) {
  const Align::StateType &state = align.get();
  return state.known;
}
int main() {
  Stream stream = {0};
  Tested tested;
  tested.hash(stream);
  long wide = 3;
  tested.widen(wide);
  Align align;
  align.known = 2;
  return stream.total + read(align) + wide == 11 ? 0 : 1;
}
