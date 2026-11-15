// The specialization checks the type-constraint with its own deduced type; expect reject
template <class T> concept Integral = requires(T v) { v % v; };
struct Fn {
  template <class T> constexpr Integral auto operator()(T&& t) const { return t.size(); }
};
struct B { double size() const { return 3; } };
int main() { return Fn()(B()); }
