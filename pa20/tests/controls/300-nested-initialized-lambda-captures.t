struct Copy {
  static int copies;
  int n;
  explicit Copy(int value) : n(value) {}
  Copy(const Copy& other) : n(other.n) { ++copies; }
};
int Copy::copies = 0;

struct Parent {
  int value;

  auto make() {
    return [state = Copy(value)] {
      return [state] { return state.n; };
    };
  }
};

int main() {
  Parent parent{20};
  auto outer = parent.make();
  parent.value = 17;
  auto inner = outer();
  if (inner() != 20 || Copy::copies != 1)
    return 1;

  auto generic = [current = 20](auto increment) mutable {
    auto change = [&current, increment] { current += increment; };
    change();
    return current;
  };
  return generic(3) == 23 && generic(4) == 27 ? 0 : 2;
}
