int attempts;
int cleaned;
struct Item {
  int n;
  explicit Item(int number) : n(number) {}
  Item(const Item& source) : n(source.n) {
    ++attempts;
    if (n == 2) throw n;
  }
  ~Item() { ++cleaned; }
};
int main() {
  Item values[3] = {Item(1), Item(2), Item(3)};
  try {
    auto [a, b, c] = values;
    return a.n + b.n + c.n;
  } catch (int value) {
    return value == 2 && attempts == 2 && cleaned == 1 ? 0 : 1;
  }
}
