template<int Size>
struct Result {
  static constexpr int size = Size;
};

constexpr int length(const char* text) {
  return *text ? 1 + length(text + 1) : 0;
}

template<class Function>
auto measure(Function function) {
  return Result<length(function())>{};
}

int main() {
  constexpr auto text = "source";
  auto by_reference = measure([&] { return text; });
  auto by_copy = measure([=] { return text; });
  static_assert(decltype(by_reference)::size == 6, "read the enclosing constant value");
  static_assert(decltype(by_copy)::size == 6, "read the enclosing constant value");
  int count = 0;
  [&] { ++count; }();
  return count == 1 ? 0 : 1;
}
