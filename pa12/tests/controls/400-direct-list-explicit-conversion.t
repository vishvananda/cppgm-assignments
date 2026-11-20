// N3485 8.5.4 [dcl.init.list], as clarified by CWG 1467 and 1756.
// Direct-list initialization of a scalar considers an explicit conversion.
// expect exit 0

struct Quantity
{
  int value;
  explicit operator int() const { return value; }
};

struct Container
{
  int value;
  Container(Quantity source) : value{source} {}
};

int main()
{
  Quantity low{20};
  Quantity high{50};
  int value{low.value < high.value ? low : high};
  Container other{high};
  return value == 20 && other.value == 50 ? 0 : 1;
}
