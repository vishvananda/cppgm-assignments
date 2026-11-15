// An ordinary constexpr function is not an immediate function context.
// expect reject
consteval int square(int n) { return n * n; }
constexpr int result(int n) { return square(n); }
