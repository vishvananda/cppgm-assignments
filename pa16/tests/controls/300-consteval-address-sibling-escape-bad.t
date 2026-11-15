// An immediate constructor permits its own argument, not a sibling.
// expect reject
using Function = int (*)();
consteval int answer() { return 42; }
struct Value { int n; consteval Value(Function f) : n(f()) {} };
struct Mixed { Function escaped; Value good; };
int main() { Mixed value{&answer, Value(&answer)}; return value.good.n; }
