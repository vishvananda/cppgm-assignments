// expect reject
consteval int square(int n) { return n * n; }
int result(int n) { return square(n); }
