// A lambda result deduced against a constrained placeholder; expect reject
template <class T> concept Integral = requires(T v) { v % v; };
int main() {
  auto f = []() -> Integral auto { return 1.5; };
  return f();
}
