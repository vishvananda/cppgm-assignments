// expect exit 0
constexpr int sum(int n) {
  int total = 0;
  for (int i = 0; i < n; ++i) total += i;
  return total;
}
static_assert(sum(4) == 6, "constexpr local variables and loops");
int main() { return sum(4) - 6; }
