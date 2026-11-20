using Pair = int[2];
const int values[2] = {30, 40};
auto [g0, g1] = values;
int source_calls;
Pair source_pair = {21, 22};
Pair& get() { ++source_calls; return source_pair; }

constexpr bool check_constant() {
  int original[2] = {2, 5};
  auto [left, right] = original;
  left = 10;
  return left == 10 && right == 5 && original[0] == 2;
}
static_assert(check_constant());

int main() {
  auto [a, b](get());
  auto [c, d]{get()};
  if (source_calls != 2 || a != 21 || b != 22 || c != 21 || d != 22 || g0 != 30 || g1 != 40)
    return 1;
  a = 7;
  c = 8;
  if (source_pair[0] != 21 || a != 7 || c != 8)
    return 2;
  int matrix[2][2] = {{1, 2}, {3, 4}};
  int sum = 0;
  for (auto [first, second] : matrix) {
    first += second;
    sum += first;
  }
  return sum == 10 && matrix[0][0] == 1 && matrix[1][0] == 3 ? 0 : 3;
}
