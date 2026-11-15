// A lambda parameter's name ends with the lambda, also when the declaration is read twice; expect exit 0
struct Value { int n; };
struct Twine { int n; };
int main() {
  auto twice = [](int Value) { return Value * 2; };
  Value* p = nullptr;
  Value v = {twice(2)};
  p = &v;
  auto add = [&](const Twine& Value) { return Value.n + p->n; };
  if (const Value* q = p)
    return add(Twine{1}) - 5 + (q->n - 4);
  return 1;
}
