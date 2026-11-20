// expect exit 0
// N4659 [expr.prim.lambda], [expr.prim.fold], and [temp.variadic]

template<class T>
int sum(T first) {
  decltype(auto) combine = [](auto... numbers) { return (0 + ... + numbers); };
  return combine(first, 5) + combine();
}

int main() { return sum(37) != 42; }
