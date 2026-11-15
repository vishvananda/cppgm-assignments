// The type deduced for the variable does not satisfy the type-constraint; expect reject
template <class T> concept Integral = requires(T v) { v % v; };
int main() {
  Integral auto x = 1.5;
  return x;
}
