// constinit controls initialization, not later mutability or constant use.
// expect exit 0
constexpr int initial() { return 4; }
constinit int count = initial();
int main()
{
  static constinit int local = 6;
  ++count;
  ++local;
  return count + local == 12 ? 0 : 1;
}
