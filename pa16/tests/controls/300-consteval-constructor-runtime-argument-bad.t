// expect reject
struct Value { int value; consteval Value(int n) : value(n) {} };
int result(int n) { Value value(n); return value.value; }
