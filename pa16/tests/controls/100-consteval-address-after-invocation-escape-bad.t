// expect reject
using Function = int (*)();
consteval int answer() { return 42; }
consteval int apply(Function f) { return f(); }
int main() { Function escaped = (apply(&answer), &answer); return escaped(); }
