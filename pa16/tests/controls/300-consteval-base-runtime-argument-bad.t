// expect reject
struct Value { int n; consteval Value(int value) : n(value) {} };
struct Derived : Value { Derived(int n) : Value(n) {} };
