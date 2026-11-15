// C++20 [expr.const]: immediate invocations keep complete typed values.
// expect exit 0
consteval int square(unsigned char n) { return n * n; }
consteval int next(int n) { return square(n) + 1; }
consteval double half(int n) { return n / 2.0; }
struct Pair { int first, second; };
consteval Pair pair(int n) { return Pair{n, n + 1}; }
consteval Pair operator ""_pair(unsigned long long n) { return pair(int(n)); }
int stored = 4;
consteval int* address() { return &stored; }
consteval int& reference() { return stored; }
void runtime();
consteval void require_four(int n) { if (n != 4) runtime(); }
int main()
{
  Pair p = pair(8);
  Pair literal = 3_pair;
  require_four(4);
  reference() = 5;
  return square(259) == 9 && next(3) == 10 && half(7) == 3.5 &&
    p.first == 8 && p.second == 9 && literal.second == 4 && *address() == 5 ? 0 : 1;
}
