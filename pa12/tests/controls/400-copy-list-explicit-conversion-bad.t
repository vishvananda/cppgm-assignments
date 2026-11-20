// N3485 8.5.4 [dcl.init.list], as clarified by CWG 1467 and 1756.
// Copy-list initialization of a scalar cannot use an explicit conversion.
// expect reject

struct Quantity
{
  explicit operator int() const { return 20; }
};

int main()
{
  int value = {Quantity{}};
  return value;
}
