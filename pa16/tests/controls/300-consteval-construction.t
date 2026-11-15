// Direct, default and explicit temporary construction all run in semantics.
// expect exit 0
struct Value
{
  int value;
  consteval Value() : value(4) {}
  consteval Value(int n) : value(n) {}
};
int main()
{
  Value a;
  Value b(5);
  Value c = Value(6);
  a.value = 7;
  return a.value + b.value + c.value == 18 ? 0 : 1;
}
