// expect exit 0
int main()
{
  auto next = [](int n) consteval { return n + 1; };
  auto twice = [](auto n) consteval { return n + n; };
  return next(4) == 5 && twice(3) == 6 && twice(5L) == 10 ? 0 : 1;
}
