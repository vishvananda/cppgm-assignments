// A constant-evaluable ordinary operator is not an immediate invocation.
// expect reject
using Function = int (*)();
consteval int answer() { return 42; }
struct Tag {};
constexpr int operator+(Tag, Function f) { return f(); }
int main() { return Tag{} + &answer; }
