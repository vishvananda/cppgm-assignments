// expect reject
struct Value { int n; consteval Value(int value) : n(value) {} };
struct Derived : Value { using Value::Value; };
int result(int n) { Derived value(n); return value.n; }
