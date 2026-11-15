// expect exit 0
struct Value { int n; consteval Value(int value) : n(value) {} Value() : Value(4) {} };
struct Member { Value value; Member() : value(5) {} };
struct Inherited : Value { using Value::Value; };
int main() { Value a; Member b; Inherited c(6); return a.n + b.value.n + c.n == 15 ? 0 : 1; }
