// Function names are checked against the selected immediate invocation,
// including overloaded operators and constructor/conversion operands.
// expect exit 0
using Function = int (*)();
consteval int answer() { return 42; }
struct Tag { consteval int operator[](Function f) const { return f(); } };
consteval int operator+(Tag, Function f) { return f(); }
consteval void operator+=(Tag&, Function f) { (void)f(); }
struct Value { int n; consteval Value(Function f) : n(f()) {} };
struct Member { Value value; Member() : value(&answer) {} };
int take(Value value) { return value.n; }
int main()
{
  Tag tag;
  tag += &answer;
  Value direct(&answer);
  Value braced{&answer};
  Value converted = &answer;
  Member member;
  return Tag{} + &answer == 42 && Tag{}[&answer] == 42 &&
    direct.n == 42 && braced.n == 42 && converted.n == 42 &&
    member.value.n == 42 && take(&answer) == 42 ? 0 : 1;
}
