// VALIDATION: compile-pass
struct Ref {
  int& value;
  auto operator<=>(const Ref&) const = default;
};
struct Unordered {};
struct Contains {
  Unordered value;
  auto operator<=>(const Contains&) const = default;
};
int main() { return 0; }
