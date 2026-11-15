// expect exit 0
struct Value { int n; consteval int operator+(int a) const { return n + a; } };
consteval int immediate(int n) { return n + 1; }
int runtime();
static_assert(sizeof(immediate(runtime())) == sizeof(int), "unevaluated");
int main() { return Value{3} + 4 == 7 ? 0 : 1; }
