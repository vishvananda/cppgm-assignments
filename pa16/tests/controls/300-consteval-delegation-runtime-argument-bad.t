// expect reject
struct Value { int n; consteval Value(int value) : n(value) {} Value(long n) : Value(int(n)) {} };
