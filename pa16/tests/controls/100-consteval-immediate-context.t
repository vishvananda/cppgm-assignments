// C++20 [expr.const]: parameter reads and function pointers stay inside
// the evaluation of the outer immediate invocation.
// expect exit 0
consteval int answer() { return 42; }
using Function = int (*)();
consteval Function pointer() { return &answer; }
consteval int apply(int (*p)() = pointer()) { return p(); }
consteval int nested(int n) { return n + apply(pointer()); }
int main() { return apply(&answer) == 42 && nested(3) == 45 ? 0 : 1; }
