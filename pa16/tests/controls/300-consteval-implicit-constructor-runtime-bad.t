// expect reject
struct Value { int n; consteval Value(int value) : n(value) {} };
int take(Value value) { return value.n; }
int result(int n) { return take(n); }
