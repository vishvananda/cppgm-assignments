// expect reject
consteval int answer() { return 42; }
using Function = int (*)();
consteval Function pointer() { return &answer; }
Function escaped = pointer();
