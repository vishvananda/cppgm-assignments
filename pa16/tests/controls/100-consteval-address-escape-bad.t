// expect reject
consteval int answer() { return 42; }
int (*pointer)() = &answer;
